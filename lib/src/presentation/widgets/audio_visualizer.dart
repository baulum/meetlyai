import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/models/meeting_models.dart';
import '../../theme/app_colors.dart';

/// Scrolling level history with the microphone drawn above the baseline and
/// system audio mirrored below it, so both sources stay readable at a glance.
class AudioVisualizer extends StatefulWidget {
  const AudioVisualizer({
    super.key,
    required this.levels,
    this.height = 72,
    this.active = true,
  });

  final AudioLevelFrame levels;
  final double height;

  /// When false, the history is drawn dimmed (paused or idle).
  final bool active;

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer> {
  static const _barCount = 72;
  final List<_WaveSample> _samples = List.filled(
    _barCount,
    const _WaveSample(mic: 0, system: 0),
    growable: true,
  );
  DateTime? _lastSampleAt;

  @override
  void initState() {
    super.initState();
    _push(widget.levels, force: true);
  }

  @override
  void didUpdateWidget(covariant AudioVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.levels != widget.levels) {
      _push(widget.levels);
    }
  }

  void _push(AudioLevelFrame levels, {bool force = false}) {
    final last = _lastSampleAt;
    if (!force &&
        last != null &&
        levels.capturedAt.difference(last).inMilliseconds < 35) {
      return;
    }
    _lastSampleAt = levels.capturedAt;

    final previous = _samples.last;
    final next = _WaveSample(
      mic: _smooth(previous.mic, levels.micLevel),
      system: _smooth(previous.system, levels.systemLevel),
    );
    _samples
      ..removeAt(0)
      ..add(next);
  }

  double _smooth(double previous, double next) {
    final attack = next > previous ? 0.72 : 0.34;
    return (previous + (next - previous) * attack).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: CustomPaint(
        painter: _AudioVisualizerPainter(
          samples: List.unmodifiable(_samples),
          micColor: AppColors.mic,
          systemColor: AppColors.system,
          opacity: widget.active ? 1 : 0.35,
        ),
      ),
    );
  }
}

class _WaveSample {
  const _WaveSample({required this.mic, required this.system});

  final double mic;
  final double system;
}

class _AudioVisualizerPainter extends CustomPainter {
  _AudioVisualizerPainter({
    required this.samples,
    required this.micColor,
    required this.systemColor,
    required this.opacity,
  });

  final List<_WaveSample> samples;
  final Color micColor;
  final Color systemColor;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final barSlot = size.width / samples.length;
    final barWidth = math.max(2.0, barSlot * 0.5);
    final halfMax = size.height / 2 - 2;
    final baselinePaint = Paint()
      ..color = AppColors.borderStrong
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      baselinePaint,
    );

    for (var i = 0; i < samples.length; i++) {
      final sample = samples[i];
      final x = i * barSlot + barSlot / 2;
      final age = i / math.max(1, samples.length - 1);
      final alpha = (0.25 + age * 0.75) * opacity;

      final micHeight = math.max(1.0, sample.mic * halfMax);
      final systemHeight = math.max(1.0, sample.system * halfMax);

      canvas
        ..drawLine(
          Offset(x, centerY - 1.5),
          Offset(x, centerY - 1.5 - micHeight),
          Paint()
            ..color = micColor.withValues(alpha: alpha)
            ..strokeCap = StrokeCap.round
            ..strokeWidth = barWidth,
        )
        ..drawLine(
          Offset(x, centerY + 1.5),
          Offset(x, centerY + 1.5 + systemHeight),
          Paint()
            ..color = systemColor.withValues(alpha: alpha)
            ..strokeCap = StrokeCap.round
            ..strokeWidth = barWidth,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _AudioVisualizerPainter oldDelegate) {
    return oldDelegate.samples != samples ||
        oldDelegate.micColor != micColor ||
        oldDelegate.systemColor != systemColor ||
        oldDelegate.opacity != opacity;
  }
}
