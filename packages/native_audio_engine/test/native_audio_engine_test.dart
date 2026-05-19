import 'package:flutter_test/flutter_test.dart';
import 'package:native_audio_engine/native_audio_engine.dart';
import 'package:native_audio_engine/native_audio_engine_platform_interface.dart';
import 'package:native_audio_engine/native_audio_engine_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativeAudioEnginePlatform
    with MockPlatformInterfaceMixin
    implements NativeAudioEnginePlatform {
  @override
  Stream<NativeAudioLevel> get levels => const Stream.empty();

  @override
  Stream<NativePcmFrame> get pcmFrames => const Stream.empty();

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<List<NativeAudioDevice>> listInputDevices() => Future.value(const []);

  @override
  Future<void> pauseCapture() => Future.value();

  @override
  Future<void> resumeCapture() => Future.value();

  @override
  Future<List<NativeAudioAsset>> flushTranscriptionChunks() =>
      Future.value(const []);

  @override
  Future<void> startCapture(NativeCaptureConfig config) => Future.value();

  @override
  Future<List<NativeAudioAsset>> stopCapture() => Future.value(const []);
}

void main() {
  final NativeAudioEnginePlatform initialPlatform =
      NativeAudioEnginePlatform.instance;

  test('$MethodChannelNativeAudioEngine is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativeAudioEngine>());
  });

  test('getPlatformVersion', () async {
    NativeAudioEngine nativeAudioEnginePlugin = NativeAudioEngine();
    MockNativeAudioEnginePlatform fakePlatform =
        MockNativeAudioEnginePlatform();
    NativeAudioEnginePlatform.instance = fakePlatform;

    expect(await nativeAudioEnginePlugin.getPlatformVersion(), '42');
  });
}
