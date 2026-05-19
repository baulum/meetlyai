import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import '../data/repositories/drift_meeting_repository.dart';
import '../data/repositories/secure_settings_repository.dart';
import '../data/services/gemini_llm_service.dart';
import '../data/services/meeting_export_service.dart';
import '../data/services/native_audio_recorder.dart';
import '../data/services/whisper_transcription_engine.dart';
import '../domain/models/meeting_models.dart';
import '../domain/services/audio_recorder.dart';
import '../domain/services/export_service.dart';
import '../domain/services/llm_service.dart';
import '../domain/services/meeting_repository.dart';
import '../domain/services/settings_repository.dart';
import '../domain/services/transcription_engine.dart';
import 'recording_controller.dart';

enum AppSection { meetings, todos, settings }

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final meetingRepositoryProvider = Provider<MeetingRepository>((ref) {
  return DriftMeetingRepository(ref.watch(appDatabaseProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SecureSettingsRepository(ref.watch(appDatabaseProvider));
});

final audioRecorderProvider = Provider<AudioRecorder>((ref) {
  final recorder = NativeAudioRecorderAdapter();
  ref.onDispose(recorder.dispose);
  return recorder;
});

final transcriptionEngineProvider = Provider<TranscriptionEngine>((ref) {
  return WhisperFfiTranscriptionEngine();
});

final llmServiceProvider = Provider<LlmService>((ref) {
  return GeminiLlmService(ref.watch(settingsRepositoryProvider));
});

final exportServiceProvider = Provider<ExportService>((ref) {
  return MeetingExportService();
});

final meetingSearchProvider = NotifierProvider<MeetingSearchController, String>(
  MeetingSearchController.new,
);

final selectedMeetingIdProvider =
    NotifierProvider<SelectedMeetingController, String?>(
      SelectedMeetingController.new,
    );

final appSectionProvider = NotifierProvider<AppSectionController, AppSection>(
  AppSectionController.new,
);

class AppSectionController extends Notifier<AppSection> {
  @override
  AppSection build() => AppSection.meetings;

  void showMeetings() => state = AppSection.meetings;
  void showTodos() => state = AppSection.todos;
  void showSettings() => state = AppSection.settings;
}

final sidebarCollapsedProvider =
    NotifierProvider<SidebarCollapsedController, bool>(
      SidebarCollapsedController.new,
    );

class SidebarCollapsedController extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final meetingsProvider = StreamProvider<List<Meeting>>((ref) {
  final query = ref.watch(meetingSearchProvider);
  return ref.watch(meetingRepositoryProvider).watchMeetings(query: query);
});

final allMeetingsProvider = StreamProvider<List<Meeting>>((ref) {
  return ref.watch(meetingRepositoryProvider).watchMeetings();
});

final selectedMeetingProvider = FutureProvider<Meeting?>((ref) {
  final id = ref.watch(selectedMeetingIdProvider);
  if (id == null) {
    return Future.value();
  }
  return ref.watch(meetingRepositoryProvider).getMeeting(id);
});

final transcriptProvider =
    StreamProvider.family<List<TranscriptSegment>, String>((ref, meetingId) {
      return ref.watch(meetingRepositoryProvider).watchTranscript(meetingId);
    });

final chatMessagesProvider = StreamProvider.family<List<ChatMessage>, String>((
  ref,
  meetingId,
) {
  return ref.watch(meetingRepositoryProvider).watchChatMessages(meetingId);
});

final meetingSummaryProvider = StreamProvider.family<MeetingSummary?, String>(
  (ref, meetingId) =>
      ref.watch(meetingRepositoryProvider).watchSummary(meetingId),
);

final meetingTodosProvider = StreamProvider.family<List<Todo>, String>(
  (ref, meetingId) =>
      ref.watch(meetingRepositoryProvider).watchTodos(meetingId: meetingId),
);

final allTodosProvider = StreamProvider<List<Todo>>(
  (ref) => ref.watch(meetingRepositoryProvider).watchTodos(),
);

final recordingControllerProvider =
    NotifierProvider<RecordingController, RecordingUiState>(
      RecordingController.new,
    );

class MeetingSearchController extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) => state = value;
}

class SelectedMeetingController extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? meetingId) => state = meetingId;
}
