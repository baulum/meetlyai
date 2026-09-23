import 'package:uuid/uuid.dart';
import 'package:whisper_ffi/whisper_ffi.dart';

import '../../domain/models/meeting_models.dart';
import '../../domain/services/transcription_engine.dart';

class WhisperFfiTranscriptionEngine implements TranscriptionEngine {
  WhisperFfiTranscriptionEngine({WhisperRuntime? runtime, Uuid? uuid})
    : _runtime = runtime ?? const WhisperRuntime(),
      _uuid = uuid ?? const Uuid();

  final WhisperRuntime _runtime;
  final Uuid _uuid;

  @override
  Stream<TranscriptSegment> transcribe(TranscriptionRequest request) async* {
    final hasSeparateSources =
        request.audioAssets.any(
          (asset) => asset.source == AudioSourceKind.mic,
        ) &&
        request.audioAssets.any(
          (asset) => asset.source == AudioSourceKind.system,
        );
    final files = <WhisperSource, String>{};
    for (final asset in request.audioAssets) {
      if (hasSeparateSources && asset.source == AudioSourceKind.mixed) {
        continue;
      }
      final source = switch (asset.source) {
        AudioSourceKind.mic => WhisperSource.mic,
        AudioSourceKind.system => WhisperSource.system,
        AudioSourceKind.mixed => WhisperSource.mixed,
      };
      files[source] = asset.path;
    }

    await for (final segment in _runtime.transcribe(
      WhisperTranscriptionJob(
        meetingId: request.meetingId,
        modelPath: request.modelPath,
        audioFiles: files,
        languageCode: request.languageCode,
        executablePath: request.executablePath,
      ),
    )) {
      if (segment.text.trim().isEmpty) {
        continue;
      }
      final offsetMs = _offsetFromChunkPath(
        segment.audioPath,
        request.chunkOffsetIntervalMs,
      );

      final source = switch (segment.source) {
        WhisperSource.mic => AudioSourceKind.mic,
        WhisperSource.system => AudioSourceKind.system,
        WhisperSource.mixed => AudioSourceKind.mixed,
      };

      yield TranscriptSegment(
        id: _uuid.v7(),
        meetingId: request.meetingId,
        source: source,
        speakerLabel: source.defaultSpeakerLabel,
        startMs: segment.startMs + offsetMs,
        endMs: segment.endMs + offsetMs,
        text: segment.text,
        confidence: segment.confidence,
      );
    }
  }

  int _offsetFromChunkPath(String path, int? chunkOffsetIntervalMs) {
    final match = RegExp(r'_(\d{6})\.wav$').firstMatch(path);
    if (match == null) {
      return 0;
    }
    final index = int.tryParse(match.group(1) ?? '');
    if (index == null) {
      return 0;
    }
    return index * (chunkOffsetIntervalMs ?? 25000);
  }
}
