import '../models/meeting_models.dart';

class MeetingChatRequest {
  const MeetingChatRequest({
    required this.meeting,
    required this.transcriptContext,
    required this.messages,
    required this.question,
    this.summary,
  });

  final Meeting meeting;
  final MeetingSummary? summary;
  final List<TranscriptSegment> transcriptContext;
  final List<ChatMessage> messages;
  final String question;
}

abstract interface class LlmService {
  Future<MeetingSummary> summarizeMeeting({
    required Meeting meeting,
    required List<TranscriptSegment> transcript,
  });

  Stream<String> streamMeetingAnswer(MeetingChatRequest request);
}
