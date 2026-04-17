import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/glass_container.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_spread_category_model.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class SpreadLayoutCard extends StatelessWidget {
  const SpreadLayoutCard({required this.spread, required this.onTap, super.key});
  final TarotSpreadModel spread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: onTap,
      child: GlassContainer(
        padding: Sp.screen.padAllR,
        borderRadius: Sp.medium,
        glassColor: colors.primary.withValues(alpha: 0.05),
        borderColor: colors.primary.withValues(alpha: 0.05),
        child: Row(
          children: [
            SizedBox(
              width: 52.w,
              height: 52.h,
              child: Center(
                child: _LayoutPreview(cardCount: spread.cardCount),
              ),
            ),
            Sp.large.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    spread.title,
                    style: m16w700(context).copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Sp.tiny.heightBox,
                  Text(
                    spread.description,
                    style: m12w400(context).copyWith(
                      color: colors.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Sp.small.widthBox,
          ],
        ),
      ),
    );
  }
}

class _LayoutPreview extends StatelessWidget {
  const _LayoutPreview({required this.cardCount});
  final int cardCount;

  @override
  Widget build(BuildContext context) {
    final cardWidth = cardCount > 6 ? 4.0 : 14.0;
    final cardHeight = cardCount > 6 ? 8.0 : 24.0;
    final spacing = cardCount > 6 ? 2.0 : 4.0;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: List.generate(cardCount, (index) {
        return Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.8),
            borderRadius: 1.5.radiusR,
            boxShadow: [
              BoxShadow(
                color: context.colors.primary.withValues(alpha: 0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        );
      }),
    );
  }
}
