import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_identify.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/detail/tarot_detail_desc_section.dart';

class TarotRevealDetailPage extends StatelessWidget {
  const TarotRevealDetailPage({
    required this.tarot,
    required this.imagePath,
    super.key,
  });
  final TarotIdentify tarot;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final colors = context.colors;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TarotAppBar(
        title: tarot.title,
        backIcon: Icons.close,
        onBackIconTap: () => context.go(AppRoutes.home),
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
                            child: Image.asset(imagePath, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    Spacing.largeH,
                    if (tarot.hasMeanings) ...[
                      DetailDescriptionSection(
                        title: 'Meaning for Your Day',
                        descriptions: tarot.meanings!,
                        icon: Icons.diamond,
                        iconColor: context.colors.primary,
                      ),
                    ],
                    Spacing.largeH,
                    if (tarot.hasAdvice) ...[
                      DetailDescriptionSection(
                        title: 'Advice',
                        descriptions: tarot.advices!,
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                      ),
                    ],
                    Spacing.largeH,
                    if (tarot.hasWarnings) ...[
                      DetailDescriptionSection(
                        title: 'Warnings',
                        descriptions: tarot.warnings!,
                        icon: Icons.warning,
                        iconColor: context.colors.primary,
                      ),
                    ],
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
