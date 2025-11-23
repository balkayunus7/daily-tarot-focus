import 'package:daily_tarot_focus/presentation/core/helper/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobile_core/presentation/extensions/build_context_theme_ext.dart';

void showErrorSnackBar(BuildContext context, {required String? errorMessage}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        errorMessage ?? '',
        style: n14w500(context).copyWith(color: context.colors.surface),
      ),
      backgroundColor: context.colors.primary,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showSuccessSnackBar(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: n14w500(context).copyWith(color: context.colors.surface),
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
