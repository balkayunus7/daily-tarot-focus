import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class SpreadCategoryCard extends StatelessWidget {
  const SpreadCategoryCard({required this.categoryData, required this.onTap, super.key});
  final TarotSpreadCategoryModel categoryData;
  final VoidCallback onTap;

  String get svgCategoryPath {
    switch (categoryData.id) {
      case 'cat_3_cards':
        return TarotAppAssets.cardsThree.path;
      case 'cat_career':
        return TarotAppAssets.chartLine.path;
      case 'cat_finance':
        return TarotAppAssets.handCoins.path;
      case 'cat_health':
        return TarotAppAssets.asclepius.path;
      case 'cat_moon_week':
        return TarotAppAssets.moonStars.path;
      case 'cat_relationship':
        return TarotAppAssets.heartHalf.path;
      default:
        return TarotAppAssets.cardsThree.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: onTap,
      child: FancyContainer(
        padding: Sp.small.padSymR(h: Sp.large, v: Sp.small),
        color: colors.primary.withValues(alpha: 0.05),
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
                svgCategoryPath,
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
                  Text(categoryData.title, style: m15w600(context)),
                  ...[
                    2.heightBox,
                    Text(
                      LocaleKeys.tarot_question_spreads_count.tr(
                        args: [categoryData.spreads.size.toString()],
                      ),
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
