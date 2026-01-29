import 'package:daily_tarot_focus/application/auth/register_cubit.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../mixins/birthday_mixin.dart';
part '../widgets/birthday_circle.dart';

class RegisterStepBirthdatePage extends StatefulWidget {
  const RegisterStepBirthdatePage({super.key});

  @override
  State<RegisterStepBirthdatePage> createState() => _RegisterStepBirthdatePageState();
}

class _RegisterStepBirthdatePageState extends State<RegisterStepBirthdatePage> with BirthdayMixin {
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
            context.go(AppRoutes.tarotExplore);
          } else if (state.registerStatus.isFailure) {
            showErrorSnackBar(context);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: Spacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.registerStep3Of3.tr(),
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacing.xsmallH,
                Text(
                  LocaleKeys.registerBirthdateTitle.tr(),
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacing.xsmallH,
                Text(
                  LocaleKeys.registerBirthdateSubtitle.tr(),
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacing.smallH,
                LinearProgressIndicator(
                  value: 1,
                  backgroundColor: colors.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                ),
                Spacing.hugeH,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BirthDayCircle(
                      selectedDate: _selectedDate,
                      selectDate: () => _selectDate(context),
                    ),
                    Spacing.xxlargeH,
                    if (isSelected) ...[
                      Text(
                        _selectedDate!.ageText(context),
                        style: m20w600(
                          context,
                        ).copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ],
                ),
                const Spacer(),
                BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return TarotButton(
                      buttonText: LocaleKeys.registerCompleteRegistration.tr(),
                      onTap: () async {
                        final authState = context.read<AuthCubit>().state;
                        await context.read<RegisterCubit>().submitRegistration(
                          authState.sessionOrCrash,
                        );
                      },
                      buttonTextStyle: m16w700(context),
                      isLoading: state.registerStatus.isLoading,
                      isDisabled: !state.isBirthDateSelected,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
