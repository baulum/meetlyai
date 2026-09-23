import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../data/services/onboarding_setup_service.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final _pageController = PageController();
  final _geminiKeyController = TextEditingController();
  int _page = 0;
  bool _busy = false;
  double? _downloadProgress;
  String? _whisperStatus;
  String? _error;
  WhisperModelOption _selectedModel = OnboardingSetupService.modelOptions.first;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _inspectWhisper());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _geminiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _WelcomeStep(onNext: _next),
      _PrivacyStep(onNext: _next, onBack: _back),
      _WhisperStep(
        busy: _busy,
        status: _whisperStatus,
        error: _error,
        downloadProgress: _downloadProgress,
        selectedModel: _selectedModel,
        onModelChanged: (model) => setState(() => _selectedModel = model),
        onInstall: _setupWhisper,
        onSkip: _next,
        onBack: _back,
      ),
      _GeminiStep(
        controller: _geminiKeyController,
        busy: _busy,
        onSave: _saveGeminiAndNext,
        onSkip: _next,
        onBack: _back,
      ),
      _TourStep(onFinish: _finish, onBack: _back, busy: _busy),
    ];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B0D10), Color(0xFF111C1B), Color(0xFF101318)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.graphic_eq, color: Colors.black),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'MeetlyAI Setup',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Text('${_page + 1} / ${pages.length}'),
                  ],
                ),
                const SizedBox(height: 18),
                LinearProgressIndicator(value: (_page + 1) / pages.length),
                const SizedBox(height: 22),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (value) => setState(() => _page = value),
                    children: pages,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _inspectWhisper() async {
    final status = await ref
        .read(onboardingSetupServiceProvider)
        .inspectWhisper();
    if (!mounted) {
      return;
    }
    setState(() {
      _whisperStatus = status.isReady
          ? 'Bereit: ${status.executablePath}\nModell: ${status.modelPath}'
          : status.hasExecutable
          ? 'whisper-cli gefunden: ${status.executablePath}\nLokales Modell fehlt noch.'
          : 'whisper-cli wurde noch nicht gefunden.';
    });
  }

  Future<void> _setupWhisper() async {
    setState(() {
      _busy = true;
      _error = null;
      _downloadProgress = null;
      _whisperStatus = 'Prüfe whisper-cli...';
    });
    try {
      final service = ref.read(onboardingSetupServiceProvider);
      final installStatus = await service.installWhisperCli();
      setState(() {
        _whisperStatus =
            'whisper-cli bereit: ${installStatus.executablePath}\nLade ${_selectedModel.name} (${_selectedModel.sizeLabel})...';
        _downloadProgress = 0;
      });
      final modelPath = await service.downloadModel(
        _selectedModel,
        onProgress: (progress) {
          if (mounted) {
            setState(() => _downloadProgress = progress);
          }
        },
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _whisperStatus = 'Lokale Transkription ist bereit.\nModell: $modelPath';
        _downloadProgress = 1;
      });
    } catch (error) {
      if (mounted) {
        setState(() => _error = '$error');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _saveGeminiAndNext() async {
    final key = _geminiKeyController.text.trim();
    if (key.isNotEmpty) {
      await ref.read(settingsRepositoryProvider).saveGeminiApiKey(key);
    }
    _next();
  }

  Future<void> _finish() async {
    setState(() => _busy = true);
    await ref.read(onboardingSetupServiceProvider).completeOnboarding();
    ref.invalidate(onboardingCompleteProvider);
  }

  void _next() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _back() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _OnboardingCard(
      icon: Icons.auto_awesome,
      title: 'Willkommen bei MeetlyAI',
      subtitle:
          'Lokale Meeting-Aufnahme, lokale Transkription, KI-Zusammenfassungen und Lernen aus Unterlagen in einer Desktop-App.',
      primaryLabel: 'Setup starten',
      onPrimary: onNext,
      children: const [
        _FeatureRow(Icons.mic_none, 'Mikrofon und Desktop-Audio aufnehmen'),
        _FeatureRow(Icons.lock_outline, 'Transkription lokal mit whisper.cpp'),
        _FeatureRow(
          Icons.menu_book_outlined,
          'Lernen aus PDFs, Meetings und Chats',
        ),
      ],
    );
  }
}

class _PrivacyStep extends StatelessWidget {
  const _PrivacyStep({required this.onNext, required this.onBack});

  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return _OnboardingCard(
      icon: Icons.privacy_tip_outlined,
      title: 'Was lokal bleibt und was KI nutzt',
      subtitle:
          'MeetlyAI trennt lokale Verarbeitung von KI-Analyse, damit du bewusst entscheiden kannst.',
      primaryLabel: 'Weiter',
      secondaryLabel: 'Zurück',
      onPrimary: onNext,
      onSecondary: onBack,
      children: const [
        _FeatureRow(
          Icons.computer,
          'Audio und Whisper-Transkription laufen lokal.',
        ),
        _FeatureRow(
          Icons.cloud_outlined,
          'Gemini wird für Summary, Chat und PDF-Vision genutzt.',
        ),
        _FeatureRow(Icons.key_outlined, 'Dein API-Key wird lokal gespeichert.'),
      ],
    );
  }
}

class _WhisperStep extends StatelessWidget {
  const _WhisperStep({
    required this.busy,
    required this.status,
    required this.error,
    required this.downloadProgress,
    required this.selectedModel,
    required this.onModelChanged,
    required this.onInstall,
    required this.onSkip,
    required this.onBack,
  });

