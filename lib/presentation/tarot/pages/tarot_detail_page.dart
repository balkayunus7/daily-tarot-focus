import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/detail/tarot_detail_desc_section.dart';

class TarotDetailPage extends StatelessWidget {
  const TarotDetailPage({required this.tarot, super.key});
  final Tarot tarot;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final colors = context.colors;

    return Scaffold(
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
                    Text(tarot.title, style: m28w600(context)),
                    Spacing.smallH,
                    Text(
                      tarot.description,
                      style: m14w400(context),
                    ),
                    Spacing.largeH,
                    Center(
                      child: Hero(
                        tag: 'daily_tarot_card_hero',
                        child: Container(
                          height: screenSize.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withValues(alpha: 0.3),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              TarotAppAssets.starCard.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacing.largeH,
                    DetailDescriptionSection(
                      title: 'Advice',
                      descriptions: tarot.advices,
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                    ),
                    Spacing.largeH,
                    DetailDescriptionSection(
                      title: 'Warnings',
                      descriptions: tarot.warnings,
                      icon: Icons.warning,
                      iconColor: Colors.amber,
                    ),
                    Spacing.largeH,
                    DetailDescriptionSection(
                      title: 'Meaning for Your Day',
                      descriptions: tarot.meanings,
                      icon: Icons.diamond,
                      iconColor: Colors.amber,
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
