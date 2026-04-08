import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class SharedTarotDetailPageContent extends StatelessWidget {
  const SharedTarotDetailPageContent({
    required this.tarot,
    this.showMeaningForDay = false,
    super.key,
  });
  final TarotCardModel tarot;
  final bool showMeaningForDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpacingConsts.large),
      child: Column(
        children: [
          Center(
            child: Text(
              tarot.category.value.toUpperCase(),
              style: m12w600(context).copyWith(
                color: context.colors.primary,
                letterSpacing: 2,
              ),
            ),
          ),
          Spacing.largeH,
          _MottoCard(tarot: tarot),
          Spacing.largeH,
          if (showMeaningForDay) ...[
            _AdviceCard(tarot: tarot),
            Spacing.largeH,
          ],
          _ContextualMeaningsGrid(tarot: tarot),
          Spacing.largeH,
          if (showMeaningForDay) ...[
            _AffirmationCard(tarot: tarot),
            Spacing.largeH,
          ],
        ],
      ),
    );
  }
}

class _MottoCard extends StatelessWidget {
  const _MottoCard({required this.tarot});
  final TarotCardModel tarot;

  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      padding: Spacing.defaultPadding,
      borderRadius: Spacing.xlargeBorderRadius,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 3.5;
          final itemHeight = itemWidth * 1.5;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: TarotMockData.dailyTarotCardHeroTag,
                child: Container(
                  width: itemWidth,
                  height: itemHeight,
                  padding: Spacing.tinyPadding,
                  decoration: BoxDecoration(
                    color: context.colors.textPrimary,
                    borderRadius: Spacing.defaultBorderRadius,
                    border: Border.all(color: context.colors.primary, width: 3),
                    boxShadow: context.colors.primary.softShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: Spacing.xsmallBorderRadius,
                    child: Image.asset(tarot.imagePath, fit: BoxFit.cover),
                  ),
                ),
              ),
              Spacing.mediumW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacing.smallH,
                    Text(
                      tarot.title,
                      style: m18w700(context).copyWith(color: context.colors.primary),
                    ),
                    Spacing.smallH,
                    Text(
                      tarot.motto,
                      style: m15w500(context).copyWith(
                        color: context.colors.textPrimary.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ContextualMeaningsGrid extends StatelessWidget {
  const _ContextualMeaningsGrid({required this.tarot});
  final TarotCardModel tarot;

  @override
  Widget build(BuildContext context) {
    final meanings = tarot.contextualMeanings;

    final items = <_GridItemData>[
      if (meanings.general.isNotEmpty)
        _GridItemData(
          iconPath: TarotAppAssets.generalIcon.path,
          title: LocaleKeys.tarot_detail_general.tr(),
          description: meanings.general,
        ),
      if (meanings.love.isNotEmpty)
        _GridItemData(
          iconPath: TarotAppAssets.loveIcon.path,
          title: LocaleKeys.tarot_detail_love.tr(),
          description: meanings.love,
        ),
      if (meanings.career.isNotEmpty)
        _GridItemData(
          iconPath: TarotAppAssets.careerIcon.path,
          title: LocaleKeys.tarot_detail_career.tr(),
          description: meanings.career,
        ),
      if (meanings.spirituality.isNotEmpty)
        _GridItemData(
          iconPath: TarotAppAssets.spiritIcon.path,
          title: LocaleKeys.tarot_detail_spirituality.tr(),
          description: meanings.spirituality,
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: items.map((d) => _MeaningGridTile(data: d)).toList(),
    );
  }
}

class _GridItemData {
  const _GridItemData({
    required this.iconPath,
    required this.title,
    required this.description,
  });
  final String iconPath;
  final String title;
  final String description;
}

class _MeaningGridTile extends StatelessWidget {
  const _MeaningGridTile({required this.data});
  final _GridItemData data;

  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      padding: Spacing.defaultPadding,
      borderRadius: Spacing.xlargeBorderRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                data.iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(context.colors.primary, BlendMode.srcIn),
              ),
              Spacing.xsmallW,
              Text(data.title, style: m14w700(context)),
            ],
          ),
          Spacing.smallH,
          Expanded(
            child: Text(
              data.description,
              style: m12w400(context).copyWith(
                color: context.colors.textPrimary.withValues(alpha: 0.7),
                height: 1.5,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdviceCard extends StatelessWidget {
  const _AdviceCard({required this.tarot});
  final TarotCardModel tarot;

  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      width: double.infinity,
      borderRadius: Spacing.xlargeBorderRadius,
      child: Padding(
        padding: Spacing.hLargeVMediumPad,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded, size: 20, color: context.colors.primary),
                Spacing.smallW,
                Expanded(
                  child: Text(LocaleKeys.tarot_detail_advice.tr(), style: m16w700(context)),
                ),
              ],
            ),
            Spacing.xsmallH,
            Text(
              tarot.advice,
              style: m13w500(context).copyWith(
                color: context.colors.textPrimary.withValues(alpha: 0.8),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AffirmationCard extends StatelessWidget {
  const _AffirmationCard({required this.tarot});
  final TarotCardModel tarot;

  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      width: double.infinity,
      borderRadius: Spacing.xlargeBorderRadius,
      child: Padding(
        padding: Spacing.hLargeVMediumPad,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.self_improvement_rounded, size: 20, color: context.colors.primary),
                Spacing.smallW,
                Expanded(
                  child: Text(LocaleKeys.tarot_detail_affirmation.tr(), style: m16w700(context)),
                ),
              ],
            ),
            Spacing.xsmallH,
            Text(
              tarot.affirmation,
              style: m13w500(context).copyWith(
                color: context.colors.textPrimary.withValues(alpha: 0.8),
                height: 1.45,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
