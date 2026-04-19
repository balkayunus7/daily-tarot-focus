import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class SpreadCategoryCard extends StatelessWidget {
  const SpreadCategoryCard({
    required this.icon,
    required this.onTap,
    required this.title,
    this.subtitle,
    this.isSelected = false,
    super.key,
  });
  final String title;
  final String? subtitle;
  final TarotAppAssets icon;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: onTap,
      child: GlassContainer(
        padding: Sp.small.padSymR(h: Sp.large, v: Sp.small),
        borderRadius: Sp.medium,
        glassColor: colors.primary.withValues(alpha: 0.05),
        borderColor: colors.primary.withValues(alpha: 0.05),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.gradientStart, colors.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: Sp.small.radiusR,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                icon.path,
                colorFilter: ColorFilter.mode(colors.accent, BlendMode.srcIn),
                width: 20.w,
                height: 20.h,
              ),
            ),
            Sp.medium.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: m15w600(context)),
                  if (subtitle != null) ...[
                    2.heightBox,
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
            if (isSelected) ...[
              Sp.medium.widthBox,
              Iconify(Mdi.check_circle, color: colors.primary),
            ],
          ],
        ),
      ),
    );
  }
}
