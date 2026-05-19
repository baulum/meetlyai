import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/models/meeting_models.dart';

class AudioVisualizer extends StatefulWidget {
  const AudioVisualizer({super.key, required this.levels, this.height = 82});

  final AudioLevelFrame levels;
  final double height;

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer> {
  static const _barCount = 64;
  final List<_WaveSample> _samples = List.filled(
    _barCount,
    const _WaveSample(mic: 0, system: 0, mixed: 0),
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
      mixed: _smooth(previous.mixed, levels.mixedLevel),
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
          primary: Theme.of(context).colorScheme.primary,
          secondary: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}

class _WaveSample {
  const _WaveSample({
    required this.mic,
    required this.system,
    required this.mixed,
  });

  final double mic;
  final double system;
  final double mixed;
}

class _AudioVisualizerPainter extends CustomPainter {
  _AudioVisualizerPainter({
    required this.samples,
    required this.primary,
    required this.secondary,
  });

  final List<_WaveSample> samples;
  final Color primary;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final barSlot = size.width / samples.length;
    final barWidth = math.max(2.5, barSlot * 0.48);
    final maxHeight = size.height * 0.86;
    final baselinePaint = Paint()
      ..color = const Color(0xFF2B333D)
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
      final mixed = sample.mixed.clamp(0, 1);
      final micShare = sample.mic / math.max(0.001, sample.mic + sample.system);
      final color = Color.lerp(
        secondary,
        primary,
        micShare.clamp(0, 1),
      )!.withValues(alpha: 0.30 + age * 0.70);
      final height = math.max(2.0, mixed * maxHeight);
      final paint = Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = barWidth;

      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AudioVisualizerPainter oldDelegate) {
    return oldDelegate.samples != samples ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary;
  }
}
