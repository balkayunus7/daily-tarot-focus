import 'dart:async';
import 'dart:math';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/numerology/domain/numerology_calculator.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/numerology/domain/numerology_navigation_args.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/numerology/domain/numerology_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/numerology_result_header.dart';
part '../widgets/numerology_number_card.dart';
part '../widgets/numerology_info_sheet.dart';

class NumerologyResultPage extends StatelessWidget {
  const NumerologyResultPage({
    required this.birthDate,
    required this.fullName,
    this.isTemporary = false,
    super.key,
  });

  final DateTime birthDate;
  final String fullName;
  final bool isTemporary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final result = NumerologyCalculator.compute(birthDate, fullName);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TarotAppBar(
              title: LocaleKeys.numerology_page_title.tr(),
              titleStyle: m18w700(context),
              trailingIcon2: Icons.restart_alt,
              onIcon2Tap:
                  () => context.pushReplacement(
                    AppRoutes.numerologyInput,
                    extra: const NumerologyInputArgs(
                      prefillUserData: false,
                    ),
                  ),
              trailingIcon: Icons.question_mark,
              onIconTap: () => _showNumerologyInfoSheet(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  Sp.screen.w,
                  Sp.large.h,
                  Sp.screen.w,
                  Sp.xxxlarge.h + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NumerologyResultHeader(result: result),
                    Sp.xlarge.heightBox,

                    // Group 1: birth date numbers (birthday already shown as card below header)
                    NumerologyNumberCard(
                      number: result.birthday,
                      sectionLabel:
                          LocaleKeys.numerology_page_section_birthday.tr(),
                      sectionIntro:
                          LocaleKeys.numerology_page_section_birthday_intro
                              .tr(),
                    ),
                    Sp.xlarge.heightBox,

                    // Group 2: name-based numbers
                    _SectionGroupLabel(
                      label: LocaleKeys.numerology_page_section_group_name.tr(),
                    ),
                    Sp.medium.heightBox,
                    NumerologyNumberCard(
                      number: result.destiny,
                      sectionLabel:
                          LocaleKeys.numerology_page_section_destiny.tr(),
                      sectionIntro:
                          LocaleKeys.numerology_page_section_destiny_intro.tr(),
                    ),
                    Sp.medium.heightBox,
                    NumerologyNumberCard(
                      number: result.soulUrge,
                      sectionLabel:
                          LocaleKeys.numerology_page_section_soul_urge.tr(),
                      sectionIntro:
                          LocaleKeys.numerology_page_section_soul_urge_intro
                              .tr(),
                    ),
                    Sp.medium.heightBox,
                    NumerologyNumberCard(
                      number: result.personality,
                      sectionLabel:
                          LocaleKeys.numerology_page_section_personality.tr(),
                      sectionIntro:
                          LocaleKeys.numerology_page_section_personality_intro
                              .tr(),
                    ),
                    Sp.xlarge.heightBox,

                    // Group 3: combined
                    _SectionGroupLabel(
                      label:
                          LocaleKeys.numerology_page_section_group_combined
                              .tr(),
                    ),
                    Sp.medium.heightBox,
                    NumerologyNumberCard(
                      number: result.maturity,
                      sectionLabel:
                          LocaleKeys.numerology_page_section_maturity.tr(),
                      sectionIntro:
                          LocaleKeys.numerology_page_section_maturity_intro
                              .tr(),
                    ),
                    Sp.large.heightBox,

                    Text(
                      LocaleKeys.numerology_page_footer_note.tr(),
                      style: m11w500(context).copyWith(
                        color: colors.textSecondary.withValues(alpha: 0.75),
                        height: 1.55,
                      ),
                      textAlign: TextAlign.center,
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

class _SectionGroupLabel extends StatelessWidget {
  const _SectionGroupLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: colors.border)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Sp.medium.w),
          child: Text(
            label,
            style: m11w500(context).copyWith(
              color: colors.textSecondary.withValues(alpha: 0.7),
              letterSpacing: 1.4,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: colors.border)),
      ],
    );
  }
}
