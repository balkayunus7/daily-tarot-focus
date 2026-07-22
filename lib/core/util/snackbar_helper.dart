import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class SnackbarHelper {
  SnackbarHelper._();

  static void showError(BuildContext context, {required String? errorMessage}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage ?? '',
          style: m14w500(context).copyWith(color: context.colors.surface),
        ),
        backgroundColor: context.colors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccess(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: m14w500(context).copyWith(color: context.colors.surface),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
