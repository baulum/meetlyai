import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models/meeting_models.dart';
import '../../utils/formatters.dart';
import '../widgets/audio_visualizer.dart';

class RecordingPanel extends ConsumerWidget {
  const RecordingPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recording = ref.watch(recordingControllerProvider);
    final snapshot = recording.snapshot;
    final isActive =
        snapshot != null &&
        (snapshot.status == MeetingStatus.recording ||
            snapshot.status == MeetingStatus.paused);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF15191F),
        border: Border.all(color: const Color(0xFF262D36)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _StatusDot(
                active: isActive,
                paused: snapshot?.status == MeetingStatus.paused,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot?.statusMessage ?? 'Ready for a local meeting',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Mic and system audio are kept as separate sources.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF9AA4B2),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                durationLabel(snapshot?.elapsed ?? Duration.zero),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 16),
              if (isActive)
                IconButton.filledTonal(
                  tooltip: snapshot.status == MeetingStatus.paused
                      ? 'Resume'
                      : 'Pause',
                  onPressed: recording.isBusy
                      ? null
                      : () => ref
                            .read(recordingControllerProvider.notifier)
                            .pauseOrResume(),
                  icon: Icon(
                    snapshot.status == MeetingStatus.paused
                        ? Icons.play_arrow
                        : Icons.pause,
                  ),
                ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: recording.isBusy
                    ? null
                    : isActive
                    ? () => ref
                          .read(recordingControllerProvider.notifier)
                          .stopAndAnalyze()
                    : () => ref
                          .read(recordingControllerProvider.notifier)
                          .startNewMeeting(),
                icon: Icon(isActive ? Icons.stop : Icons.fiber_manual_record),
                label: Text(isActive ? 'Stop' : 'Record'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AudioVisualizer(
            levels:
                snapshot?.levels ??
                AudioLevelFrame(
                  micLevel: 0.08,
                  systemLevel: 0.04,
                  mixedLevel: 0.06,
                  capturedAt: DateTime.now(),
                ),
          ),
          if (recording.errorMessage != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                recording.errorMessage!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ],
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: active
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.45),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
    );
  }
}
