import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_audio_engine.dart';
import 'native_audio_engine_platform_interface.dart';

class MethodChannelNativeAudioEngine extends NativeAudioEnginePlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('native_audio_engine');

  final _levelController = StreamController<NativeAudioLevel>.broadcast();
  final _pcmController = StreamController<NativePcmFrame>.broadcast();

  Timer? _previewTimer;
  NativeCaptureConfig? _activeConfig;
  DateTime? _startedAt;
  bool _paused = false;

  @override
  Stream<NativeAudioLevel> get levels => _levelController.stream;

  @override
  Stream<NativePcmFrame> get pcmFrames => _pcmController.stream;

  @override
  Future<String?> getPlatformVersion() async {
    return methodChannel.invokeMethod<String>('getPlatformVersion');
  }

  @override
  Future<List<NativeAudioDevice>> listInputDevices() async {
    try {
      final devices = await methodChannel.invokeListMethod<Object?>(
        'listInputDevices',
      );
      return (devices ?? const [])
          .whereType<Map<Object?, Object?>>()
          .map(NativeAudioDevice.fromJson)
          .toList(growable: false);
    } on MissingPluginException {
      return const [
        NativeAudioDevice(
          id: 'default-mic',
          name: 'Default Microphone',
          source: NativeAudioSource.mic,
          isDefault: true,
          channels: 1,
        ),
        NativeAudioDevice(
          id: 'system-loopback',
          name: 'System Audio',
          source: NativeAudioSource.system,
          isDefault: true,
          channels: 2,
        ),
      ];
    }
  }

  @override
  Future<void> startCapture(NativeCaptureConfig config) async {
    _activeConfig = config;
    _startedAt = DateTime.now();
    _paused = false;
    _startPreviewStream(config);
    try {
      await methodChannel.invokeMethod<void>('startCapture', config.toJson());
    } on MissingPluginException {
      return;
    } on PlatformException {
      _previewTimer?.cancel();
      _previewTimer = null;
      rethrow;
    }
  }

  @override
  Future<void> pauseCapture() async {
    _paused = true;
    try {
      await methodChannel.invokeMethod<void>('pauseCapture');
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<void> resumeCapture() async {
    _paused = false;
    try {
      await methodChannel.invokeMethod<void>('resumeCapture');
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<List<NativeAudioAsset>> stopCapture() async {
    _previewTimer?.cancel();
    _previewTimer = null;
    try {
      final result = await methodChannel.invokeListMethod<Object?>(
        'stopCapture',
      );
      return (result ?? const [])
          .whereType<Map<Object?, Object?>>()
          .map(NativeAudioAsset.fromJson)
          .toList(growable: false);
    } on MissingPluginException {
      final config = _activeConfig;
      final startedAt = _startedAt;
      if (config == null || startedAt == null) {
        return const [];
      }
      final duration = DateTime.now().difference(startedAt).inMilliseconds;
      return [
        NativeAudioAsset(
          source: NativeAudioSource.mic,
          path: '${config.outputDirectory}/mic.wav',
          sampleRate: config.sampleRate,
          channels: config.channels,
          durationMs: duration,
          byteSize: 0,
        ),
        if (config.captureSystemAudio)
          NativeAudioAsset(
            source: NativeAudioSource.system,
            path: '${config.outputDirectory}/system.wav',
            sampleRate: config.sampleRate,
            channels: config.channels,
            durationMs: duration,
            byteSize: 0,
          ),
        NativeAudioAsset(
          source: NativeAudioSource.mixed,
          path: '${config.outputDirectory}/mixed.wav',
          sampleRate: config.sampleRate,
          channels: config.channels,
          durationMs: duration,
          byteSize: 0,
        ),
      ];
    }
  }

  void _startPreviewStream(NativeCaptureConfig config) {
    _previewTimer?.cancel();
    _previewTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_paused) {
        return;
      }
      final startedAt = _startedAt;
      if (startedAt == null) {
        return;
      }
      final elapsed = DateTime.now().difference(startedAt).inMilliseconds;
      final phase = elapsed / 240.0;
      final mic = 0.35 + (math.sin(phase) + 1) * 0.22;
      final system = config.captureSystemAudio
          ? 0.25 + (math.cos(phase * 0.8) + 1) * 0.18
          : 0.0;
      final mixed = math.min(1, (mic + system) / 1.35);
      _levelController.add(
        NativeAudioLevel(
          micLevel: mic,
          systemLevel: system,
          mixedLevel: mixed.toDouble(),
          timestampMs: elapsed,
        ),
      );

      if (elapsed % 200 < 50) {
        _pcmController
          ..add(
            NativePcmFrame(
              meetingId: config.meetingId,
              source: NativeAudioSource.mic,
              bytes: Uint8List(3200),
              sampleRate: 16000,
              channels: 1,
              timestampMs: elapsed,
            ),
          )
          ..add(
            NativePcmFrame(
              meetingId: config.meetingId,
              source: NativeAudioSource.system,
              bytes: Uint8List(3200),
              sampleRate: 16000,
              channels: 1,
              timestampMs: elapsed,
            ),
          );
      }
    });
  }
}
