import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/services/settings_repository.dart';

class OnboardingSetupService {
  OnboardingSetupService(this._settings);

  static const defaultModelFileName = 'ggml-base.bin';
  static const defaultModelUrl =
      'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin';

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

    if (!Platform.isMacOS) {
      throw StateError(
        'Automatic whisper-cli install is currently supported on macOS with Homebrew. Install whisper.cpp manually and paste the path in Settings.',
      );
    }

    final brew = await _findExecutable('brew');
    if (brew == null) {
      throw StateError(
        'Homebrew is required for automatic install. Install Homebrew first, then run onboarding again.',
      );
    }

    final result = await Process.run(brew, [
      'install',
      'whisper-cpp',
    ], runInShell: false);
    if (result.exitCode != 0) {
      throw StateError(
        'brew install whisper-cpp failed.\nstdout: ${result.stdout}\nstderr: ${result.stderr}',
      );
    }

    final installed = await _findWhisperExecutable();
    if (installed == null) {
      throw StateError('whisper-cli was installed but could not be found.');
    }
    await _settings.saveWhisperExecutablePath(installed);
    return WhisperSetupStatus(executablePath: installed);
  }

  Future<String> downloadDefaultModel({
    void Function(double progress)? onProgress,
  }) async {
    final docs = await getApplicationDocumentsDirectory();
    final modelsDir = Directory(p.join(docs.path, 'MeetlyAI', 'models'));
    await modelsDir.create(recursive: true);
    final target = File(p.join(modelsDir.path, defaultModelFileName));
    if (await target.exists() && await target.length() > 50 * 1024 * 1024) {
      await _settings.saveWhisperModelPath(target.path);
      onProgress?.call(1);
      return target.path;
    }

    final request = await HttpClient().getUrl(Uri.parse(defaultModelUrl));
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
      '${Platform.environment['HOME'] ?? ''}/whisper.cpp/build/bin/whisper-cli',
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
