import 'dart:io' show Platform;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 460,
      backgroundColor: const Color(0xFF0F1217),
      child: SettingsView(onClose: () => Navigator.of(context).pop()),
    );
  }
}

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key, this.onClose});

  final VoidCallback? onClose;

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final _apiKeyController = TextEditingController();
  final _geminiModelController = TextEditingController();
  final _whisperPathController = TextEditingController();
  final _whisperExecutableController = TextEditingController();
  final _openAiApiKeyController = TextEditingController();
  final _openAiBaseUrlController = TextEditingController();
  final _openAiModelNameController = TextEditingController();

  String _llmProvider = 'gemini';
  String _language = 'auto';
  int _chunkIntervalSeconds = 25;
  bool _loaded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _geminiModelController.dispose();
    _whisperPathController.dispose();
    _whisperExecutableController.dispose();
    _openAiApiKeyController.dispose();
    _openAiBaseUrlController.dispose();
    _openAiModelNameController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final settings = ref.read(settingsRepositoryProvider);
    final apiKey = await settings.getGeminiApiKey();
    final model = await settings.getGeminiModel();
    final whisperPath = await settings.getWhisperModelPath();
    final whisperExecutablePath = await settings.getWhisperExecutablePath();
    final language = await settings.getPreferredLanguage();
    final chunkIntervalSeconds = await settings
        .getChunkTranscriptionIntervalSeconds();
    final llmProvider = await settings.getLlmProvider() ?? 'gemini';
    final openAiApiKey = await settings.getOpenAiApiKey();
    final openAiBaseUrl = await settings.getOpenAiBaseUrl();
    final openAiModelName = await settings.getOpenAiModelName();

    if (!mounted) {
      return;
    }
    setState(() {
      _apiKeyController.text = apiKey ?? '';
      _geminiModelController.text = model ?? 'gemini-2.5-flash';
      _whisperPathController.text = whisperPath ?? '';
      _whisperExecutableController.text = whisperExecutablePath ?? '';
      _language = language ?? 'auto';
      _chunkIntervalSeconds = chunkIntervalSeconds;
      _llmProvider = llmProvider;
      _openAiApiKeyController.text = openAiApiKey ?? '';
      _openAiBaseUrlController.text = openAiBaseUrl ?? '';
      _openAiModelNameController.text = openAiModelName ?? '';
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _SettingsHeader(onClose: widget.onClose),
          Expanded(
            child: !_loaded
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 880),
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
                        children: [
                          _AiProviderSection(
                            provider: _llmProvider,
                            onProviderChanged: (value) =>
                                setState(() => _llmProvider = value),
                            geminiApiKeyController: _apiKeyController,
                            geminiModelController: _geminiModelController,
                            openAiApiKeyController: _openAiApiKeyController,
                            openAiBaseUrlController: _openAiBaseUrlController,
                            openAiModelNameController:
                                _openAiModelNameController,
                          ),
                          const SizedBox(height: 14),
                          _SettingsCard(
                            icon: Icons.graphic_eq,
                            title: 'Local transcription',
                            subtitle:
                                'Whisper stays on-device. These paths are read locally and never sent to an API.',
                            children: [
                              _PathField(
                                label: 'Whisper model',
                                hintText: '/models/ggml-large-v3-turbo.bin',
                                controller: _whisperPathController,
                                icon: Icons.storage_outlined,
                                tooltip: 'Choose model file',
                                onPick: _pickWhisperModel,
                              ),
                              const SizedBox(height: 12),
                              _PathField(
                                label: 'Whisper executable',
                                hintText: '/whisper.cpp/build/bin/whisper-cli',
                                controller: _whisperExecutableController,
                                icon: Icons.terminal,
                                tooltip: 'Choose whisper-cli',
                                onPick: _pickWhisperExecutable,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _SettingsCard(
                            icon: Icons.tune,
                            title: 'Recording defaults',
                            subtitle:
                                'Defaults used for new meetings and live local chunk transcription.',
                            children: [
                              _FieldLabel(
                                title: 'Meeting language',
                                subtitle:
                                    'Auto is best for mixed German and English meetings.',
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: SegmentedButton<String>(
                                  segments: const [
                                    ButtonSegment(
                                      value: 'auto',
                                      icon: Icon(Icons.auto_mode, size: 18),
                                      label: Text('Auto'),
                                    ),
                                    ButtonSegment(
                                      value: 'de',
                                      label: Text('DE'),
                                    ),
                                    ButtonSegment(
                                      value: 'en',
                                      label: Text('EN'),
                                    ),
                                  ],
                                  selected: {_language},
                                  showSelectedIcon: false,
                                  onSelectionChanged: (value) {
                                    setState(() => _language = value.single);
                                  },
                                ),
                              ),
                              const SizedBox(height: 18),
                              _FieldLabel(
                                title: 'Live transcription interval',
                                subtitle:
                                    'Shorter chunks feel more live. Longer chunks use less CPU.',
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      min: 10,
                                      max: 120,
                                      divisions: 22,
                                      value: _chunkIntervalSeconds.toDouble(),
                                      label: '${_chunkIntervalSeconds}s',
                                      onChanged: (value) {
                                        setState(() {
                                          _chunkIntervalSeconds = value.round();
                                        });
                                      },
                                    ),
                                  ),
                                  _ValuePill('${_chunkIntervalSeconds}s'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          if (_loaded)
            _SaveBar(saving: _saving, onSave: _saving ? null : _save),
        ],
      ),
    );
  }

  Future<void> _pickWhisperModel() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['bin', 'gguf'],
      );
      final path = result?.files.single.path;
      if (path == null) {
        return;
      }
      setState(() => _whisperPathController.text = path);
    } on MissingPluginException catch (_) {
      if (!mounted) return;
      final msg = Platform.isMacOS
          ? 'File picker plugin not available on macOS. Please enter the model path manually.'
          : 'File picker plugin not available on this platform.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick file: $error')));
    }
  }

  Future<void> _pickWhisperExecutable() async {
    try {
      final result = await FilePicker.pickFiles();
      final path = result?.files.single.path;
      if (path == null) {
        return;
      }
      setState(() => _whisperExecutableController.text = path);
    } on MissingPluginException catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File picker unavailable. Enter whisper-cli manually.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick executable: $error')),
      );
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final settings = ref.read(settingsRepositoryProvider);
      final apiKey = _apiKeyController.text.trim();
      if (apiKey.isEmpty) {
        await settings.clearGeminiApiKey();
      } else {
        await settings.saveGeminiApiKey(apiKey);
      }
      await settings.saveGeminiModel(_geminiModelController.text.trim());
      await settings.saveWhisperModelPath(_whisperPathController.text.trim());
      await settings.saveWhisperExecutablePath(
        _whisperExecutableController.text.trim(),
      );
      await settings.savePreferredLanguage(_language);
      await settings.saveChunkTranscriptionIntervalSeconds(
        _chunkIntervalSeconds,
      );
      await settings.saveLlmProvider(_llmProvider);
      await settings.saveOpenAiApiKey(_openAiApiKeyController.text.trim());
      await settings.saveOpenAiBaseUrl(_openAiBaseUrlController.text.trim());
      await settings.saveOpenAiModelName(
        _openAiModelNameController.text.trim(),
      );

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Settings saved')));
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 18, 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Local transcription, AI provider, and recording defaults.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF9AA4B2),
                  ),
                ),
              ],
            ),
          ),
          if (onClose != null)
            IconButton(
              tooltip: 'Close',
              onPressed: onClose,
              icon: const Icon(Icons.close),
            ),
        ],
      ),
    );
  }
}

