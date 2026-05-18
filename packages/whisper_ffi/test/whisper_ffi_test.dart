import 'package:test/test.dart';

import 'package:whisper_ffi/whisper_ffi.dart';

void main() {
  test('native health check is available', () {
    expect(const WhisperRuntime().hasNativeBridge, isTrue);
  });
}
