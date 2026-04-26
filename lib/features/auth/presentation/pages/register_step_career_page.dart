import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/snackbar_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/features/auth/bloc/register_cubit.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_career_enum.dart';
import 'package:daily_tarot_focus/features/auth/presentation/widgets/step_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/career_item.dart';
part '../widgets/career_listview.dart';

class RegisterStepCareerPage extends StatelessWidget {
  const RegisterStepCareerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) async {
          if (state.registerStatus.isSuccess) {
            await context.read<AuthCubit>().refetchUser();
            if (!context.mounted) return;
            context.go(AppRoutes.accountSetup);
          } else if (state.registerStatus.isFailure) {
            SnackbarHelper.showError(
              context,
              errorMessage: LocaleKeys.failure_unexpected_message.tr(),
            );
          }
        },
        child: Stack(
          children: [
            const StepBackground(),
            SafeArea(
              child: Padding(
                padding: Sp.screen.padAllR,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.register_page_step_3_of_3.tr(),
                      style: m14w700(context).copyWith(color: colors.textSecondary),
                    ),
                    Sp.xsmall.heightBox,
                    Text(
                      LocaleKeys.register_page_career_title.tr(),
                      style: m32w600(context),
                    ),
                    Sp.xsmall.heightBox,
                    Text(
                      LocaleKeys.register_page_career_subtitle.tr(),
                      style: m14w500(context).copyWith(color: colors.textSecondary),
                    ),
                    Sp.small.heightBox,
                    LinearProgressIndicator(
                      value: 1,
                      minHeight: 6,
                      borderRadius: Sp.medium.radiusR,
                      backgroundColor: colors.secondary,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                    ),
                    Sp.xxlarge.heightBox,
                    const Expanded(child: CareerListView()),
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        return FancyButton(
                          text: LocaleKeys.register_page_complete_registration.tr(),
                          onTap: () async {
                            final authState = context.read<AuthCubit>().state;
                            await context.read<RegisterCubit>().submitRegistration(
                              authState.sessionOrCrash,
                            );
                          },
                          isLoading: state.registerStatus.isLoading,
                          isDisabled: !state.isCareerStatusSelected,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
