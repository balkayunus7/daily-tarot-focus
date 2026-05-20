import 'dart:math' as math;

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_daily_pick_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class DailyPickDetailTop extends StatelessWidget {
  const DailyPickDetailTop({
    required this.tarot,
    required this.isReversed,
    required this.date,
    super.key,
  });

  final TarotCardModel tarot;
  final bool isReversed;
  final DateTime date;

  String _formattedDate(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('d MMMM, EEEE', locale).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final keywords = isReversed ? tarot.reversedKeywords : tarot.uprightKeywords;

    return Column(
      children: [
        Padding(
          padding: Sp.medium.padXR,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (tarot.correspondences.astrology.isNotEmpty)
                        DailyPickLineLabel(
                          title: LocaleKeys.tarot_detail_astrology.tr(),
                          value: tarot.correspondences.astrology,
                          isLeft: true,
                        ),
                      if (tarot.correspondences.element.isNotEmpty)
                        DailyPickLineLabel(
                          title: LocaleKeys.tarot_detail_element.tr(),
                          value: tarot.correspondences.element,
                          isLeft: true,
                        ),
                      if (tarot.correspondences.yesOrNo.isNotEmpty)
                        DailyPickLineLabel(
                          title: LocaleKeys.tarot_detail_yes_no.tr(),
                          value: tarot.correspondences.yesOrNo,
                          isLeft: true,
                        ),
                    ],
                  ),
                ),
                Sp.xsmall.widthBox,
                Expanded(
                  flex: 3,
                  child: Hero(
                    tag: TarotMockData.dailyTarotCardHeroTag,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: Sp.medium.radiusR,
                        border: Border.all(color: colors.secondary),
                      ),
                      child: ClipRRect(
                        borderRadius: Sp.medium.radiusR,
                        child: Transform.rotate(
                          angle: isReversed ? math.pi : 0,
                          child: CustomCacheNetworkImage(
                            imageUrl: tarot.imageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Sp.xsmall.widthBox,
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: tarot.symbols.take(4).map((symbol) {
                      return DailyPickLineLabel(
                        title: symbol.title,
                        value: symbol.meaning,
                        isLeft: false,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Sp.xlarge.heightBox,
        Padding(
          padding: Sp.xlarge.padXR,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DailyPickKeywordsWrap(keywords: keywords),
              Sp.large.heightBox,
              Center(
                child: Text(
                  tarot.category.localizedName.toUpperCase(),
                  style: m10w600(context).copyWith(
                    color: colors.secondary,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Sp.small.heightBox,
              Text(
                tarot.name,
                textAlign: TextAlign.center,
                style: m38w400(context).copyWith(color: colors.textPrimary),
              ),
              Sp.small.heightBox,
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: Sp.xsmall.w,
                  runSpacing: Sp.xsmall.h,
                  children: [
                    DailyPickHeaderPill(
                      text: _formattedDate(context),
                      icon: Icons.calendar_today_rounded,
                      color: colors.primary,
                    ),
                    DailyPickHeaderPill(
                      text: (isReversed
                              ? LocaleKeys.daily_pick_page_reversed
                              : LocaleKeys.daily_pick_page_upright)
                          .tr(),
                      icon: isReversed ? Icons.south_rounded : Icons.north_rounded,
                      color: isReversed ? colors.error : colors.success,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DailyPickKeywordsWrap extends StatelessWidget {
  const DailyPickKeywordsWrap({required this.keywords, super.key});
  final List<String> keywords;

  @override
  Widget build(BuildContext context) {
    if (keywords.isEmpty) return const SizedBox.shrink();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 3,
      children: keywords.map((keyword) {
        return FancyContainer(
          padding: Sp.small.padSymR(h: Sp.small, v: Sp.tiny),
          color: context.colors.primary.withValues(alpha: 0.6),
          child: Text(
            keyword,
            style: m10w500(context).copyWith(color: context.colors.textOnPrimary),
          ),
        );
      }).toList(),
    );
  }
}

class DailyPickLineLabel extends StatelessWidget {
  const DailyPickLineLabel({
    required this.title,
    required this.value,
    required this.isLeft,
    super.key,
  });

  final String title;
  final String value;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    final line = Container(
      width: 15,
      height: 1,
      color: context.colors.primary.withValues(alpha: 0.5),
    );
    final gap = Sp.tiny.widthBox;
    final textColumn = Expanded(
      child: Column(
        crossAxisAlignment: isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(title.toUpperCase(), style: m9w700(context)),
          ),
          2.heightBox,
          Text(
            value,
            style: m8w400(context).copyWith(color: context.colors.textSecondary),
            textAlign: isLeft ? TextAlign.right : TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    return Padding(
      padding: Sp.tiny.padYR,
      child: Row(
        children: isLeft ? [textColumn, gap, line] : [line, gap, textColumn],
      ),
    );
  }
}

class DailyPickHeaderPill extends StatelessWidget {
  const DailyPickHeaderPill({
    required this.text,
    required this.icon,
    required this.color,
    super.key,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sp.small.w, vertical: Sp.xsmall.h),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          Sp.tiny.widthBox,
          Text(
            text,
            style: m11w500(context).copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class DailyPickAdviceCard extends StatelessWidget {
  const DailyPickAdviceCard({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text('✨', style: m16w700(context)),
          ),
          Sp.small.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.daily_pick_page_daily_advice.tr(),
                  style: m14w700(context),
                ),
                Sp.xsmall.heightBox,
                Text(
                  text,
                  style: m13w500(context).copyWith(
                    color: colors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DailyPickCategoryTile extends StatelessWidget {
  const DailyPickCategoryTile({required this.category, super.key});
  final DailyPickCategoryInsight category;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(category.emoji, style: m16w700(context)),
          ),
          Sp.small.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.labelKey.tr(), style: m14w700(context)),
                Sp.xsmall.heightBox,
                Text(
                  category.description,
                  style: m13w400(context).copyWith(
                    color: colors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
