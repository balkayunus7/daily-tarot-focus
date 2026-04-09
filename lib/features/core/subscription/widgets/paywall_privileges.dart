import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/app_text_styles.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotPaywallPrivileges extends StatelessWidget {
  const TarotPaywallPrivileges({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PrivilegeCard(
          icon: Icons.all_inclusive,
          label: LocaleKeys.paywall_unlimited_readings.tr(),
        ),
        Spacing.smallW,
        _PrivilegeCard(
          icon: Icons.question_answer_rounded,
          label: LocaleKeys.paywall_limited_question.tr(),
        ),
        Spacing.smallW,
        _PrivilegeCard(
          icon: Icons.block,
          label: LocaleKeys.paywall_no_ads.tr(),
        ),
      ],
    );
  }
}

class _PrivilegeCard extends StatelessWidget {
  const _PrivilegeCard({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Container(
        height: 110,
        padding: const EdgeInsets.symmetric(horizontal: SpacingConsts.xsmall),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: Spacing.defaultBorderRadius,
          border: Border.all(color: colors.primary, width: 0.3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colors.primary, size: 24),
            Spacing.smallH,
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall(context).copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
