import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models/meeting_models.dart';
import '../../utils/formatters.dart';

class RecordingOverlay extends ConsumerStatefulWidget {
  const RecordingOverlay({super.key});

  @override
  ConsumerState<RecordingOverlay> createState() => _RecordingOverlayState();
}

class _RecordingOverlayState extends ConsumerState<RecordingOverlay>
    with SingleTickerProviderStateMixin {
  bool _isMinimized = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recording = ref.watch(recordingControllerProvider);
    final snapshot = recording.snapshot;
    final isActive =
        snapshot != null &&
        (snapshot.status == MeetingStatus.recording ||
            snapshot.status == MeetingStatus.paused);

    if (!isActive) {
      _isMinimized = false;
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 24,
      right: 24,
      child: Draggable<Offset>(
        feedback: _buildContent(snapshot, context),
        childWhenDragging: const SizedBox.shrink(),
        onDragEnd: (details) {},
        child: _buildContent(snapshot, context),
      ),
    );
  }

  Widget _buildContent(RecordingSnapshot snapshot, BuildContext context) {
    return Material(
      elevation: 16,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: _isMinimized ? 180 : 300,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D23),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2B333D)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: _isMinimized
            ? _MinimizedView(snapshot: snapshot, onRestore: _toggleMinimize)
            : _ExpandedView(
                snapshot: snapshot,
                onPauseResume: () => ref
                    .read(recordingControllerProvider.notifier)
                    .pauseOrResume(),
                onStop: () =>
                    ref.read(recordingControllerProvider.notifier).stopAndAnalyze(),
                onMinimize: _toggleMinimize,
                animationValue: _animationController.value,
              ),
      ),
    );
  }

  void _toggleMinimize() {
    setState(() {
      _isMinimized = !_isMinimized;
    });
  }
}

class _MinimizedView extends StatelessWidget {
  const _MinimizedView({required this.snapshot, required this.onRestore});

  final RecordingSnapshot snapshot;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRestore,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusDot(
              active: true,
              paused: snapshot.status == MeetingStatus.paused,
            ),
            const SizedBox(width: 10),
            Text(
              durationLabel(snapshot.elapsed),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.expand_more,
              size: 16,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedView extends StatelessWidget {
  const _ExpandedView({
    required this.snapshot,
    required this.onPauseResume,
    required this.onStop,
    required this.onMinimize,
    required this.animationValue,
  });

  final RecordingSnapshot snapshot;
  final VoidCallback onPauseResume;
  final VoidCallback onStop;
  final VoidCallback onMinimize;
  final double animationValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusDot(
                active: true,
                paused: snapshot.status == MeetingStatus.paused,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  snapshot.status == MeetingStatus.paused
                      ? 'Paused'
                      : 'Recording...',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                durationLabel(snapshot.elapsed),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: _MiniWaveform(
              level: snapshot.levels.mixedLevel,
              isPaused: snapshot.status == MeetingStatus.paused,
              animationValue: animationValue,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _OverlayButton(
                icon: snapshot.status == MeetingStatus.paused
                    ? Icons.play_arrow
                    : Icons.pause,
                label: snapshot.status == MeetingStatus.paused
                    ? 'Resume'
                    : 'Pause',
                onPressed: onPauseResume,
              ),
              _OverlayButton(
                icon: Icons.stop,
                label: 'Stop',
                onPressed: onStop,
                isDestructive: true,
              ),
              _OverlayButton(
                icon: Icons.minimize,
                label: 'Shrink',
                onPressed: onMinimize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniWaveform extends StatefulWidget {
  const _MiniWaveform({
    required this.level,
    required this.isPaused,
    required this.animationValue,
  });

  final double level;
  final bool isPaused;
  final double animationValue;

  @override
  State<_MiniWaveform> createState() => _MiniWaveformState();
}

class _MiniWaveformState extends State<_MiniWaveform> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MiniWaveformPainter(
        level: widget.level,
        isPaused: widget.isPaused,
        animationValue: widget.animationValue,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _MiniWaveformPainter extends CustomPainter {
  _MiniWaveformPainter({
    required this.level,
    required this.isPaused,
    required this.animationValue,
  });

  final double level;
  final bool isPaused;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF6B6B)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    const points = 60;
    final step = size.width / points;

    final path = Path();
    for (var i = 0; i <= points; i++) {
      final x = i * step;
      final wave = math.sin(i * 0.3 + animationValue * math.pi * 4) * 0.5 + 0.5;
      final amplitude = isPaused ? 0.02 : level * wave;
      final y = centerY + math.sin(i * 0.5 + animationValue * math.pi * 2) * amplitude * size.height * 0.4;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MiniWaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.level != level ||
        oldDelegate.isPaused != isPaused;
  }
}

class _OverlayButton extends StatelessWidget {
  const _OverlayButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDestructive
          ? const Color(0xFFDC3545).withValues(alpha: 0.15)
          : const Color(0xFF2B333D),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isDestructive
                    ? const Color(0xFFFF6B6B)
                    : Colors.white.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: isDestructive
                      ? const Color(0xFFFF6B6B)
                      : Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.active, required this.paused});

  final bool active;
  final bool paused;

  @override
  Widget build(BuildContext context) {
    final color = !active
        ? const Color(0xFF9AA4B2)
        : paused
            ? const Color(0xFFFFD166)
            : const Color(0xFFFF6B6B);
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: active
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.45),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}
