import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class SpreadCategoryCard extends StatelessWidget {
  const SpreadCategoryCard({
    required this.icon,
    required this.onTap,
    required this.title,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final TarotAppAssets icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: onTap,
      child: Container(
        padding: Sp.screen.padAllR,
        decoration: BoxDecoration(
          color: colors.secondary.withValues(alpha: 0.05),
          borderRadius: Sp.medium.radiusR,
        ),
        child: Row(
          children: [
            Container(
              padding: Sp.tiny.padAllR,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                icon.path,
                colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
                width: 20,
                height: 20,
              ),
            ),
            Sp.medium.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: m14w600(context).copyWith(color: colors.textPrimary),
                  ),
                  if (subtitle != null) ...[
                    Sp.tiny.heightBox,
                    Text(
                      subtitle!,
                      style: m12w500(context).copyWith(
                        color: colors.textSecondary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
