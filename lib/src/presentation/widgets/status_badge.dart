import 'package:flutter/material.dart';

import '../../domain/models/meeting_models.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final MeetingStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      MeetingStatus.recording => const Color(0xFFFF6B6B),
      MeetingStatus.paused => const Color(0xFFFFD166),
      MeetingStatus.transcribing => const Color(0xFF8AB4F8),
      MeetingStatus.summarizing => const Color(0xFFB794F4),
      MeetingStatus.ready => const Color(0xFF6EE7B7),
      MeetingStatus.failed => Theme.of(context).colorScheme.error,
      MeetingStatus.draft => const Color(0xFF9AA4B2),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(switch (status) {
        MeetingStatus.draft => 'Draft',
        MeetingStatus.recording => 'Recording',
        MeetingStatus.paused => 'Paused',
        MeetingStatus.transcribing => 'Transcribing',
        MeetingStatus.summarizing => 'Summarizing',
        MeetingStatus.ready => 'Ready',
        MeetingStatus.failed => 'Failed',
      }, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
    );
  }
}
