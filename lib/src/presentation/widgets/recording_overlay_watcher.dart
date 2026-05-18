import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models/meeting_models.dart';

class RecordingOverlayService {
  static const _channel = MethodChannel('recording_overlay');
  
  static Future<void> show() async {
    try {
      await _channel.invokeMethod('show');
    } catch (e) {
      print('Failed to show recording overlay: $e');
    }
  }

  static Future<void> hide() async {
    try {
      await _channel.invokeMethod('hide');
    } catch (e) {
      print('Failed to hide recording overlay: $e');
    }
  }

  static Future<void> updateState({
    required String status,
    required String time,
    required double level,
  }) async {
    try {
      await _channel.invokeMethod('updateState', {
        'status': status,
        'time': time,
        'level': level,
      });
    } catch (e) {
      print('Failed to update overlay state: $e');
    }
  }
}

class RecordingOverlayWatcher extends ConsumerWidget {
  const RecordingOverlayWatcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recording = ref.watch(recordingControllerProvider);
    final snapshot = recording.snapshot;
    
    final isActive = snapshot != null && (
        snapshot.status == MeetingStatus.recording ||
        snapshot.status == MeetingStatus.paused
    );

    if (isActive) {
      RecordingOverlayService.show();
      RecordingOverlayService.updateState(
        status: snapshot.status == MeetingStatus.paused ? 'paused' : 'recording',
        time: _formatDuration(snapshot.elapsed),
        level: snapshot.levels.mixedLevel,
      );
    } else {
      RecordingOverlayService.hide();
    }

    return const SizedBox.shrink();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