  final bool busy;
  final String? status;
  final String? error;
  final double? downloadProgress;
  final WhisperModelOption selectedModel;
  final ValueChanged<WhisperModelOption> onModelChanged;
  final VoidCallback onInstall;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return _OnboardingCard(
      icon: Icons.graphic_eq,
      title: 'Lokale Transkription einrichten',
      subtitle:
          'MeetlyAI kann whisper.cpp lokal klonen, whisper-cli mit CMake bauen und eines der ggml-Modelle herunterladen.',
      primaryLabel: busy ? 'Arbeite...' : 'Whisper automatisch einrichten',
      secondaryLabel: 'Überspringen',
      tertiaryLabel: 'Zurück',
      onPrimary: busy ? null : onInstall,
      onSecondary: busy ? null : onSkip,
      onTertiary: busy ? null : onBack,
      children: [
        _ModelPicker(
          selected: selectedModel,
          enabled: !busy,
          onChanged: onModelChanged,
        ),
        const SizedBox(height: 12),
        _StatusBox(text: status ?? 'Prüfe lokale Whisper-Installation...'),
        if (downloadProgress != null) ...[
          const SizedBox(height: 12),
          LinearProgressIndicator(value: downloadProgress),
        ],
        if (error != null) ...[
          const SizedBox(height: 12),
          _StatusBox(text: error!, isError: true),
        ],
      ],
    );
  }
}

class _ModelPicker extends StatelessWidget {
  const _ModelPicker({
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  final WhisperModelOption selected;
  final bool enabled;
  final ValueChanged<WhisperModelOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final models = OnboardingSetupService.modelOptions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Whisper Modell',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 680;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final model in models)
                  SizedBox(
                    width: isNarrow
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 10) / 2,
                    child: _ModelOptionCard(
                      model: model,
                      selected: model.id == selected.id,
                      enabled: enabled,
                      onTap: () => onChanged(model),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ModelOptionCard extends StatelessWidget {
  const _ModelOptionCard({
    required this.model,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final WhisperModelOption model;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.13)
              : const Color(0xFF101419),
          border: Border.all(
            color: selected ? colorScheme.primary : const Color(0xFF2B333D),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? colorScheme.primary : const Color(0xFF8D98A7),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        model.sizeLabel,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: const Color(0xFFB8C0CC)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    model.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF9AA4B2),
                      height: 1.35,
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

class _GeminiStep extends StatelessWidget {
  const _GeminiStep({
    required this.controller,
    required this.busy,
    required this.onSave,
    required this.onSkip,
    required this.onBack,
  });

  final TextEditingController controller;
  final bool busy;
  final VoidCallback onSave;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return _OnboardingCard(
      icon: Icons.key_outlined,
      title: 'Gemini verbinden',
      subtitle:
          'Gemini erstellt Zusammenfassungen, beantwortet Meeting-Fragen und analysiert PDF-Bilder/Handschrift.',
      primaryLabel: 'Speichern und weiter',
      secondaryLabel: 'Später',
      tertiaryLabel: 'Zurück',
      onPrimary: busy ? null : onSave,
      onSecondary: busy ? null : onSkip,
      onTertiary: busy ? null : onBack,
      children: [
        TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Gemini API Key',
            hintText: 'AIza...',
            prefixIcon: Icon(Icons.vpn_key_outlined),
          ),
        ),
      ],
    );
  }
}

class _TourStep extends StatelessWidget {
  const _TourStep({
    required this.onFinish,
    required this.onBack,
    required this.busy,
  });

  final VoidCallback onFinish;
  final VoidCallback onBack;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return _OnboardingCard(
      icon: Icons.route_outlined,
      title: 'Kurzer Rundgang',
      subtitle:
          'So ist die App aufgebaut. Du findest diese Bereiche später links in der Sidebar.',
      primaryLabel: busy ? 'Speichere...' : 'MeetlyAI öffnen',
      secondaryLabel: 'Zurück',
      onPrimary: busy ? null : onFinish,
      onSecondary: busy ? null : onBack,
      children: const [
        _FeatureRow(
          Icons.forum_outlined,
          'Meetings: aufnehmen, transkribieren, zusammenfassen, chatten.',
        ),
        _FeatureRow(
          Icons.checklist_outlined,
          'Todos: Action Items aus allen Meetings gesammelt bearbeiten.',
        ),
        _FeatureRow(
          Icons.school_outlined,
          'Lernen: PDFs hochladen, Lernzettel, Karten und Quiz erzeugen.',
        ),
        _FeatureRow(
          Icons.settings_outlined,
          'Einstellungen: KI, Whisper, Modellpfade und Intervalle ändern.',
        ),
      ],
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.tertiaryLabel,
    this.onTertiary,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final String? tertiaryLabel;
  final VoidCallback? onTertiary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF15191F),
              border: Border.all(color: const Color(0xFF28313B)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 42,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFFB8C0CC),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                ...children,
                const SizedBox(height: 28),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: onPrimary,
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(primaryLabel),
                    ),
                    if (secondaryLabel != null)
                      OutlinedButton(
                        onPressed: onSecondary,
                        child: Text(secondaryLabel!),
                      ),
                    if (tertiaryLabel != null)
                      TextButton(
                        onPressed: onTertiary,
                        child: Text(tertiaryLabel!),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _StatusBox extends StatelessWidget {
  const _StatusBox({required this.text, this.isError = false});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFF2A1818) : const Color(0xFF101419),
        border: Border.all(
          color: isError ? const Color(0xFF8A3A3A) : const Color(0xFF2B333D),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text),
    );
  }
}
