import '../models/meeting_models.dart';

class RecordingRequest {
  const RecordingRequest({
    required this.meetingId,
    required this.outputDirectory,
    this.microphoneDeviceId,
    this.captureSystemAudio = true,
    this.sampleRate = 48000,
    this.channels = 2,
  });

  final String meetingId;
  final String outputDirectory;
  final String? microphoneDeviceId;
  final bool captureSystemAudio;
  final int sampleRate;
  final int channels;
}

abstract interface class AudioRecorder {
  Stream<RecordingSnapshot> get snapshots;
  Stream<AudioPcmFrame> get pcmFrames;

  Future<List<AudioDeviceInfo>> listInputDevices();

  Future<void> start(RecordingRequest request);

  Future<void> pause();

  Future<void> resume();

  Future<List<AudioAsset>> flushTranscriptionChunks();

  Future<List<AudioAsset>> stop();

  Future<void> dispose();
}
