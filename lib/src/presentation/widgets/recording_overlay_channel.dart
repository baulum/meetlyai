import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';

class RecordingOverlayChannel {
  static const _channel = MethodChannel('recording_overlay');
  
  static void init(WidgetRef ref) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'pauseOrResume':
          await ref.read(recordingControllerProvider.notifier).pauseOrResume();
          break;
        case 'stop':
          await ref.read(recordingControllerProvider.notifier).stopAndAnalyze();
          break;
      }
      return null;
    });
  }
}
