import '../models/meeting_models.dart';

abstract interface class MeetingRepository {
  Stream<List<Meeting>> watchMeetings({String query = ''});

  Stream<List<TranscriptSegment>> watchTranscript(String meetingId);

  Stream<MeetingSummary?> watchSummary(String meetingId);

  Stream<List<ChatMessage>> watchChatMessages(String meetingId);

  Future<Meeting?> getMeeting(String id);

  Future<MeetingSummary?> getSummary(String meetingId);

  Future<List<TranscriptSegment>> getTranscript(String meetingId);

  Future<List<TranscriptSegment>> searchTranscript(
    String meetingId,
    String query,
  );

  Future<List<ChatMessage>> getChatMessages(String meetingId);

  Future<Meeting> createMeeting({String? title});

  Future<void> upsertMeeting(Meeting meeting);

  Future<void> saveAudioAsset(AudioAsset asset);

  Future<void> saveTranscriptSegment(TranscriptSegment segment);

  Future<void> saveSummary(MeetingSummary summary);

  Future<void> saveChatMessage(ChatMessage message);

  Future<void> deleteMeeting(String id);
}
