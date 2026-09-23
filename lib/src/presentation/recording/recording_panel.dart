import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models/meeting_models.dart';
import '../../theme/app_colors.dart';
import '../../utils/formatters.dart';
import '../widgets/audio_visualizer.dart';

/// Keyboard hint for the global record/stop shortcut registered in the shell.
String get recordShortcutLabel => Platform.isMacOS ? '⇧⌘R' : 'Ctrl+Shift+R';

class RecordingPanel extends ConsumerWidget {
  const RecordingPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recording = ref.watch(recordingControllerProvider);
    final controller = ref.read(recordingControllerProvider.notifier);
    final snapshot = recording.snapshot;
    final isActive =
        snapshot != null &&
        (snapshot.status == MeetingStatus.recording ||
            snapshot.status == MeetingStatus.paused);
    final isPaused = snapshot?.status == MeetingStatus.paused;
    final theme = Theme.of(context);

    final title = recording.isBusy
        ? (isActive ? 'Finishing up…' : 'Starting…')
        : !isActive
        ? 'Ready to record'
        : isPaused
        ? 'Paused'
        : 'Recording';
    final subtitle = recording.isBusy && isActive
        ? 'Transcribing the last chunk and preparing the summary.'
        : isActive
        ? 'Everything stays on this device while recording.'
        : 'Your microphone and the system audio are captured as separate '
              'tracks, so the transcript knows who said what.';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: isActive && !isPaused
              ? AppColors.recording.withValues(alpha: 0.35)
              : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _StatusDot(active: isActive, paused: isPaused),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                if (isActive) ...[
                  Text(
                    durationLabel(snapshot.elapsed),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                      fontWeight: FontWeight.w700,
                      color: isPaused ? AppColors.textMuted : AppColors.text,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton.filledTonal(
                    tooltip: isPaused ? 'Resume' : 'Pause',
                    onPressed: recording.isBusy
                        ? null
                        : controller.pauseOrResume,
                    icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                  ),
                  const SizedBox(width: 8),
                ],
                Tooltip(
                  message: isActive
                      ? 'Stop and analyze ($recordShortcutLabel)'
                      : 'Start recording ($recordShortcutLabel)',
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: isActive ? AppColors.recording : null,
                      foregroundColor: isActive ? Colors.white : null,
                    ),
                    onPressed: recording.isBusy
                        ? null
                        : isActive
                        ? controller.stopAndAnalyze
                        : controller.startNewMeeting,
                    icon: recording.isBusy
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            isActive
                                ? Icons.stop_rounded
                                : Icons.fiber_manual_record,
                          ),
                    label: Text(isActive ? 'Stop' : 'Record'),
                  ),
                ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final meters = [
                    _SourceMeter(
                      source: AudioSourceKind.mic,
                      level: snapshot.levels.micLevel,
                      listening: !isPaused,
                    ),
                    _SourceMeter(
                      source: AudioSourceKind.system,
                      level: snapshot.levels.systemLevel,
                      listening: !isPaused,
                    ),
                  ];
                  final visualizer = AudioVisualizer(
                    levels: snapshot.levels,
                    active: !isPaused,
                  );
                  if (constraints.maxWidth < 640) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        meters[0],
                        const SizedBox(height: 8),
                        meters[1],
                        const SizedBox(height: 12),
                        visualizer,
                      ],
                    );
                  }
                  return Row(
                    children: [
                      SizedBox(
                        width: 280,
                        child: Column(
                          children: [
                            meters[0],
                            const SizedBox(height: 8),
                            meters[1],
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: visualizer),
                    ],
                  );
                },
              ),
            ] else if (!recording.isBusy) ...[
              const SizedBox(height: 12),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SourceChip(source: AudioSourceKind.mic),
                  _SourceChip(source: AudioSourceKind.system),
                ],
              ),
            ],
            if (recording.errorMessage != null) ...[
              const SizedBox(height: 12),
              _ErrorBanner(message: recording.errorMessage!),
            ],
          ],
        ),
      ),
    );
  }
}

/// Live level for one audio source, with a hint when it stays silent.
class _SourceMeter extends StatefulWidget {
  const _SourceMeter({
    required this.source,
    required this.level,
    required this.listening,
  });

  final AudioSourceKind source;
  final double level;
  final bool listening;

  @override
  State<_SourceMeter> createState() => _SourceMeterState();
}

class _SourceMeterState extends State<_SourceMeter> {
  static const _signalThreshold = 0.02;
  static const _silenceHint = Duration(seconds: 8);
  DateTime _lastHeard = DateTime.now();

  @override
  void didUpdateWidget(covariant _SourceMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.level > _signalThreshold || !widget.listening) {
      _lastHeard = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = AudioSourceStyle.of(widget.source);
    final silent =
        widget.listening &&
        DateTime.now().difference(_lastHeard) > _silenceHint;
    final theme = Theme.of(context);

    return Tooltip(
      message: silent
          ? switch (widget.source) {
              AudioSourceKind.system =>
                'No system audio for a while. If others are talking, check '
                    'the Screen & System Audio Recording permission.',
              _ =>
                'No microphone input for a while. Check that the right input '
                    'device is selected and not muted.',
            }
          : style.description,
      waitDuration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.inset,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: silent
                ? AppColors.paused.withValues(alpha: 0.35)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(style.icon, size: 18, color: style.color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        style.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          silent ? 'Silent' : style.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: silent
                                ? AppColors.paused
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        end: widget.listening
                            ? widget.level.clamp(0.0, 1.0)
                            : 0.0,
                      ),
                      duration: const Duration(milliseconds: 90),
                      builder: (context, value, _) => LinearProgressIndicator(
                        value: value,
                        minHeight: 5,
                        color: style.color,
                        backgroundColor: AppColors.border,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.source});

  final AudioSourceKind source;

  @override
  Widget build(BuildContext context) {
    final style = AudioSourceStyle.of(source);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.08),
        border: Border.all(color: style.color.withValues(alpha: 0.22)),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 14, color: style.color),
          const SizedBox(width: 6),
          Text(
            '${style.label} · ${style.description}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textSubtle),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: error.withValues(alpha: 0.08),
        border: Border.all(color: error.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 18, color: error),
          const SizedBox(width: 10),
          Expanded(
            child: SelectableText(
              message,
              maxLines: 4,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: error),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatefulWidget {
  const _StatusDot({required this.active, required this.paused});

  final bool active;
  final bool paused;

  @override
  State<_StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<_StatusDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void initState() {
    super.initState();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant _StatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  void _syncPulse() {
    final shouldPulse = widget.active && !widget.paused;
    if (shouldPulse && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!shouldPulse && _pulse.isAnimating) {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = !widget.active
        ? AppColors.textMuted
        : widget.paused
        ? AppColors.paused
        : AppColors.recording;
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) => Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: widget.active
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25 + 0.35 * _pulse.value),
                    blurRadius: 10 + 10 * _pulse.value,
                    spreadRadius: 1 + 2 * _pulse.value,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
