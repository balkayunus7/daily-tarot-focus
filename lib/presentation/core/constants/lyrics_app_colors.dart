import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/app_colors.dart';

abstract class LyricsAppColors extends AppColors {
  const LyricsAppColors({
    required super.background,
    required super.border,
    required super.primary,
    required super.secondary,
    required super.surface,
    required super.textPrimary,
    required super.textSecondary,
    required super.surfaceSecondary,
    required super.borderSecondary,
    required super.accent,
  });
}

class LyricsAppColorsDark extends LyricsAppColors implements AppColorsDark {
  LyricsAppColorsDark()
    : super(
        background: Color(0xFF121212),
        border: Color(0xFF121212).withValues(alpha: 0.1),
        primary: Color(0xFFE12457),
        secondary: Color(0xFF00A6C3).withValues(alpha: 0.08),
        surface: Colors.white10,
        textPrimary: Color(0xFFFFFFFF),
        surfaceSecondary: Color(0xFF00A6C3).withValues(alpha: 0.08),
        textSecondary: Color(0xFF5C5C5C),
        borderSecondary: Color(0xFFA3A3A3),
        accent: Color(0xFFA2ABBA),
      );
}

class LyricsAppColorsLight extends LyricsAppColors implements AppColorsLight {
  LyricsAppColorsLight()
    : super(
        background: Color(0xFF121212),
        border: Color(0xFF121212).withValues(alpha: 0.1),
        primary: Color(0xFFE12457),
        secondary: Color(0xFF00A6C3).withValues(alpha: 0.08),
        surface: Colors.white10,
        textPrimary: Color(0xFFFFFFFF),
        surfaceSecondary: Color(0xFF00A6C3).withValues(alpha: 0.08),
        textSecondary: Color(0xFF5C5C5C),
        borderSecondary: Color(0xFFA3A3A3),
        accent: Color(0xFFA2ABBA),
      );
}
