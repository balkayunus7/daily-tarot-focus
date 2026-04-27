import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/spread_layout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/presentation/bottom_sheets/core_bottom_sheet.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

Future<void> showSpreadDetailsBottomSheet(
  BuildContext context,
  TarotSpreadModel spread,
  VoidCallback onTap,
) async {
  await showCoreBottomSheet(
    context,
    buildWidget: (ctx) {
      final positions = [...spread.positions.asList()]..sort((a, b) => a.index.compareTo(b.index));

      return SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(ctx).height * 0.7,
          child: Padding(
            padding: Sp.medium.padHR,
            child: Column(
              children: [
                Text(
                  spread.title,
                  style: m24w600(context),
                ),
                Sp.xsmall.heightBox,
                Text(
                  '${spread.cardCount}-Card Guided Journey',
                  style: m11w500(context).copyWith(color: context.colors.textTertiary),
                  textAlign: TextAlign.center,
                ),
                Sp.large.heightBox,
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(0, 4.h, 20.w, 16.h),
                    child: Column(
                      children: [
                        Center(
                          child: SpreadLayoutPreview(
                            positions: positions,
                            showIndex: true,
                            cardWidth: 36.w,
                            cardHeight: 54.w,
                            spacing: 8.w,
                          ),
                        ),
                        Sp.xxlarge.heightBox,
                        Stack(
                          children: [
                            Positioned(
                              left: 11.w,
                              top: 16.h,
                              bottom: 16.h,
                              child: Container(
                                width: 1.5,
                                color: ctx.colors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            Column(
                              children: List.generate(positions.length, (i) {
                                final pos = positions[i];
                                final isFirst = i == 0;
                                final isLast = i == positions.length - 1;

                                return Padding(
                                  padding: EdgeInsets.only(bottom: isLast ? 0 : Sp.small.r),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24.w,
                                        child: Center(
                                          child: Container(
                                            width: isFirst ? 14.w : 12.w,
                                            height: isFirst ? 14.w : 12.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  isFirst
                                                      ? ctx.colors.primary
                                                      : ctx.colors.navBackground,
                                              border: Border.all(
                                                color: ctx.colors.primary.withValues(alpha: 0.4),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Sp.medium.widthBox,
                                      Expanded(
                                        child: _SpreadPositionCard(
                                          position: pos,
                                          isFirst: isFirst,
                                          primaryColor: ctx.colors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        Sp.xxlarge.heightBox,
                      ],
                    ),
                  ),
                ),
                FancyButton(
                  onTap: onTap,
                  padding: Sp.large.padXR,
                  text: 'Tap to Draw Cards',
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _SpreadPositionCard extends StatelessWidget {
  const _SpreadPositionCard({
    required this.position,
    required this.isFirst,
    required this.primaryColor,
  });

  final TarotSpreadPositionModel position;
  final bool isFirst;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Sp.small.padSymR(h: Sp.medium, v: Sp.small),
      decoration: BoxDecoration(
        color: context.colors.navBackground,
        borderRadius: Sp.medium.radiusR,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            position.title,
            style: m15w700(context).copyWith(color: context.colors.secondary),
          ),
          Sp.xsmall.heightBox,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Card ${position.index}:  ',
                style: m11w500(context).copyWith(color: primaryColor),
              ),
              Expanded(
                child: Text(
                  position.question,
                  style: m11w400(context).copyWith(color: context.colors.textTertiary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
