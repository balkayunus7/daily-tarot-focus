import 'package:flutter/services.dart';

/// Haptic feedback helper class
/// Provides appropriate haptic feedback for different scenarios
class HapticFeedbackHelper {
  /// Light impact for button taps and selections
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact for important actions
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact for critical actions and errors
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection click for list items and tab changes
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Success feedback for successful operations
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
  }

  /// Error feedback for error states
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
  }

  /// Warning feedback for warning states
  static Future<void> warning() async {
    await HapticFeedback.lightImpact();
  }
}
