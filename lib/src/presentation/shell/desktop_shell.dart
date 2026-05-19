import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../chat/meeting_chat_view.dart';
import '../recording/recording_panel.dart';
import '../settings/settings_drawer.dart';
import '../sidebar/meeting_sidebar.dart';
import '../todos/global_todos_view.dart';

class DesktopShell extends ConsumerWidget {
  const DesktopShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMeetingId = ref.watch(selectedMeetingIdProvider);
    final section = ref.watch(appSectionProvider);

    return Scaffold(
      body: Row(
        children: [
          const MeetingSidebar(),
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: RecordingPanel(),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: switch (section) {
                        AppSection.todos => const GlobalTodosView(
                          key: ValueKey('todos'),
                        ),
                        AppSection.settings => const SettingsView(
                          key: ValueKey('settings'),
                        ),
                        AppSection.meetings =>
                          selectedMeetingId == null
                              ? const _EmptyWorkspace(key: ValueKey('empty'))
                              : MeetingChatView(
                                  key: ValueKey(selectedMeetingId),
                                  meetingId: selectedMeetingId,
                                ),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWorkspace extends StatelessWidget {
  const _EmptyWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.forum_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Record, transcribe, summarize, and ask.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'MeetlyAI keeps speech recognition local, then uses your Gemini key for structured analysis and meeting chat.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF9AA4B2)),
            ),
          ],
        ),
      ),
    );
  }
}
