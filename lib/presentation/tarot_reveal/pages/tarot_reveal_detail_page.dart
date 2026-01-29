import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/tarot_detail_desc_section.dart';

class TarotRevealDetailPage extends StatelessWidget {
  const TarotRevealDetailPage({required this.tarot, super.key});
  final TarotLibrary tarot;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final colors = context.colors;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TarotAppBar(
        title: tarot.title,
        backIcon: Icons.close,
        onBackIconTap: () => context.go(AppRoutes.tarotExplore),
        trailingIcon: Icons.save_as_rounded,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary,
                  colors.secondary,
                  colors.accent,
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Spacing.smallH,
                    Text(
                      tarot.description,
                      style: m14w500(context),
                    ),
                    Spacing.largeH,
                    Center(
                      child: Hero(
                        tag: 'daily_tarot_card_hero',
                        child: Container(
                          height: screenSize.height * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: Spacing.smallBorderRadius,
                            border: Border.all(
                              color: context.colors.primary,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: context.colors.primary.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: Spacing.smallBorderRadius,
                            child: Image.asset(
                              tarot.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacing.largeH,
                    DetailDescriptionSection(
                      title: LocaleKeys.libraryMeaningForDay.tr(),
                      descriptions: tarot.meanings,
                      icon: Icons.diamond,
                      iconColor: context.colors.primary,
                    ),
                    Spacing.largeH,
                    DetailDescriptionSection(
                      title: LocaleKeys.libraryUprightMeanings.tr(),
                      descriptions: tarot.uprightMeanings,
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                    ),
                    Spacing.largeH,
                    DetailDescriptionSection(
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
        ],
      ),
    );
  }
}
