import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/services/settings_repository.dart';

class OnboardingSetupService {
  OnboardingSetupService(this._settings);

  static const whisperCppRepositoryUrl =
      'https://github.com/ggml-org/whisper.cpp.git';

  static const modelOptions = [
    WhisperModelOption(
      id: 'large-v3-turbo',
      name: 'Large v3 Turbo',
      fileName: 'ggml-large-v3-turbo.bin',
      sizeLabel: '1.62 GB',
      description: '(Empfohlen) Sehr gute Qualität, schneller als Large v3 Standard.',
      url:
          'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin?download=true',
    ),
    WhisperModelOption(
      id: 'small',
      name: 'Small',
      fileName: 'ggml-small.bin',
      sizeLabel: '488 MB',
      description: 'Guter Einstieg, schnell und deutlich kleiner.',
      url:
          'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.bin?download=true',
    ),
    WhisperModelOption(
      id: 'medium',
      name: 'Medium',
      fileName: 'ggml-medium.bin',
      sizeLabel: '1.53 GB',
      description: 'Solider Qualitäts-/Performance-Kompromiss.',
      url:
          'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-medium.bin?download=true',
    ),
    WhisperModelOption(
      id: 'large-v3',
      name: 'Large v3 Standard',
      fileName: 'ggml-large-v3.bin',
      sizeLabel: '3.1 GB',
      description: 'Beste Qualität, benötigt am meisten Speicher und Zeit.',
      url:
          'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3.bin?download=true',
    ),
  ];

  final SettingsRepository _settings;

  Future<WhisperSetupStatus> inspectWhisper() async {
    final executable = await _findWhisperExecutable();
    final modelPath = await _settings.getWhisperModelPath();
    final modelExists =
        modelPath != null &&
        modelPath.trim().isNotEmpty &&
        await File(modelPath).exists();
    return WhisperSetupStatus(
      executablePath: executable,
      modelPath: modelExists ? modelPath : null,
    );
  }

  Future<WhisperSetupStatus> installWhisperCli() async {
    final existing = await _findWhisperExecutable();
    if (existing != null) {
      await _settings.saveWhisperExecutablePath(existing);
      return WhisperSetupStatus(executablePath: existing);
    }

    final git = await _findExecutable('git');
    final cmake = await _findExecutable('cmake');
    if (git == null || cmake == null) {
      throw StateError(
        'Automatic whisper-cli install needs git and cmake. Install both, then run onboarding again.',
      );
    }

    final repo = await _whisperCppDirectory();
    if (!await repo.exists()) {
      await repo.parent.create(recursive: true);
      await _runChecked(git, [
        'clone',
        whisperCppRepositoryUrl,
        repo.path,
      ], 'git clone whisper.cpp failed');
    }

    await _runChecked(
      cmake,
      ['-B', 'build', '-DCMAKE_BUILD_TYPE=Release'],
      'cmake configure failed',
      workingDirectory: repo.path,
    );
    await _runChecked(
      cmake,
      ['--build', 'build', '-j', '--config', 'Release'],
      'cmake build failed',
      workingDirectory: repo.path,
    );

    final installed = await _findBuiltWhisperExecutable(repo);
    if (installed == null) {
      throw StateError('whisper-cli was built but could not be found.');
    }
    await _settings.saveWhisperExecutablePath(installed);
    return WhisperSetupStatus(executablePath: installed);
  }

