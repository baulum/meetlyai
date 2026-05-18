import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'whisper_ffi_bindings_generated.dart' as bindings;

enum WhisperSource { mic, system, mixed }

class WhisperSegment {
  const WhisperSegment({
    required this.source,
    required this.startMs,
    required this.endMs,
    required this.text,
    this.confidence,
  });

  final WhisperSource source;
  final int startMs;
  final int endMs;
  final String text;
  final double? confidence;
}

class WhisperTranscriptionJob {
  const WhisperTranscriptionJob({
    required this.meetingId,
    required this.modelPath,
    required this.audioFiles,
    this.languageCode = 'auto',
    this.executablePath,
  });

  final String meetingId;
  final String modelPath;
  final Map<WhisperSource, String> audioFiles;
  final String languageCode;
  final String? executablePath;
}

class WhisperRuntime {
  const WhisperRuntime();

  bool get hasNativeBridge {
    try {
      return bindings.sum(20, 22) == 42;
    } on Object {
      return false;
    }
  }

  Stream<WhisperSegment> transcribe(WhisperTranscriptionJob job) async* {
    if (!hasNativeBridge) {
      throw StateError('whisper.cpp FFI bridge is not available.');
    }

    final modelFile = File(job.modelPath);
    if (!modelFile.existsSync()) {
      throw StateError('Whisper model not found: ${job.modelPath}');
    }

    final executable = await _findWhisperExecutable(job.executablePath);
    if (executable == null) {
      throw StateError(
        'No whisper.cpp executable found. Install whisper.cpp and make '
        '`whisper-cli` available on PATH, or set WHISPER_CPP_BIN to the '
        'executable path. The model file exists, but the current FFI shim only '
        'performs a native health check.',
      );
    }

    for (final entry in job.audioFiles.entries) {
      final file = File(entry.value);
      if (!file.existsSync()) {
        continue;
      }
      final byteSize = await file.length();
      if (byteSize <= 44) {
        throw StateError(
          'Audio file is empty: ${file.path}. Native audio capture did not '
          'write PCM data yet, so Whisper has nothing to transcribe.',
        );
      }

      final text = await _runWhisperCli(
        executable: executable,
        modelPath: job.modelPath,
        audioPath: file.path,
        languageCode: job.languageCode,
      );
      if (text.trim().isEmpty) {
        continue;
      }
      yield WhisperSegment(
        source: entry.key,
        startMs: 0,
        endMs: 0,
        text: text.trim(),
        confidence: null,
      );
    }
  }

  Future<String?> _findWhisperExecutable(String? configuredPath) async {
    final configured = configuredPath?.trim().isNotEmpty == true
        ? configuredPath!.trim()
        : Platform.environment['WHISPER_CPP_BIN'];
    if (configured != null && configured.trim().isNotEmpty) {
      final file = File(configured.trim());
      if (await file.exists()) {
        return file.path;
      }
    }

    final candidates = <String>[
      'whisper-cli',
      'main',
      '/opt/homebrew/bin/whisper-cli',
      '/usr/local/bin/whisper-cli',
      '/opt/homebrew/bin/main',
      '/usr/local/bin/main',
      '${Platform.environment['HOME'] ?? ''}/whisper.cpp/build/bin/whisper-cli',
    ];

    for (final candidate in candidates) {
      if (candidate.isEmpty) {
        continue;
      }
      if (candidate.contains('/')) {
        if (await File(candidate).exists()) {
          return candidate;
        }
        continue;
      }
      final result = await Process.run('/usr/bin/env', [
        'which',
        candidate,
      ], runInShell: false);
      if (result.exitCode == 0) {
        final path = result.stdout.toString().trim();
        if (path.isNotEmpty) {
          return path;
        }
      }
    }
    return _findWhisperExecutableWithUserShell();
  }

  Future<String?> _findWhisperExecutableWithUserShell() async {
    if (!Platform.isMacOS && !Platform.isLinux) {
      return null;
    }

    for (final shell in ['/bin/zsh', '/bin/bash']) {
      if (!await File(shell).exists()) {
        continue;
      }
      final result = await Process.run(shell, [
        '-lic',
        'command -v whisper-cli || command -v main',
      ], runInShell: false);
      if (result.exitCode == 0) {
        final path = result.stdout.toString().trim().split('\n').first.trim();
        if (path.isNotEmpty && await File(path).exists()) {
          return path;
        }
      }
    }
    return null;
  }

  Future<String> _runWhisperCli({
    required String executable,
    required String modelPath,
    required String audioPath,
    required String languageCode,
  }) async {
    final outputBase = p.join(
      Directory.systemTemp.createTempSync('meetlyai_whisper_').path,
      p.basenameWithoutExtension(audioPath),
    );
    final language = languageCode == 'auto' ? 'auto' : languageCode;
    final result = await Process.run(executable, [
      '-m',
      modelPath,
      '-f',
      audioPath,
      '-l',
      language,
      '-otxt',
      '-of',
      outputBase,
    ], runInShell: false);

    final outputFile = File('$outputBase.txt');
    if (result.exitCode != 0) {
      throw StateError(
        'whisper.cpp failed for $audioPath.\n'
        'stdout: ${result.stdout}\n'
        'stderr: ${result.stderr}',
      );
    }
    if (await outputFile.exists()) {
      return outputFile.readAsString();
    }
    return result.stdout.toString();
  }
}
