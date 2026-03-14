import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class SharedTarotDetailPageContent extends StatelessWidget {
  const SharedTarotDetailPageContent({
    required this.tarot,
    this.showMeaningForDay = false,
    super.key,
  });

  final TarotCard tarot;
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
          _MeaningCard(tarot: tarot),
          if (showMeaningForDay) ...[
            Spacing.xlargeH,
            _MeaningForDaySection(tarot: tarot),
          ],
          Spacing.xlargeH,
          _MeaningsCardSection(
            title: LocaleKeys.libraryUprightMeanings.tr(),
            descriptions: tarot.uprightMeanings,
            headerIcon: Icons.arrow_upward_rounded,
            glowColor: Colors.green,
            bulletIcon: Icons.check_circle,
            bulletColor: Colors.green,
          ),
          Spacing.largeH,
          _MeaningsCardSection(
            title: LocaleKeys.libraryReversedMeanings.tr(),
            descriptions: tarot.reversedMeanings,
            headerIcon: Icons.arrow_downward_rounded,
            glowColor: context.colors.primary,
            bulletIcon: Icons.warning_rounded,
            bulletColor: context.colors.primary,
          ),
          Spacing.xlargeH,
        ],
      ),
    );
  }
}

class _MeaningCard extends StatelessWidget {
  const _MeaningCard({required this.tarot});
  final TarotCard tarot;

  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      padding: Spacing.defaultPadding,
      borderRadius: Spacing.xlargeBorderRadius,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 3.2;
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
                      'Meaning',
                      style: m18w700(context).copyWith(color: context.colors.primary),
                    ),
                    Spacing.smallH,
                    Text(
                      tarot.description,
                      style: m13w500(context).copyWith(
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

class _MeaningForDaySection extends StatelessWidget {
  const _MeaningForDaySection({required this.tarot});
  final TarotCard tarot;

  @override
  Widget build(BuildContext context) {
    final meanings = tarot.meanings;
    final primary = context.colors.primary;

    final items = <_GridItemData>[
      _GridItemData(
        iconPath: TarotAppAssets.generalIcon.path,
        color: primary,
        title: 'General',
        description: meanings.isNotEmpty ? meanings[0] : '',
      ),
      _GridItemData(
        iconPath: TarotAppAssets.careerIcon.path,
        color: primary,
        title: 'Career',
        description: meanings.length > 1 ? meanings[1] : '',
      ),
      _GridItemData(
        iconPath: TarotAppAssets.loveIcon.path,
        color: primary,
        title: 'Love',
        description: meanings.length > 2 ? meanings[2] : '',
      ),
      _GridItemData(
        iconPath: TarotAppAssets.spiritIcon.path,
        color: primary,
        title: 'Spirit',
        description: meanings.length > 3 ? meanings[3] : '',
      ),
    ];

    final valid = items.where((i) => i.description.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.libraryMeaningForDay.tr(), style: m16w600(context)),
        Spacing.mediumH,
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: valid.map((d) => _MeaningGridTile(data: d)).toList(),
        ),
      ],
    );
  }
}

class _GridItemData {
  const _GridItemData({
    required this.iconPath,
    required this.color,
    required this.title,
    required this.description,
  });
  final String iconPath;
  final Color color;
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                data.iconPath,
                width: 26,
                height: 26,
                colorFilter: ColorFilter.mode(data.color, BlendMode.srcIn),
              ),
              Spacing.xsmallW,
              Text(data.title, style: m18w600(context)),
            ],
          ),
          Spacing.xsmallH,
          Expanded(
            child: Text(
              data.description,
              style: m12w400(context).copyWith(
                color: context.colors.textPrimary.withValues(alpha: 0.7),
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeaningsCardSection extends StatelessWidget {
  const _MeaningsCardSection({
    required this.title,
    required this.descriptions,
    required this.headerIcon,
    required this.glowColor,
    required this.bulletIcon,
    required this.bulletColor,
  });
  final String title;
  final List<String> descriptions;
  final IconData headerIcon;
  final Color glowColor;
  final IconData bulletIcon;
  final Color bulletColor;

  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      width: double.infinity,
      borderRadius: Spacing.xlargeBorderRadius,
      child: Padding(
        padding: Spacing.largePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(headerIcon, size: 20, color: glowColor),
                Spacing.smallW,
                Expanded(
                  child: Text(title, style: m16w700(context)),
                ),
              ],
            ),
            Spacing.mediumH,
            ...descriptions.map(
              (desc) => Padding(
                padding: const EdgeInsets.only(bottom: SpacingConsts.small),
                child: Row(
                  children: [
                    Icon(bulletIcon, size: 18, color: bulletColor),
                    Spacing.smallW,
                    Expanded(
                      child: Text(
                        desc,
                        style: m14w400(context).copyWith(
                          color: context.colors.textPrimary.withValues(alpha: 0.8),
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
