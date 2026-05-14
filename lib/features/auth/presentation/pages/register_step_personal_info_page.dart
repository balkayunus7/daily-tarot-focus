import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/build_context_toast_ext.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/features/auth/bloc/register_cubit.dart';
import 'package:daily_tarot_focus/features/auth/presentation/helpers/personal_info_mixin.dart';
import 'package:daily_tarot_focus/features/auth/presentation/widgets/personal_info_input_field.dart';
import 'package:daily_tarot_focus/features/auth/presentation/widgets/step_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class RegisterStepPersonalInfoPage extends StatefulWidget {
  const RegisterStepPersonalInfoPage({super.key});

  @override
  State<RegisterStepPersonalInfoPage> createState() => _RegisterStepPersonalInfoPageState();
}

class _RegisterStepPersonalInfoPageState extends State<RegisterStepPersonalInfoPage>
    with PersonalInfoMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (ctx, state) async {
          if (state.registerStatus.isSuccess) {
            final authCubit = ctx.read<AuthCubit>();
            await authCubit.refetchUser();
            if (!ctx.mounted) return;
            ctx.go(AppRoutes.accountSetup);
          } else if (state.registerStatus.isFailure) {
            ctx.showErrorToastMessage(LocaleKeys.failure_unexpected_message.tr());
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
                      LocaleKeys.register_page_name_birth_location_title.tr(),
                      style: m32w600(context),
                    ),
                    Sp.xsmall.heightBox,
                    Text(
                      LocaleKeys.register_page_name_birth_location_subtitle.tr(),
                      style: m14w500(context).copyWith(color: colors.textSecondary),
                    ),
                    Sp.small.heightBox,
                    LinearProgressIndicator(
                      value: 1,
                      minHeight: 6,
                      borderRadius: Sp.medium.radiusR,
                      backgroundColor: colors.accent,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                    ),
                    Sp.xxlarge.heightBox,
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.register_page_name_label.tr(),
                              style: m14w700(context),
                            ),
                            Sp.xsmall.heightBox,
                            ListenableBuilder(
                              listenable: nameController,
                              builder: (context, _) {
                                return PersonalInfoInputField(
                                  controller: nameController,
                                  hint: LocaleKeys.register_page_name_hint.tr(),
                                  onChanged: onNameChanged,
                                );
                              },
                            ),
                            Sp.medium.heightBox,
                            Text(
                              LocaleKeys.register_page_birth_date_label.tr(),
                              style: m14w700(context),
                            ),
                            Sp.xsmall.heightBox,
                            ValueListenableBuilder<DateTime?>(
                              valueListenable: selectedBirthDate,
                              builder: (context, date, _) {
                                return _InfoPickerField(
                                  icon: Icons.calendar_today_rounded,
                                  value: date != null ? formatDate(date) : null,
                                  hint: LocaleKeys.register_page_birth_date_hint.tr(),
                                  onTap: pickDate,
                                );
                              },
                            ),
                            Sp.medium.heightBox,
                            Text(
                              LocaleKeys.register_page_birth_time_label.tr(),
                              style: m14w700(context),
                            ),
                            Sp.xsmall.heightBox,
                            ValueListenableBuilder<TimeOfDay?>(
                              valueListenable: selectedBirthTime,
                              builder: (context, time, _) {
                                return _InfoPickerField(
                                  icon: Icons.access_time_rounded,
                                  value: time?.format(context),
                                  hint: LocaleKeys.register_page_birth_time_hint.tr(),
                                  onTap: pickTime,
                                );
                              },
                            ),
                            Sp.medium.heightBox,
                            Text(
                              LocaleKeys.register_page_location_label.tr(),
                              style: m14w700(context),
                            ),
                            Sp.xsmall.heightBox,
                            ValueListenableBuilder<String?>(
                              valueListenable: selectedCityName,
                              builder: (context, city, _) {
                                return _InfoPickerField(
                                  icon: Icons.location_city_rounded,
                                  value: city,
                                  hint: LocaleKeys.register_page_location_hint.tr(),
                                  onTap: pickCity,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Sp.medium.heightBox,
                    ListenableBuilder(
                      listenable: Listenable.merge([
                        nameController,
                        selectedBirthDate,
                        selectedBirthTime,
                        selectedCityName,
                      ]),
                      builder: (context, _) {
                        return BlocBuilder<RegisterCubit, RegisterState>(
                          builder: (context, state) {
                            return FancyButton(
                              text: LocaleKeys.register_page_complete_registration.tr(),
                              onTap: submitRegistration,
                              isLoading: state.registerStatus.isLoading,
                              isDisabled: !isFormValid,
                            );
                          },
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

class _InfoPickerField extends StatelessWidget {
  const _InfoPickerField({
    required this.icon,
    required this.hint,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final String? value;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: Sp.medium.radiusR,
          border: Border.all(
            color: value != null ? colors.primary : colors.accent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: value != null ? colors.primary : colors.textSecondary,
              size: 18.r,
            ),
            SizedBox(width: 10.w),
            Text(
              value ?? hint,
              style:
                  value != null
                      ? m14w500(context)
                      : m14w500(context).copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
