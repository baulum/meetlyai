import 'package:flutter/material.dart';

import '../domain/models/meeting_models.dart';

/// Shared color tokens for the dark desktop UI.
class AppColors {
  const AppColors._();

  static const background = Color(0xFF0D0F12);
  static const sidebar = Color(0xFF101318);
  static const surface = Color(0xFF15191F);
  static const surfaceHigh = Color(0xFF1D2229);
  static const inset = Color(0xFF111419);
  static const border = Color(0xFF252B33);
  static const borderStrong = Color(0xFF2B333D);

  static const text = Color(0xFFE7EAEE);
  static const textMuted = Color(0xFF9AA4B2);
  static const textSubtle = Color(0xFFB8C0CC);

  static const accent = Color(0xFF6EE7B7);
  static const recording = Color(0xFFFF6B6B);
  static const paused = Color(0xFFFFD166);

  /// Your own voice, captured from the microphone.
  static const mic = Color(0xFF6EE7B7);

  /// Everyone else, captured from the computer's audio output.
  static const system = Color(0xFF8AB4F8);

  static const mixed = Color(0xFFB794F4);
}

/// How an audio source is presented throughout the UI.
class AudioSourceStyle {
  const AudioSourceStyle({
    required this.label,
    required this.shortLabel,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String label;
  final String shortLabel;
  final String description;
  final IconData icon;
  final Color color;

  static AudioSourceStyle of(AudioSourceKind source) => switch (source) {
    AudioSourceKind.mic => const AudioSourceStyle(
      label: 'Microphone',
      shortLabel: 'Mic',
      description: 'Your voice',
      icon: Icons.mic_none_rounded,
      color: AppColors.mic,
    ),
    AudioSourceKind.system => const AudioSourceStyle(
      label: 'System audio',
      shortLabel: 'System',
      description: 'Call participants and other apps',
      icon: Icons.volume_up_outlined,
      color: AppColors.system,
    ),
    AudioSourceKind.mixed => const AudioSourceStyle(
      label: 'Mixed audio',
      shortLabel: 'Mixed',
      description: 'Microphone and system combined',
      icon: Icons.graphic_eq,
      color: AppColors.mixed,
    ),
  };
}
