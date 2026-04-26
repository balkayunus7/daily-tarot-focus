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
    required super.textDisabled,
    required super.textOnPrimary,
    required super.textOnSecondary,
    required super.buttonPrimary,
    required super.buttonSecondary,
    required super.buttonGhost,
    required super.buttonDisabled,
    required super.inputBorderDefault,
    required super.inputBorderFocus,
    required super.inputDisabled,
    required super.navBackground,
    required super.navIconActive,
    required super.navIconInactive,
    required super.navIndicator,
    required super.overlay,
    required super.error,
    required super.errorSurface,
    required super.success,
    required super.successSurface,
    required super.warning,
    required super.warningSurface,
    required super.gradientStart,
    required super.gradientEnd,
    required super.buttonOnGradient,
    required super.buttonOnGradientText,
  });
}

class TarotAppColorsDark extends AppColorsDark {
  TarotAppColorsDark()
    : super(
        // ── Backgrounds ──────────────────────────────────────────
        background: const Color(0xFFFDF8F0), // Warm cream (Neutral)
        surface: const Color(0xFFFFFFFF), // Pure white cards
        surfaceSecondary: const Color(0xFFF2EEF9), // Very light purple tint
        overlay: const Color(0xFF1A1B2E).withValues(alpha: 0.55),

        // ── Brand ────────────────────────────────────────────────
        primary: const Color(0xFF9086DA), // Medium purple (seed)
        secondary: const Color(0xFF1A237E), // Deep navy
        accent: const Color(0xFFE1D9F1), // Soft lavender (tertiary)
        // ── Borders ──────────────────────────────────────────────
        border: const Color(0xFF9086DA).withValues(alpha: 0.15), // default/tertiary
        borderSecondary: const Color(0xFF9086DA).withValues(alpha: 0.30), // secondary/hover
        // ── Text ─────────────────────────────────────────────────
        textPrimary: const Color(0xFF1A1B2E), // Near-black, purple-tinted
        textSecondary: const Color(0xFF5B5880), // Mid purple-gray
        textDisabled: const Color(0xFFB8B5D0), // Muted lavender-gray
        textOnPrimary: const Color(0xFFFFFFFF), // White on purple button
        textOnSecondary: const Color(0xFFFFFFFF), // White on navy
        // ── Buttons ──────────────────────────────────────────────
        buttonPrimary: const Color(0xFF9086DA), // Enabled fill
        buttonSecondary: const Color(0xFF9086DA).withValues(alpha: 0.12), // Ghost fill
        buttonGhost: Colors.transparent,
        buttonDisabled: const Color(0xFFD8D5ED), // Desaturated lavender
        // ── Inputs ───────────────────────────────────────────────
        inputBorderDefault: const Color(0xFF9086DA).withValues(alpha: 0.25),
        inputBorderFocus: const Color(0xFF9086DA),
        inputDisabled: const Color(0xFFF2EEF9),

        // ── Navigation ───────────────────────────────────────────
        navBackground: const Color(0xFFFFFFFF),
        navIconActive: const Color(0xFF9086DA),
        navIconInactive: const Color(0xFFB8B5D0),
        navIndicator: const Color(0xFF9086DA),

        // ── Gradients ────────────────────────────────────────────
        gradientStart: const Color(0xFF1A237E), // Secondary navy — koyu başlangıç
        gradientEnd: const Color(0xFF9086DA),
        buttonOnGradient: const Color(0xFFFFFFFF).withValues(alpha: 0.20),
        buttonOnGradientText: const Color(0xFFFFFFFF),

        // ── Semantic ─────────────────────────────────────────────
        error: const Color(0xFFD64F4F),
        errorSurface: const Color(0xFFFDEAEA),
        success: const Color(0xFF2E8A57),
        successSurface: const Color(0xFFE6F4EC),
        warning: const Color(0xFFC68B1A),
        warningSurface: const Color(0xFFFEF5E4),
      );
}

class TarotAppColorsLight extends AppColorsLight {
  TarotAppColorsLight()
    : super(
        // ── Backgrounds ──────────────────────────────────────────
        background: const Color(0xFFFDF8F0), // Warm cream (Neutral)
        surface: const Color(0xFFFFFFFF), // Pure white cards
        surfaceSecondary: const Color(0xFFF2EEF9), // Very light purple tint
        overlay: const Color(0xFF1A1B2E).withValues(alpha: 0.55),

        // ── Brand ────────────────────────────────────────────────
        primary: const Color(0xFF9086DA), // Medium purple (seed)
        secondary: const Color(0xFF1A237E), // Deep navy
        accent: const Color(0xFFE1D9F1), // Soft lavender (tertiary)
        // ── Borders ──────────────────────────────────────────────
        border: const Color(0xFF9086DA).withValues(alpha: 0.15), // default/tertiary
        borderSecondary: const Color(0xFF9086DA).withValues(alpha: 0.30), // secondary/hover
        // ── Text ─────────────────────────────────────────────────
        textPrimary: const Color(0xFF1A1B2E), // Near-black, purple-tinted
        textSecondary: const Color(0xFF5B5880), // Mid purple-gray
        textDisabled: const Color(0xFFB8B5D0), // Muted lavender-gray
        textOnPrimary: const Color(0xFFFFFFFF), // White on purple button
        textOnSecondary: const Color(0xFFFFFFFF), // White on navy
        // ── Buttons ──────────────────────────────────────────────
        buttonPrimary: const Color(0xFF9086DA), // Enabled fill
        buttonSecondary: const Color(0xFF9086DA).withValues(alpha: 0.12), // Ghost fill
        buttonGhost: Colors.transparent,
        buttonDisabled: const Color(0xFFD8D5ED), // Desaturated lavender
        // ── Inputs ───────────────────────────────────────────────
        inputBorderDefault: const Color(0xFF9086DA).withValues(alpha: 0.25),
        inputBorderFocus: const Color(0xFF9086DA),
        inputDisabled: const Color(0xFFF2EEF9),

        // ── Navigation ───────────────────────────────────────────
        navBackground: const Color(0xFFFFFFFF),
        navIconActive: const Color(0xFF9086DA),
        navIconInactive: const Color(0xFFB8B5D0),
        navIndicator: const Color(0xFF9086DA),

        // ── Gradients ────────────────────────────────────────────
        gradientStart: const Color(0xFF1A237E), // Secondary navy — koyu başlangıç
        gradientEnd: const Color.fromARGB(255, 154, 146, 217),
        buttonOnGradient: const Color(0xFFFFFFFF).withValues(alpha: 0.20),
        buttonOnGradientText: const Color(0xFFFFFFFF),

        // ── Semantic ─────────────────────────────────────────────
        error: const Color(0xFFD64F4F),
        errorSurface: const Color(0xFFFDEAEA),
        success: const Color(0xFF2E8A57),
        successSurface: const Color(0xFFE6F4EC),
        warning: const Color(0xFFC68B1A),
        warningSurface: const Color(0xFFFEF5E4),
      );
}