class _AiProviderSection extends StatelessWidget {
  const _AiProviderSection({
    required this.provider,
    required this.onProviderChanged,
    required this.geminiApiKeyController,
    required this.geminiModelController,
    required this.openAiApiKeyController,
    required this.openAiBaseUrlController,
    required this.openAiModelNameController,
  });

  final String provider;
  final ValueChanged<String> onProviderChanged;
  final TextEditingController geminiApiKeyController;
  final TextEditingController geminiModelController;
  final TextEditingController openAiApiKeyController;
  final TextEditingController openAiBaseUrlController;
  final TextEditingController openAiModelNameController;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      icon: Icons.auto_awesome,
      title: 'AI provider',
      subtitle:
          'Used for summaries, decisions, action items, and meeting chat.',
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'gemini',
                icon: Icon(Icons.bolt_outlined, size: 18),
                label: Text('Gemini'),
              ),
              ButtonSegment(
                value: 'openai_compatible',
                icon: Icon(Icons.hub_outlined, size: 18),
                label: Text('OpenAI compatible'),
              ),
            ],
            selected: {provider},
            showSelectedIcon: false,
            onSelectionChanged: (value) => onProviderChanged(value.single),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: provider == 'openai_compatible'
              ? Column(
                  key: const ValueKey('openai-compatible-settings'),
                  children: [
                    _SettingsTextField(
                      label: 'API key',
                      hintText: 'choose-any-value',
                      controller: openAiApiKeyController,
                      icon: Icons.key_outlined,
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    _SettingsTextField(
                      label: 'Base URL',
                      hintText: 'https://example.com/v1',
                      controller: openAiBaseUrlController,
                      icon: Icons.link,
                    ),
                    const SizedBox(height: 12),
                    _SettingsTextField(
                      label: 'Model',
                      hintText: 'model-name',
                      controller: openAiModelNameController,
                      icon: Icons.memory_outlined,
                    ),
                  ],
                )
              : Column(
                  key: const ValueKey('gemini-settings'),
                  children: [
                    _SettingsTextField(
                      label: 'Gemini API key',
                      hintText: 'AIza...',
                      controller: geminiApiKeyController,
                      icon: Icons.key_outlined,
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    _SettingsTextField(
                      label: 'Gemini model',
                      hintText: 'gemini-2.5-flash',
                      controller: geminiModelController,
                      icon: Icons.memory_outlined,
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF15191F),
        border: Border.all(color: const Color(0xFF262D36)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
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
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9AA4B2)),
          ),
        ],
      ),
    );
  }
}

class _SettingsTextField extends StatelessWidget {
  const _SettingsTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.icon,
    this.obscureText = false,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

class _PathField extends StatelessWidget {
  const _PathField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.icon,
    required this.tooltip,
    required this.onPick,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SettingsTextField(
            label: label,
            hintText: hintText,
            controller: controller,
            icon: icon,
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          tooltip: tooltip,
          onPressed: onPick,
          icon: const Icon(Icons.folder_open),
        ),
      ],
    );
  }
}

class _ValuePill extends StatelessWidget {
  const _ValuePill(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1217),
        border: Border.all(color: const Color(0xFF262D36)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.saving, required this.onSave});

  final bool saving;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0F1217),
        border: Border(top: BorderSide(color: Color(0xFF252B33))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Changes are stored locally on this device.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9AA4B2)),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: onSave,
            icon: saving
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: Text(saving ? 'Saving...' : 'Save'),
          ),
        ],
      ),
    );
  }
}
