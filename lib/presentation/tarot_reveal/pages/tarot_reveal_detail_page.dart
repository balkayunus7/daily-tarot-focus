import 'package:daily_tarot_focus/application/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/application/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/base_gradient_layout.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:daily_tarot_focus/presentation/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/reveal_detail_section.dart';

class TarotRevealDetailPage extends StatelessWidget {
  const TarotRevealDetailPage({required this.tarot, super.key});
  final TarotCard tarot;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TarotBloc, TarotState>(
      listenWhen: (previous, current) => previous.hasSavedDailyCard != current.hasSavedDailyCard,
      listener: (context, state) {
        if (state.hasSavedDailyCardFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kart kaydedilemedi')),
          );
        }
        if (state.hasSavedDailyCardSucceeded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kart kaydedildi ✨')),
          );
          context.go(AppRoutes.tarotExplore, extra: HomePageArguments(context, initialTabIndex: 1));
        }
      },
      builder: (context, state) {
        return BaseGradientLayout(
          appBar: TarotAppBar(
            title: tarot.title,
            onBackIconTap: () => context.go(AppRoutes.tarotExplore),
            trailingIcon:
                state.isSavingDailyCard ? FontAwesomeIcons.spinner : FontAwesomeIcons.floppyDisk,
            onIconTap:
                state.isSavingDailyCard
                    ? () {}
                    : () {
                      final authState = context.read<AuthCubit>().state;
                      final langCode = Localizations.localeOf(context).languageCode;

                      context.read<TarotBloc>().addDailyCardSaved(
                        session: authState.sessionOrCrash,
                        tarotCardId: tarot.id,
                        languageCode: langCode,
                      );
                    },
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: SpacingConsts.large),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Spacing.xlargeH,
                    _MeaningForDaySection(tarot: tarot),
                    Spacing.xlargeH,
                    _MeaningsCardSection(
                      title: LocaleKeys.libraryUprightMeanings.tr(),
                      descriptions: tarot.uprightMeanings,
                      headerIcon: Icons.arrow_upward_rounded,
                      glowColor: const Color(0xFF4CAF50),
                      bulletIcon: Icons.check_circle,
                      bulletColor: const Color(0xFF4CAF50),
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
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MeaningCard extends StatelessWidget {
  const _MeaningCard({required this.tarot});
  final TarotCard tarot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Spacing.defaultPadding,
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.4),
        borderRadius: Spacing.xlargeBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: TarotMockData.dailyTarotCardHeroTag,
            child: Container(
              width: 100,
              height: 150,
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
    final gold = context.colors.primary;

    final items = <_GridItemData>[
      _GridItemData(
        iconPath: TarotAppAssets.general.path,
        color: gold,
        title: 'General',
        description: meanings.isNotEmpty ? meanings[0] : '',
      ),
      _GridItemData(
        iconPath: TarotAppAssets.career.path,
        color: gold,
        title: 'Career',
        description: meanings.length > 1 ? meanings[1] : '',
      ),
      _GridItemData(
        iconPath: TarotAppAssets.love.path,
        color: gold,
        title: 'Love',
        description: meanings.length > 2 ? meanings[2] : '',
      ),
      _GridItemData(
        iconPath: TarotAppAssets.spirit.path,
        color: gold,
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
          childAspectRatio: 1.5,
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
    return Container(
      padding: Spacing.defaultPadding,
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.4),
        borderRadius: Spacing.xlargeBorderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(data.iconPath, width: 28, height: 28),
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.4),
        borderRadius: Spacing.xlargeBorderRadius,
      ),
      child: Stack(
        children: [
          Container(
            width: 3,
            decoration: BoxDecoration(
              color: glowColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.8),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: SpacingConsts.xlarge + 4,
              right: SpacingConsts.large,
              top: SpacingConsts.large,
              bottom: SpacingConsts.large,
            ),
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
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(bulletIcon, size: 18, color: bulletColor),
                        ),
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
        ],
      ),
    );
  }
}
