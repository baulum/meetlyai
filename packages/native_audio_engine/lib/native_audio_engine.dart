import 'dart:typed_data';

import 'native_audio_engine_platform_interface.dart';

enum NativeAudioSource { mic, system, mixed }

class NativeCaptureConfig {
  const NativeCaptureConfig({
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

  Map<String, Object?> toJson() => {
    'meetingId': meetingId,
    'outputDirectory': outputDirectory,
    'microphoneDeviceId': microphoneDeviceId,
    'captureSystemAudio': captureSystemAudio,
    'sampleRate': sampleRate,
    'channels': channels,
  };
}

class NativeAudioDevice {
  const NativeAudioDevice({
    required this.id,
    required this.name,
    required this.source,
    required this.isDefault,
    required this.channels,
  });

  final String id;
  final String name;
  final NativeAudioSource source;
  final bool isDefault;
  final int channels;

  factory NativeAudioDevice.fromJson(Map<Object?, Object?> json) {
    return NativeAudioDevice(
      id: json['id'] as String,
      name: json['name'] as String,
      source: NativeAudioSource.values.byName(json['source'] as String),
      isDefault: json['isDefault'] as bool? ?? false,
      channels: json['channels'] as int? ?? 1,
    );
  }
}

class NativeAudioLevel {
  const NativeAudioLevel({
    required this.micLevel,
    required this.systemLevel,
    required this.mixedLevel,
    required this.timestampMs,
  });

  final double micLevel;
  final double systemLevel;
  final double mixedLevel;
  final int timestampMs;

  factory NativeAudioLevel.fromJson(Map<Object?, Object?> json) {
    return NativeAudioLevel(
      micLevel: (json['micLevel'] as num?)?.toDouble() ?? 0,
      systemLevel: (json['systemLevel'] as num?)?.toDouble() ?? 0,
      mixedLevel: (json['mixedLevel'] as num?)?.toDouble() ?? 0,
      timestampMs: json['timestampMs'] as int? ?? 0,
    );
  }
}

class NativePcmFrame {
  const NativePcmFrame({
    required this.meetingId,
    required this.source,
    required this.bytes,
    required this.sampleRate,
    required this.channels,
    required this.timestampMs,
  });

  final String meetingId;
  final NativeAudioSource source;
  final Uint8List bytes;
  final int sampleRate;
  final int channels;
  final int timestampMs;

  factory NativePcmFrame.fromJson(Map<Object?, Object?> json) {
    return NativePcmFrame(
      meetingId: json['meetingId'] as String,
      source: NativeAudioSource.values.byName(json['source'] as String),
      bytes: json['bytes'] as Uint8List? ?? Uint8List(0),
      sampleRate: json['sampleRate'] as int? ?? 16000,
      channels: json['channels'] as int? ?? 1,
      timestampMs: json['timestampMs'] as int? ?? 0,
    );
  }
}

class NativeAudioAsset {
  const NativeAudioAsset({
    required this.source,
    required this.path,
    required this.sampleRate,
    required this.channels,
    required this.durationMs,
    required this.byteSize,
  });

  final NativeAudioSource source;
  final String path;
  final int sampleRate;
  final int channels;
  final int durationMs;
  final int byteSize;

  factory NativeAudioAsset.fromJson(Map<Object?, Object?> json) {
    return NativeAudioAsset(
      source: NativeAudioSource.values.byName(json['source'] as String),
      path: json['path'] as String,
      sampleRate: json['sampleRate'] as int? ?? 48000,
      channels: json['channels'] as int? ?? 2,
      durationMs: json['durationMs'] as int? ?? 0,
      byteSize: json['byteSize'] as int? ?? 0,
    );
  }
}

class NativeAudioEngine {
  Stream<NativeAudioLevel> get levels =>
      NativeAudioEnginePlatform.instance.levels;

  Stream<NativePcmFrame> get pcmFrames =>
      NativeAudioEnginePlatform.instance.pcmFrames;

  Future<String?> getPlatformVersion() {
    return NativeAudioEnginePlatform.instance.getPlatformVersion();
  }

  Future<List<NativeAudioDevice>> listInputDevices() {
    return NativeAudioEnginePlatform.instance.listInputDevices();
  }

  Future<void> startCapture(NativeCaptureConfig config) {
    return NativeAudioEnginePlatform.instance.startCapture(config);
  }

  Future<void> pauseCapture() {
    return NativeAudioEnginePlatform.instance.pauseCapture();
  }

  Future<void> resumeCapture() {
    return NativeAudioEnginePlatform.instance.resumeCapture();
  }

  Future<List<NativeAudioAsset>> flushTranscriptionChunks() {
    return NativeAudioEnginePlatform.instance.flushTranscriptionChunks();
  }

  Future<List<NativeAudioAsset>> stopCapture() {
    return NativeAudioEnginePlatform.instance.stopCapture();
  }
}
