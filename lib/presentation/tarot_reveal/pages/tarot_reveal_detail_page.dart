import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/base_gradient_layout.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/reveal_detail_section.dart';

class TarotRevealDetailPage extends StatelessWidget {
  const TarotRevealDetailPage({required this.tarot, super.key});
  final TarotData tarot;

  @override
  Widget build(BuildContext context) {
    return BaseGradientLayout(
      appBar: TarotAppBar(
        title: tarot.title,
        backIcon: Icons.close,
        onBackIconTap: () => context.go(AppRoutes.tarotExplore),
        trailingIcon: Icons.save_as_rounded,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpacingConsts.large),
            child: Column(
              children: [
                Spacing.smallH,
                Text(tarot.description, style: m14w500(context)),
                Spacing.largeH,
                _RevealDetailCard(imagePath: tarot.imagePath),
                Spacing.largeH,
                RevealDetailSection(
                  title: LocaleKeys.libraryMeaningForDay.tr(),
                  descriptions: tarot.meanings,
                  icon: Icons.diamond,
                  iconColor: context.colors.primary,
                ),
                Spacing.largeH,
                RevealDetailSection(
                  title: LocaleKeys.libraryUprightMeanings.tr(),
                  descriptions: tarot.uprightMeanings,
                  icon: Icons.check_circle,
                  iconColor: context.colors.correctColor,
                ),
                Spacing.largeH,
                RevealDetailSection(
                  title: LocaleKeys.libraryReversedMeanings.tr(),
                  descriptions: tarot.reversedMeanings,
                  icon: Icons.warning,
                  iconColor: context.colors.primary,
                ),
                Spacing.largeH,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RevealDetailCard extends StatelessWidget {
  const _RevealDetailCard({required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Hero(
        tag: TarotMockData.dailyTarotCardHeroTag,
        child: Container(
          height: screenSize.height * 0.4,
          decoration: BoxDecoration(
            borderRadius: Spacing.smallBorderRadius,
            border: Border.all(color: context.colors.primary, width: 2),
            boxShadow: context.colors.primary.highShadow,
          ),
          child: ClipRRect(
            borderRadius: Spacing.smallBorderRadius,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
