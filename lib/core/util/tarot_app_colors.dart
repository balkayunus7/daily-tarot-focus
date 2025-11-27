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
          background: const Color(0xFF15171E),
          border: const Color(0xFFE6C265).withValues(alpha: 0.15),
          primary: const Color(0xFFE6C265),
          secondary: const Color(0xFF3D64F0),
          surface: const Color(0xFF1E2029),
          textPrimary: const Color(0xFFFFFFFF),
          surfaceSecondary: const Color(0xFFE6C265).withValues(alpha: 0.15),
          textSecondary: const Color(0xFFAAB2C0),
          borderSecondary: const Color(0xFF404040),
          accent: const Color(0xFF15171E).withValues(alpha: 0.2),
        );
  }

  class TarotAppColorsLight extends TarotAppColors implements AppColorsLight {
    TarotAppColorsLight()
      : super(
          background: const Color(0xFFFAF8F2),
          border: const Color(0xFF15171E).withValues(alpha: 0.1),
          primary: const Color(0xFF2B4BC6),
          secondary: const Color(0xFFD4AF37),
          surface: const Color(0xFFFFFFFF),
          textPrimary: const Color(0xFF15171E),
          surfaceSecondary: const Color(0xFFE6C265).withValues(alpha: 0.15),
          textSecondary: const Color(0xFF666666),
          borderSecondary: const Color(0xFFD1D1D1),
          accent: const Color(0xFF15171E).withValues(alpha: 0.2),
        );
  }