  Future<String> downloadModel(
    WhisperModelOption option, {
    void Function(double progress)? onProgress,
  }) async {
    final docs = await getApplicationDocumentsDirectory();
    final modelsDir = Directory(p.join(docs.path, 'MeetlyAI', 'models'));
    await modelsDir.create(recursive: true);
    final target = File(p.join(modelsDir.path, option.fileName));
    if (await target.exists() && await target.length() > 50 * 1024 * 1024) {
      await _settings.saveWhisperModelPath(target.path);
      onProgress?.call(1);
      return target.path;
    }

    final request = await HttpClient().getUrl(Uri.parse(option.url));
    final response = await request.close();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'Model download failed with HTTP ${response.statusCode}.',
      );
    }

    final tmp = File('${target.path}.download');
    final sink = tmp.openWrite();
    var received = 0;
    final total = response.contentLength;
    try {
      await for (final chunk in response) {
        received += chunk.length;
        sink.add(chunk);
        if (total > 0) {
          onProgress?.call((received / total).clamp(0, 1).toDouble());
        }
      }
    } finally {
      await sink.close();
    }
    if (await target.exists()) {
      await target.delete();
    }
    await tmp.rename(target.path);
    await _settings.saveWhisperModelPath(target.path);
    onProgress?.call(1);
    return target.path;
  }

  Future<void> completeOnboarding() {
    return _settings.saveOnboardingComplete(true);
  }

  Future<Directory> _whisperCppDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    return Directory(p.join(docs.path, 'MeetlyAI', 'tools', 'whisper.cpp'));
  }

  Future<String?> _findWhisperExecutable() async {
    final configured = await _settings.getWhisperExecutablePath();
    if (configured != null &&
        configured.trim().isNotEmpty &&
        await File(configured.trim()).exists()) {
      return configured.trim();
    }
    for (final candidate in [
      'whisper-cli',
      '/opt/homebrew/bin/whisper-cli',
      '/usr/local/bin/whisper-cli',
      '/opt/homebrew/bin/main',
      '/usr/local/bin/main',
      '${Platform.environment['HOME'] ?? ''}/whisper.cpp/build/bin/whisper-cli',
      '${Platform.environment['HOME'] ?? ''}/whisper.cpp/build/bin/main',
    ]) {
      final found = await _findExecutable(candidate);
      if (found != null) {
        return found;
      }
    }
    return null;
  }

  Future<String?> _findExecutable(String candidate) async {
    if (candidate.contains('/')) {
      return await File(candidate).exists() ? candidate : null;
    }
    if (Platform.isWindows) {
      final result = await Process.run('where', [candidate], runInShell: true);
      if (result.exitCode == 0) {
        final path = result.stdout.toString().trim().split('\n').first.trim();
        return path.isEmpty ? null : path;
      }
      return null;
    }
    final result = await Process.run('/usr/bin/env', [
      'which',
      candidate,
    ], runInShell: false);
    if (result.exitCode == 0) {
      final path = result.stdout.toString().trim();
      return path.isEmpty ? null : path;
    }
    for (final shell in ['/bin/zsh', '/bin/bash']) {
      if (!await File(shell).exists()) {
        continue;
      }
      final shellResult = await Process.run(shell, [
        '-lic',
        'command -v $candidate',
      ], runInShell: false);
      if (shellResult.exitCode == 0) {
        final path = shellResult.stdout.toString().trim().split('\n').first;
        if (path.isNotEmpty) {
          return path;
        }
      }
    }
    return null;
  }

  Future<String?> _findBuiltWhisperExecutable(Directory repo) async {
    final names = Platform.isWindows
        ? const ['whisper-cli.exe', 'main.exe']
        : const ['whisper-cli', 'main'];
    for (final relative in [
      for (final name in names) p.join('build', 'bin', name),
      for (final name in names) p.join('build', 'examples', 'cli', name),
      for (final name in names) p.join('build', name),
    ]) {
      final file = File(p.join(repo.path, relative));
      if (await file.exists()) {
        return file.path;
      }
    }
    return null;
  }

  Future<void> _runChecked(
    String executable,
    List<String> arguments,
    String failureMessage, {
    String? workingDirectory,
  }) async {
    final result = await Process.run(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      runInShell: false,
    );
    if (result.exitCode != 0) {
      throw StateError(
        '$failureMessage.\nstdout: ${result.stdout}\nstderr: ${result.stderr}',
      );
    }
  }
}

class WhisperModelOption {
  const WhisperModelOption({
    required this.id,
    required this.name,
    required this.fileName,
    required this.sizeLabel,
    required this.description,
    required this.url,
  });

  final String id;
  final String name;
  final String fileName;
  final String sizeLabel;
  final String description;
  final String url;
}

class WhisperSetupStatus {
  const WhisperSetupStatus({this.executablePath, this.modelPath});

  final String? executablePath;
  final String? modelPath;

  bool get hasExecutable =>
      executablePath != null && executablePath!.isNotEmpty;
  bool get hasModel => modelPath != null && modelPath!.isNotEmpty;
  bool get isReady => hasExecutable && hasModel;
}
