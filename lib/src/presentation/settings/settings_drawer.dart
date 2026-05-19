import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 420,
      backgroundColor: const Color(0xFF101318),
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
  String _language = 'auto';
  int _chunkIntervalSeconds = 25;
  bool _loaded = false;

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
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: !_loaded
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Settings',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      if (widget.onClose != null)
                        IconButton(
                          tooltip: 'Close',
                          onPressed: widget.onClose,
                          icon: const Icon(Icons.close),
                        ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _Label(
                    title: 'Gemini API key',
                    subtitle: 'Stored locally in the OS secure store.',
                  ),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'AIza...',
                      prefixIcon: Icon(Icons.key),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _Label(
                    title: 'Gemini model',
                    subtitle: 'Default production model for summaries/chat.',
                  ),
                  TextField(
                    controller: _geminiModelController,
                    decoration: const InputDecoration(
                      hintText: 'gemini-2.5-flash',
                      prefixIcon: Icon(Icons.auto_awesome),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _Label(
                    title: 'Whisper model',
                    subtitle: 'Local ggml model path for whisper.cpp.',
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _whisperPathController,
                          decoration: const InputDecoration(
                            hintText: '/models/ggml-medium.bin',
                            prefixIcon: Icon(Icons.storage),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Choose model file',
                        onPressed: _pickWhisperModel,
                        icon: const Icon(Icons.folder_open),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _Label(
                    title: 'Whisper executable',
                    subtitle:
                        'Path to whisper-cli. Useful because macOS apps do not inherit your Terminal PATH.',
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _whisperExecutableController,
                          decoration: const InputDecoration(
                            hintText:
                                '/Users/paul/whisper.cpp/build/bin/whisper-cli',
                            prefixIcon: Icon(Icons.terminal),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Choose executable',
                        onPressed: _pickWhisperExecutable,
                        icon: const Icon(Icons.folder_open),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _Label(
                    title: 'Meeting language',
                    subtitle: 'Use auto unless you know the meeting language.',
                  ),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'auto', label: Text('Auto')),
                      ButtonSegment(value: 'de', label: Text('DE')),
                      ButtonSegment(value: 'en', label: Text('EN')),
                    ],
                    selected: {_language},
                    onSelectionChanged: (value) {
                      setState(() => _language = value.single);
                    },
                  ),
                  const SizedBox(height: 18),
                  _Label(
                    title: 'Live transcription interval',
                    subtitle:
                        'How often MeetlyAI sends sealed mic/system chunks to local Whisper while recording.',
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
                      SizedBox(
                        width: 78,
                        child: Text(
                          '${_chunkIntervalSeconds}s',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Save settings'),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _pickWhisperModel() async {
    try {
      // The file_picker macOS implementation may not be registered in this
      // project. Catch MissingPluginException so the app doesn't crash and
      // provide a helpful message to the user.
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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick file: $e')));
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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick executable: $e')));
    }
  }

  Future<void> _save() async {
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
    await settings.saveChunkTranscriptionIntervalSeconds(_chunkIntervalSeconds);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settings saved')));
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.title, required this.subtitle});

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
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
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
