import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/default_toast.dart';

extension TarotToastExt on BuildContext {
  void showToastMessage(String message) {
    Toast.show(
      message,
      this,
      duration: 3,
      gravity: Toast.BOTTOM,
      backgroundRadius: 12,
      backgroundColor: colors.surface,
      textColor: colors.textPrimary,
      border: Border.all(color: colors.primary),
    );
  }
}
