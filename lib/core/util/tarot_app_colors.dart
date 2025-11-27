import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/app_colors.dart';

abstract class TarotAppColors extends AppColors {
  const TarotAppColors({
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

class TarotAppColorsDark extends TarotAppColors implements AppColorsDark {
  TarotAppColorsDark()
    : super(
        background: const Color(0xFF121212),
        border: const Color(0xFF121212).withValues(alpha: 0.1),
        primary: const Color(0xFFE12457),
        secondary: const Color(0xFF00A6C3).withValues(alpha: 0.08),
        surface: Colors.white10,
        textPrimary: const Color(0xFFFFFFFF),
        surfaceSecondary: const Color(0xFF00A6C3).withValues(alpha: 0.08),
        textSecondary: const Color(0xFF5C5C5C),
        borderSecondary: const Color(0xFFA3A3A3),
        accent: const Color(0xFFA2ABBA),
      );
}

class TarotAppColorsLight extends TarotAppColors implements AppColorsLight {
  TarotAppColorsLight()
    : super(
        background: const Color(0xFF121212),
        border: const Color(0xFF121212).withValues(alpha: 0.1),
        primary: const Color(0xFFE12457),
        secondary: const Color(0xFF00A6C3).withValues(alpha: 0.08),
        surface: Colors.white10,
        textPrimary: const Color(0xFFFFFFFF),
        surfaceSecondary: const Color(0xFF00A6C3).withValues(alpha: 0.08),
        textSecondary: const Color(0xFF5C5C5C),
        borderSecondary: const Color(0xFFA3A3A3),
        accent: const Color(0xFFA2ABBA),
      );
}
