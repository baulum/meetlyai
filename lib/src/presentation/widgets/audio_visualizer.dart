import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/models/meeting_models.dart';

class AudioVisualizer extends StatelessWidget {
  const AudioVisualizer({super.key, required this.levels, this.height = 82});

  final AudioLevelFrame levels;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _AudioVisualizerPainter(
          levels: levels,
          primary: Theme.of(context).colorScheme.primary,
          secondary: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}

class _AudioVisualizerPainter extends CustomPainter {
  _AudioVisualizerPainter({
    required this.levels,
    required this.primary,
    required this.secondary,
  });

  final AudioLevelFrame levels;
  final Color primary;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final width = size.width;
    const bars = 64;
    final barWidth = math.max(3.0, width / bars * 0.55);
    final gap = width / bars * 0.45;
    final time = levels.capturedAt.millisecondsSinceEpoch / 260.0;

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth;

    for (var i = 0; i < bars; i++) {
      final wave = (math.sin(i * 0.42 + time) + 1) / 2;
      final alt = (math.cos(i * 0.31 + time * 0.8) + 1) / 2;
      final level =
          (levels.mixedLevel * 0.72) +
          (levels.micLevel * wave * 0.18) +
          (levels.systemLevel * alt * 0.10);
      final normalized = level.clamp(0.04, 1.0).toDouble();
      final x = i * (barWidth + gap) + barWidth / 2;
      final barHeight = normalized * size.height * 0.86;
      paint.color = Color.lerp(secondary, primary, normalized)!;
      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AudioVisualizerPainter oldDelegate) {
    return oldDelegate.levels != levels;
  }
}
