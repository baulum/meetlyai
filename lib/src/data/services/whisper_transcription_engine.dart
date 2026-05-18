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
    final files = <WhisperSource, String>{};
    for (final asset in request.audioAssets) {
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
      yield TranscriptSegment(
        id: _uuid.v7(),
        meetingId: request.meetingId,
        source: switch (segment.source) {
          WhisperSource.mic => AudioSourceKind.mic,
          WhisperSource.system => AudioSourceKind.system,
          WhisperSource.mixed => AudioSourceKind.mixed,
        },
        speakerLabel: switch (segment.source) {
          WhisperSource.mic => 'Mic',
          WhisperSource.system => 'System',
          WhisperSource.mixed => 'Mixed',
        },
        startMs: segment.startMs,
        endMs: segment.endMs,
        text: segment.text,
        confidence: segment.confidence,
      );
    }
  }
}
