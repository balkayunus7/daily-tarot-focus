import 'package:daily_tarot_focus/core/widgets/tarot_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

Future<void> displayDeleteAccountPopup(BuildContext context) async {
  final confirmed = await TarotConfirmDialog.show(
    context,
    title: context.tr('delete_account_popup.title'),
    body: context.tr('delete_account_popup.desc'),
    cancelText: context.tr('popup.cancel_button'),
    confirmText: context.tr('delete_account_popup.delete_button'),
    confirmColor: context.colors.error,
  );
  if ((confirmed ?? false) && context.mounted) {
    await context.read<AuthCubit>().deleteUser();
  }
}
