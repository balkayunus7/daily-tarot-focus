import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/spacing.dart';

/// Premium abonelik ayrıcalıklarını listeleyen widget.
class TarotPaywallPrivileges extends StatelessWidget {
  const TarotPaywallPrivileges({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PrivilegeRow(
          icon: Icons.all_inclusive,
          label: LocaleKeys.paywallUnlimitedReadings.tr(),
        ),
        const SizedBox(height: Spacing.small),
        _PrivilegeRow(
          icon: Icons.question_answer_rounded,
          label: LocaleKeys.paywallUnlimitedQuestions.tr(),
        ),
        const SizedBox(height: Spacing.small),
        _PrivilegeRow(
          icon: Icons.block,
          label: LocaleKeys.paywallNoAds.tr(),
        ),
      ],
    );
  }
}

class _PrivilegeRow extends StatelessWidget {
  const _PrivilegeRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: colors.primary, size: 18),
        ),
        const SizedBox(width: Spacing.small),
        Expanded(
          child: Text(label, style: m16w500(context)),
        ),
        Icon(Icons.check_circle_rounded, color: colors.primary, size: 20),
      ],
    );
  }
}
