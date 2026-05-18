import '../models/meeting_models.dart';

abstract interface class ExportService {
  Future<ExportArtifact> exportMeeting({
    required ExportFormat format,
    required Meeting meeting,
    MeetingSummary? summary,
    required List<TranscriptSegment> transcript,
    required List<ChatMessage> chatMessages,
  });
}
