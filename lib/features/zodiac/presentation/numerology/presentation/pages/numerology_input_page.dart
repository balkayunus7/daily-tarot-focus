import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/numerology/domain/numerology_storage.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/numerology/presentation/helpers/numerology_input_page_mixin.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/numerology/presentation/helpers/numerology_input_page_scope.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/numerology/presentation/widgets/numerology_input_visual.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/numerology_birth_picker.dart';

class NumerologyInputPage extends StatefulWidget {
  const NumerologyInputPage({super.key});

  @override
  State<NumerologyInputPage> createState() => _NumerologyInputPageState();
}

class _NumerologyInputPageState extends State<NumerologyInputPage> with NumerologyInputPageMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final saved = await NumerologyStorage.load();
      if (!mounted || saved == null) return;
      birthDate.value = saved.$1;
      fullNameController.text = saved.$2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return NumerologyInputPageScope(
      state: this,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              TarotAppBar(
                title: LocaleKeys.numerology_page_title.tr(),
                titleStyle: m18w700(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.large.h, Sp.screen.w, Sp.large.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NumerologyInputVisual(),
                      Sp.xlarge.heightBox,
                      Text(
                        LocaleKeys.numerology_page_input_subtitle.tr(),
                        style: m18w700(context),
                        textAlign: TextAlign.center,
                      ),
                      Sp.small.heightBox,
                      Text(
                        LocaleKeys.numerology_page_input_hint.tr(),
                        style: m13w400(context).copyWith(
                          color: colors.textSecondary,
                          height: 1.55,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Sp.xlarge.heightBox,
                      _NameInput(controller: fullNameController),
                      Sp.medium.heightBox,
                      const NumerologyBirthPicker(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Sp.screen.w,
                  Sp.medium.h,
                  Sp.screen.w,
                  Sp.large.h + MediaQuery.of(context).padding.bottom,
                ),
                child: ListenableBuilder(
                  listenable: Listenable.merge([birthDate, fullName]),
                  builder: (context, _) {
                    final canCalculate =
                        birthDate.value != null && fullName.value.trim().isNotEmpty;
                    return FancyButton(
                      width: double.infinity,
                      height: 52.h,
                      text: LocaleKeys.numerology_page_calculate.tr(),
                      isDisabled: !canCalculate,
                      textStyle: m16w700(context).copyWith(color: colors.textOnPrimary),
                      onTap:
                          canCalculate
                              ? () async {
                                final date = birthDate.value!;
                                final name = fullName.value.trim();
                                await NumerologyStorage.save(date, name);
                                if (!context.mounted) return;
                                unawaited(
                                  context.push(
                                    AppRoutes.numerologyResult,
                                    extra: (date, name),
                                  ),
                                );
                              }
                              : () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      width: double.infinity,
      color: colors.textSecondary.withValues(alpha: 0.06),
      border: Border.all(color: colors.border),
      child: TextField(
        controller: controller,
        style: m16w700(context),
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          contentPadding: Sp.medium.padAllR,
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: Sp.medium.w, right: Sp.small.w),
            child: Icon(Icons.person_outline, color: colors.primary, size: 22.sp),
          ),
          prefixIconConstraints: const BoxConstraints(),
          labelText: LocaleKeys.numerology_page_full_name_label.tr(),
          labelStyle: m11w500(context).copyWith(color: colors.textSecondary),
          hintText: LocaleKeys.numerology_page_full_name_hint.tr(),
          hintStyle: m14w500(context).copyWith(
            color: colors.textSecondary.withValues(alpha: 0.6),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
