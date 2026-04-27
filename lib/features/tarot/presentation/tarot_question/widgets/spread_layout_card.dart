import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/spread_layout_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      child: FancyContainer(
        padding: Sp.medium.padSymR(h: Sp.medium, v: Sp.small),
        borderRadius: Sp.large,
        color: colors.primary.withValues(alpha: 0.05),
        child: Row(
          children: [
            SpreadLayoutPreview(positions: spread.positions.asList()),
            Sp.xlarge.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Sp.small.heightBox,
                  Text(
                    spread.title,
                    style: m16w700(context).copyWith(color: colors.textPrimary),
                  ),
                  Sp.xsmall.heightBox,
                  Text(
                    spread.description,
                    style: m11w400(context).copyWith(color: colors.textSecondary, height: 1.3),
                  ),
                  Sp.medium.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: colors.accent.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: colors.accent, width: 0.5),
                        ),
                        child: Text(
                          '${spread.cardCount} cards',
                          style: m8w700(context).copyWith(color: colors.primary),
                        ),
                      ),
                      Sp.xsmall.widthBox,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: colors.accent.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: colors.accent, width: 0.5),
                        ),
                        child: Text(
                          spread.layoutType,
                          style: m8w700(context).copyWith(color: colors.primary),
                        ),
                      ),
                      const Spacer(),
                      ScalingContainer(
                        onTap: () async {
                          await showSpreadDetailsBottomSheet(context, spread, onTap);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: colors.accent.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: colors.accent, width: 0.5),
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            size: 14.sp,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpreadLayoutPreview extends StatelessWidget {
  const SpreadLayoutPreview({
    required this.positions,
    this.cardWidth,
    this.cardHeight,
    this.spacing,
    super.key,
    this.showIndex = false,
  });
  final List<TarotSpreadPositionModel> positions;
  final double? cardWidth;
  final double? cardHeight;
  final double? spacing;
  final bool showIndex;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) return const SizedBox.shrink();
    final totalCards = positions.length;

    final w = cardWidth ?? (totalCards > 5 ? 12.0 : 18.0);
    final h = cardHeight ?? (totalCards > 5 ? 20.0 : 28.0);
    final s = spacing ?? (totalCards > 5 ? 5.0 : 4.0);

    final maxRow = positions.map((p) => p.row).reduce((a, b) => a > b ? a : b).ceil();
    final maxCol = positions.map((p) => p.col).reduce((a, b) => a > b ? a : b).ceil();

    final totalWidth = (maxCol + 1) * w + maxCol * s;
    final totalHeight = (maxRow + 1) * h + maxRow * s;

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children:
            positions.map((pos) {
              final tileW = pos.rotation == 90 ? h : w;
              final tileH = pos.rotation == 90 ? w : h;

              // Align center within the logical cell coordinate
              final leftOffset = pos.col * (w + s) + (w - tileW) / 2;
              final topOffset = pos.row * (h + s) + (h - tileH) / 2;

              return Positioned(
                left: leftOffset,
                top: topOffset,
                child: _TarotCardTile(
                  width: tileW,
                  height: tileH,
                  index: showIndex ? pos.index : null,
                ),
              );
            }).toList(),
      ),
    );
  }
}

class _TarotCardTile extends StatelessWidget {
  const _TarotCardTile({
    required this.width,
    required this.height,
    this.index,
  });
  final double width;
  final double height;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: colors.primary, width: 0.2),
      ),
      child:
          index != null
              ? Center(
                child: Text(
                  index.toString(),
                  style: m10w700(context).copyWith(
                    color: colors.primary,
                    fontSize: (width * 0.4).clamp(8.0, 16.0),
                  ),
                ),
              )
              : null,
    );
  }
}
