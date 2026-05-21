import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../chat/meeting_chat_view.dart';
import '../learning/learning_view.dart';
import '../recording/recording_panel.dart';
import '../settings/settings_drawer.dart';
import '../sidebar/meeting_sidebar.dart';
import '../todos/global_todos_view.dart';

class DesktopShell extends ConsumerStatefulWidget {
  const DesktopShell({super.key});

  @override
  ConsumerState<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends ConsumerState<DesktopShell> {
  int _tourStep = 0;

  @override
  Widget build(BuildContext context) {
    final selectedMeetingId = ref.watch(selectedMeetingIdProvider);
    final section = ref.watch(appSectionProvider);
    final showTour = ref
        .watch(guidedTourCompleteProvider)
        .maybeWhen(data: (complete) => !complete, orElse: () => false);

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              const MeetingSidebar(),
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      if (section == AppSection.meetings) ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: RecordingPanel(),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: switch (section) {
                            AppSection.todos => const GlobalTodosView(
                              key: ValueKey('todos'),
                            ),
                            AppSection.learning => const LearningView(
                              key: ValueKey('learning'),
                            ),
                            AppSection.settings => const SettingsView(
                              key: ValueKey('settings'),
                            ),
                            AppSection.meetings =>
                              selectedMeetingId == null
                                  ? const _EmptyWorkspace(
                                      key: ValueKey('empty'),
                                    )
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
          if (showTour)
            _GuidedTourOverlay(
              stepIndex: _tourStep,
              onNext: _nextTourStep,
              onSkip: _finishTour,
              onFinish: _finishTour,
            ),
        ],
      ),
    );
  }

  void _nextTourStep() {
    final next = (_tourStep + 1).clamp(0, _tourSteps.length - 1);
    setState(() => _tourStep = next);
    _showTourSection(_tourSteps[next].section);
  }

  Future<void> _finishTour() async {
    await ref.read(settingsRepositoryProvider).saveGuidedTourComplete(true);
    ref.invalidate(guidedTourCompleteProvider);
  }

  void _showTourSection(AppSection section) {
    final controller = ref.read(appSectionProvider.notifier);
    switch (section) {
      case AppSection.meetings:
        controller.showMeetings();
      case AppSection.todos:
        controller.showTodos();
      case AppSection.learning:
        controller.showLearning();
      case AppSection.settings:
        controller.showSettings();
    }
  }
}

const _tourSteps = [
  _TourStepData(
    section: AppSection.meetings,
    icon: Icons.forum_outlined,
    title: 'Meetings aufnehmen',
    body:
        'Hier startest du neue Sessions. MeetlyAI nimmt Mikrofon und Desktop-Audio auf, transkribiert lokal und erstellt danach Summary, Entscheidungen und Chat-Kontext.',
    alignment: Alignment.bottomRight,
  ),
  _TourStepData(
    section: AppSection.meetings,
    icon: Icons.chat_bubble_outline,
    title: 'Transkript, Summary und Chat',
    body:
        'Nach einer Aufnahme wechselst du oben zwischen Transkript, AI Summary und Chat. Der Chat beantwortet Fragen mit Meeting-Kontext und Markdown-Tabellen.',
    alignment: Alignment.centerRight,
  ),
  _TourStepData(
    section: AppSection.todos,
    icon: Icons.checklist_outlined,
    title: 'Todos zentral verwalten',
    body:
        'Alle Action Items aus Meetings landen gesammelt hier. Du kannst Aufgaben abhaken, bearbeiten und später gezielt nachfassen.',
    alignment: Alignment.center,
  ),
  _TourStepData(
    section: AppSection.learning,
    icon: Icons.school_outlined,
    title: 'Lernen mit Unterlagen',
    body:
        'Im Lernen-Bereich organisierst du Ordner, PDFs, Meetings und Lernmaterial. Daraus entstehen Lernzettel, Karteikarten, Quizze und ein quellengebundener Chat.',
    alignment: Alignment.centerRight,
  ),
  _TourStepData(
    section: AppSection.settings,
    icon: Icons.tune,
    title: 'Setup jederzeit ändern',
    body:
        'In den Einstellungen findest du Gemini, OpenAI-kompatible Provider, Whisper-Modellpfade, Transkriptionsintervalle und lokale Audio-Optionen.',
    alignment: Alignment.centerRight,
  ),
];

class _TourStepData {
  const _TourStepData({
    required this.section,
    required this.icon,
    required this.title,
    required this.body,
    required this.alignment,
  });

  final AppSection section;
  final IconData icon;
  final String title;
  final String body;
  final Alignment alignment;
}

class _GuidedTourOverlay extends StatelessWidget {
  const _GuidedTourOverlay({
    required this.stepIndex,
    required this.onNext,
    required this.onSkip,
    required this.onFinish,
  });

  final int stepIndex;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final step = _tourSteps[stepIndex];
    final isLast = stepIndex == _tourSteps.length - 1;
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Container(
          color: Colors.black.withValues(alpha: 0.34),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Align(
                alignment: step.alignment,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFF15191F),
                      border: Border.all(color: const Color(0xFF33404C)),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 34,
                          color: Color(0x66000000),
                          offset: Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              step.icon,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Rundgang ${stepIndex + 1}/${_tourSteps.length}',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: const Color(0xFF9AA4B2),
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          step.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          step.body,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                height: 1.45,
                                color: const Color(0xFFCBD3DF),
                              ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            TextButton(
                              onPressed: onSkip,
                              child: const Text('Überspringen'),
                            ),
                            const Spacer(),
                            FilledButton.icon(
                              onPressed: isLast ? onFinish : onNext,
                              icon: Icon(
                                isLast ? Icons.check : Icons.arrow_forward,
                              ),
                              label: Text(isLast ? 'Fertig' : 'Weiter'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
