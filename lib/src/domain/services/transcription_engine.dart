import '../models/meeting_models.dart';

class TranscriptionRequest {
  const TranscriptionRequest({
    required this.meetingId,
    required this.audioAssets,
    required this.modelPath,
    this.languageCode = 'auto',
    this.executablePath,
  });

  final String meetingId;
  final List<AudioAsset> audioAssets;
  final String modelPath;
  final String languageCode;
  final String? executablePath;
}

abstract interface class TranscriptionEngine {
  Stream<TranscriptSegment> transcribe(TranscriptionRequest request);
}
