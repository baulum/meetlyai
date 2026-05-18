import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:native_audio_engine/native_audio_engine.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../domain/models/meeting_models.dart';
import '../../domain/services/audio_recorder.dart';

class NativeAudioRecorderAdapter implements AudioRecorder {
  NativeAudioRecorderAdapter({NativeAudioEngine? engine, Uuid? uuid})
    : _engine = engine ?? NativeAudioEngine(),
      _uuid = uuid ?? const Uuid();

  final NativeAudioEngine _engine;
  final Uuid _uuid;
  final _snapshotController = StreamController<RecordingSnapshot>.broadcast();
  final _pcmController = StreamController<AudioPcmFrame>.broadcast();
  final List<StreamSubscription<Object?>> _subscriptions = [];

  RecordingRequest? _request;
  DateTime? _startedAt;
  DateTime? _pausedAt;
  Duration _pausedDuration = Duration.zero;
  MeetingStatus _status = MeetingStatus.draft;

  @override
  Stream<RecordingSnapshot> get snapshots => _snapshotController.stream;

  @override
  Stream<AudioPcmFrame> get pcmFrames => _pcmController.stream;

  @override
  Future<List<AudioDeviceInfo>> listInputDevices() async {
    final devices = await _engine.listInputDevices();
    return devices
        .map(
          (device) => AudioDeviceInfo(
            id: device.id,
            name: device.name,
            source: _source(device.source),
            isDefault: device.isDefault,
            channels: device.channels,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> start(RecordingRequest request) async {
    _request = request;
    _startedAt = DateTime.now();
    _pausedAt = null;
    _pausedDuration = Duration.zero;
    _status = MeetingStatus.recording;
    await Directory(request.outputDirectory).create(recursive: true);
    _listenToNativeStreams(request.meetingId);
    await _engine.startCapture(
      NativeCaptureConfig(
        meetingId: request.meetingId,
        outputDirectory: request.outputDirectory,
        microphoneDeviceId: request.microphoneDeviceId,
        captureSystemAudio: request.captureSystemAudio,
        sampleRate: request.sampleRate,
        channels: request.channels,
      ),
    );
  }

  @override
  Future<void> pause() async {
    if (_status != MeetingStatus.recording) {
      return;
    }
    _pausedAt = DateTime.now();
    _status = MeetingStatus.paused;
    await _engine.pauseCapture();
  }

  @override
  Future<void> resume() async {
    if (_status != MeetingStatus.paused) {
      return;
    }
    final pausedAt = _pausedAt;
    if (pausedAt != null) {
      _pausedDuration += DateTime.now().difference(pausedAt);
    }
    _pausedAt = null;
    _status = MeetingStatus.recording;
    await _engine.resumeCapture();
  }

  @override
  Future<List<AudioAsset>> stop() async {
    final nativeAssets = await _engine.stopCapture();
    _status = MeetingStatus.transcribing;
    final now = DateTime.now();
    final assets = <AudioAsset>[];
    for (final asset in nativeAssets) {
      await _ensureWavFile(
        path: asset.path,
        sampleRate: asset.sampleRate,
        channels: asset.channels,
      );
      final file = File(asset.path);
      final byteSize = await file.exists()
          ? await file.length()
          : asset.byteSize;
      assets.add(
        AudioAsset(
          id: _uuid.v7(),
          meetingId: _request?.meetingId ?? '',
          source: _source(asset.source),
          path: asset.path,
          sampleRate: asset.sampleRate,
          channels: asset.channels,
          durationMs: asset.durationMs,
          byteSize: byteSize,
          createdAt: now,
        ),
      );
    }
    return assets;
  }

  @override
  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _snapshotController.close();
    await _pcmController.close();
  }

  void _listenToNativeStreams(String meetingId) {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions
      ..clear()
      ..add(
        _engine.levels.listen((level) {
          _snapshotController.add(
            RecordingSnapshot(
              meetingId: meetingId,
              elapsed: _elapsed(),
              levels: AudioLevelFrame(
                micLevel: level.micLevel,
                systemLevel: level.systemLevel,
                mixedLevel: level.mixedLevel,
                capturedAt: DateTime.now(),
              ),
              status: _status,
              statusMessage: switch (_status) {
                MeetingStatus.paused => 'Paused',
                MeetingStatus.recording => 'Recording locally',
                _ => 'Preparing',
              },
            ),
          );
        }),
      )
      ..add(
        _engine.pcmFrames.listen((frame) {
          _pcmController.add(
            AudioPcmFrame(
              meetingId: frame.meetingId,
              source: _source(frame.source),
              bytes: frame.bytes,
              sampleRate: frame.sampleRate,
              channels: frame.channels,
              timestamp: Duration(milliseconds: frame.timestampMs),
            ),
          );
        }),
      );
  }

  Duration _elapsed() {
    final startedAt = _startedAt;
    if (startedAt == null) {
      return Duration.zero;
    }
    final end = _pausedAt ?? DateTime.now();
    return end.difference(startedAt) - _pausedDuration;
  }

  AudioSourceKind _source(NativeAudioSource source) {
    return switch (source) {
      NativeAudioSource.mic => AudioSourceKind.mic,
      NativeAudioSource.system => AudioSourceKind.system,
      NativeAudioSource.mixed => AudioSourceKind.mixed,
    };
  }

  Future<void> _ensureWavFile({
    required String path,
    required int sampleRate,
    required int channels,
  }) async {
    final file = File(path);
    if (await file.exists()) {
      return;
    }
    await Directory(p.dirname(path)).create(recursive: true);
    await file.writeAsBytes(_emptyWavHeader(sampleRate, channels));
  }

  Uint8List _emptyWavHeader(int sampleRate, int channels) {
    final bytes = ByteData(44);
    final byteRate = sampleRate * channels * 2;
    bytes.buffer.asUint8List().setAll(0, 'RIFF'.codeUnits);
    bytes.setUint32(4, 36, Endian.little);
    bytes.buffer.asUint8List().setAll(8, 'WAVEfmt '.codeUnits);
    bytes.setUint32(16, 16, Endian.little);
    bytes.setUint16(20, 1, Endian.little);
    bytes.setUint16(22, channels, Endian.little);
    bytes.setUint32(24, sampleRate, Endian.little);
    bytes.setUint32(28, byteRate, Endian.little);
    bytes.setUint16(32, channels * 2, Endian.little);
    bytes.setUint16(34, 16, Endian.little);
    bytes.buffer.asUint8List().setAll(36, 'data'.codeUnits);
    bytes.setUint32(40, 0, Endian.little);
    return bytes.buffer.asUint8List();
  }
}
