import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/popups/core_popup.dart';

Future<dynamic> displayDeleteAccountPopup(BuildContext context) {
  return CorePopup.displayPopup(
    context,
    title: context.tr('delete_account_popup.title'),
    descriptions: [
      context.tr('delete_account_popup.desc'),
    ],
    routeName: 'delete_account_popup',
    popupButtonDataList: (ctx) {
      return [
        PopupButtonData.cancel(ctx),
        PopupButtonData(
          title: context.tr('delete_account_popup.delete_button'),
          textColor: ctx.colors.error,
          onTap: () async {
            await ctx.read<TarotBloc>().clearCache();
            if (!context.mounted) return;
            await ctx.read<AuthCubit>().deleteUser();
          },
        ),
      ];
    },
  );
}
