import 'package:flutter_test/flutter_test.dart';
import 'package:meetlyai/src/data/services/whisper_transcription_engine.dart';
import 'package:meetlyai/src/domain/models/meeting_models.dart';
import 'package:meetlyai/src/domain/services/transcription_engine.dart';
import 'package:whisper_ffi/whisper_ffi.dart';

void main() {
  test('uses configured chunk interval for transcript offsets', () async {
    final engine = WhisperFfiTranscriptionEngine(
      runtime: _FakeWhisperRuntime([
        const WhisperSegment(
          source: WhisperSource.mic,
          audioPath: '/tmp/transcription_chunks/mic_000002.wav',
          startMs: 1200,
          endMs: 2400,
          text: 'Hallo zusammen',
        ),
      ]),
    );

    final segments = await engine
        .transcribe(
          TranscriptionRequest(
            meetingId: 'meeting-1',
            audioAssets: [
              AudioAsset(
                id: 'asset-1',
                meetingId: 'meeting-1',
                source: AudioSourceKind.mic,
                path: '/tmp/transcription_chunks/mic_000002.wav',
                sampleRate: 16000,
                channels: 1,
                createdAt: DateTime(2026),
              ),
            ],
            modelPath: '/tmp/model.bin',
            chunkOffsetIntervalMs: 10000,
          ),
        )
        .toList();

    expect(segments, hasLength(1));
    expect(segments.single.startMs, 21200);
    expect(segments.single.endMs, 22400);
  });
}

class _FakeWhisperRuntime extends WhisperRuntime {
  const _FakeWhisperRuntime(this.segments);

  final List<WhisperSegment> segments;

  @override
  Stream<WhisperSegment> transcribe(WhisperTranscriptionJob job) async* {
    for (final segment in segments) {
      yield segment;
    }
  }
}
