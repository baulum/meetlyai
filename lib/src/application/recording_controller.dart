import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../domain/models/meeting_models.dart';
import '../domain/services/audio_recorder.dart';
import '../domain/services/llm_service.dart';
import '../domain/services/meeting_repository.dart';
import '../domain/services/transcription_engine.dart';
import 'providers.dart';

class RecordingUiState {
  const RecordingUiState({
    this.snapshot,
    this.isBusy = false,
    this.errorMessage,
  });

  final RecordingSnapshot? snapshot;
  final bool isBusy;
  final String? errorMessage;

  RecordingUiState copyWith({
    RecordingSnapshot? snapshot,
    bool? isBusy,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RecordingUiState(
      snapshot: snapshot ?? this.snapshot,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class RecordingController extends Notifier<RecordingUiState> {
  final _uuid = const Uuid();
  StreamSubscription<RecordingSnapshot>? _snapshotSubscription;
  StreamSubscription<AudioPcmFrame>? _pcmSubscription;

  @override
  RecordingUiState build() {
    final recorder = ref.watch(audioRecorderProvider);
    _snapshotSubscription = recorder.snapshots.listen((snapshot) {
      state = state.copyWith(snapshot: snapshot, clearError: true);
    });
    _pcmSubscription = recorder.pcmFrames.listen((_) {});
    ref.onDispose(() {
      _snapshotSubscription?.cancel();
      _pcmSubscription?.cancel();
    });
    return const RecordingUiState();
  }

  Future<void> startNewMeeting() async {
    if (state.isBusy) {
      return;
    }
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      final repository = ref.read(meetingRepositoryProvider);
      final recorder = ref.read(audioRecorderProvider);
      final meeting = await repository.createMeeting(title: 'Untitled meeting');
      ref.read(selectedMeetingIdProvider.notifier).select(meeting.id);

      final now = DateTime.now();
      final updated = meeting.copyWith(
        status: MeetingStatus.recording,
        startedAt: now,
      );
      await repository.upsertMeeting(updated);

      final outputDirectory = await _meetingDirectory(meeting.id);
      await recorder.start(
        RecordingRequest(
          meetingId: meeting.id,
          outputDirectory: outputDirectory,
          captureSystemAudio: true,
        ),
      );
      state = state.copyWith(isBusy: false, clearError: true);
    } on Object catch (error) {
      state = state.copyWith(isBusy: false, errorMessage: error.toString());
    }
  }

  Future<void> pauseOrResume() async {
    final snapshot = state.snapshot;
    if (snapshot == null || state.isBusy) {
      return;
    }
    final recorder = ref.read(audioRecorderProvider);
    if (snapshot.status == MeetingStatus.paused) {
      await recorder.resume();
      await _updateMeetingStatus(snapshot.meetingId, MeetingStatus.recording);
    } else if (snapshot.status == MeetingStatus.recording) {
      await recorder.pause();
      await _updateMeetingStatus(snapshot.meetingId, MeetingStatus.paused);
    }
  }

  Future<void> stopAndAnalyze() async {
    final snapshot = state.snapshot;
    if (snapshot == null || state.isBusy) {
      return;
    }
    state = state.copyWith(isBusy: true, clearError: true);
    final repository = ref.read(meetingRepositoryProvider);
    try {
      await _updateMeetingStatus(
        snapshot.meetingId,
        MeetingStatus.transcribing,
      );
      final assets = await ref.read(audioRecorderProvider).stop();
      for (final asset in assets) {
        await repository.saveAudioAsset(asset);
      }

      final meeting = await repository.getMeeting(snapshot.meetingId);
      if (meeting == null) {
        return;
      }

      final ended = DateTime.now();
      await repository.upsertMeeting(
        meeting.copyWith(
          endedAt: ended,
          durationMs: snapshot.elapsed.inMilliseconds,
          status: MeetingStatus.transcribing,
        ),
      );

      final settings = ref.read(settingsRepositoryProvider);
      final modelPath = await settings.getWhisperModelPath();
      final language = await settings.getPreferredLanguage() ?? 'auto';
      if (modelPath != null && modelPath.trim().isNotEmpty) {
        await for (final segment
            in ref
                .read(transcriptionEngineProvider)
                .transcribe(
                  TranscriptionRequest(
                    meetingId: snapshot.meetingId,
                    audioAssets: assets,
                    modelPath: modelPath,
                    languageCode: language,
                  ),
                )) {
          await repository.saveTranscriptSegment(segment);
        }
      }

      final transcript = await repository.getTranscript(snapshot.meetingId);
      if (transcript.isNotEmpty) {
        await _summarize(repository, meeting, transcript);
      } else {
        final preview = modelPath == null || modelPath.trim().isEmpty
            ? 'Recording saved locally. Add a Whisper model path to transcribe.'
            : 'Recording saved locally, but no transcript was produced. '
                  'Check that native audio capture wrote non-empty WAV files '
                  'and that whisper.cpp is installed.';
        await repository.upsertMeeting(
          meeting.copyWith(
            status: MeetingStatus.ready,
            endedAt: ended,
            durationMs: snapshot.elapsed.inMilliseconds,
            summaryPreview: preview,
          ),
        );
      }

      state = const RecordingUiState();
    } on Object catch (error) {
      await _updateMeetingStatus(snapshot.meetingId, MeetingStatus.failed);
      state = state.copyWith(isBusy: false, errorMessage: error.toString());
    }
  }

  Future<void> sendQuestion(String meetingId, String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final repository = ref.read(meetingRepositoryProvider);
    final now = DateTime.now();
    await repository.saveChatMessage(
      ChatMessage(
        id: _uuid.v7(),
        meetingId: meetingId,
        role: ChatRole.user,
        content: trimmed,
        createdAt: now,
      ),
    );

    final assistantId = _uuid.v7();
    var assistantMessage = ChatMessage(
      id: assistantId,
      meetingId: meetingId,
      role: ChatRole.assistant,
      content: '',
      createdAt: DateTime.now(),
      isStreaming: true,
    );
    await repository.saveChatMessage(assistantMessage);

    try {
      final meeting = await repository.getMeeting(meetingId);
      if (meeting == null) {
        throw StateError('Meeting not found.');
      }
      final summary = await repository.getSummary(meetingId);
      final context = await repository.searchTranscript(meetingId, trimmed);
      final messages = await repository.getChatMessages(meetingId);
      final buffer = StringBuffer();
      await for (final chunk
          in ref
              .read(llmServiceProvider)
              .streamMeetingAnswer(
                MeetingChatRequest(
                  meeting: meeting,
                  summary: summary,
                  transcriptContext: context,
                  messages: messages,
                  question: trimmed,
                ),
              )) {
        buffer.write(chunk);
        assistantMessage = assistantMessage.copyWith(
          content: buffer.toString(),
        );
        await repository.saveChatMessage(assistantMessage);
      }
      await repository.saveChatMessage(
        assistantMessage.copyWith(isStreaming: false),
      );
    } on Object catch (error) {
      await repository.saveChatMessage(
        assistantMessage.copyWith(
          content:
              'I could not answer yet. Check your Gemini API key and network connection.\n\n$error',
          isStreaming: false,
        ),
      );
    }
  }

  Future<void> togglePin(Meeting meeting) {
    return ref
        .read(meetingRepositoryProvider)
        .upsertMeeting(meeting.copyWith(isPinned: !meeting.isPinned));
  }

  Future<void> toggleFavorite(Meeting meeting) {
    return ref
        .read(meetingRepositoryProvider)
        .upsertMeeting(meeting.copyWith(isFavorite: !meeting.isFavorite));
  }

  Future<void> renameMeeting(Meeting meeting, String newTitle) {
    return ref
        .read(meetingRepositoryProvider)
        .upsertMeeting(meeting.copyWith(title: newTitle.trim()));
  }

  Future<void> deleteMeeting(String meetingId) {
    return ref.read(meetingRepositoryProvider).deleteMeeting(meetingId);
  }

  Future<void> _summarize(
    MeetingRepository repository,
    Meeting meeting,
    List<TranscriptSegment> transcript,
  ) async {
    await repository.upsertMeeting(
      meeting.copyWith(status: MeetingStatus.summarizing),
    );
    final summary = await ref
        .read(llmServiceProvider)
        .summarizeMeeting(meeting: meeting, transcript: transcript);
    await repository.saveSummary(summary);
  }

  Future<void> _updateMeetingStatus(
    String meetingId,
    MeetingStatus status,
  ) async {
    final repository = ref.read(meetingRepositoryProvider);
    final meeting = await repository.getMeeting(meetingId);
    if (meeting != null) {
      await repository.upsertMeeting(meeting.copyWith(status: status));
    }
  }

  Future<String> _meetingDirectory(String meetingId) async {
    final docs = await getApplicationDocumentsDirectory();
    return p.join(docs.path, 'MeetlyAI', 'meetings', meetingId);
  }
}
