import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../chat/meeting_chat_view.dart';
import '../recording/recording_panel.dart';
import '../settings/settings_drawer.dart';
import '../sidebar/meeting_sidebar.dart';
import '../widgets/recording_overlay_channel.dart';
import '../widgets/recording_overlay_watcher.dart';

class DesktopShell extends ConsumerStatefulWidget {
  const DesktopShell({super.key});

  @override
  ConsumerState<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends ConsumerState<DesktopShell> {
  @override
  void initState() {
    super.initState();
    RecordingOverlayChannel.init(ref);
  }

  @override
  Widget build(BuildContext context) {
    final selectedMeetingId = ref.watch(selectedMeetingIdProvider);

    return Scaffold(
      endDrawer: const SettingsDrawer(),
      body: Stack(
        children: [
          Row(
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
                          child: selectedMeetingId == null
                              ? const _EmptyWorkspace()
                              : MeetingChatView(
                                  key: ValueKey(selectedMeetingId),
                                  meetingId: selectedMeetingId,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const RecordingOverlayWatcher(),
        ],
      ),
    );
  }
}

class _EmptyWorkspace extends StatelessWidget {
  const _EmptyWorkspace();

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
