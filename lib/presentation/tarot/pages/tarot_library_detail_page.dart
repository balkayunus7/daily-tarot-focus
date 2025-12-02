import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_library.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotLibraryDetailPage extends StatelessWidget {
  const TarotLibraryDetailPage({
    required this.tarot,
    required this.imagePath,
    super.key,
  });
  final TarotLibrary tarot;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final colors = context.colors;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TarotAppBar(title: tarot.title),
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
                    DetailDescriptionSection(
                      title: 'Meaning for Your Day',
                      descriptions: tarot.meanings,
                      icon: Icons.diamond,
                      iconColor: context.colors.primary,
                    ),
                    Spacing.largeH,
                    DetailDescriptionSection(
                      title: 'Upright Meanings',
                      descriptions: tarot.uprightMeanings,
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                    ),
                    Spacing.largeH,
                    DetailDescriptionSection(
                      title: 'Reversed Meanings',
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

class DetailDescriptionSection extends StatelessWidget {
  const DetailDescriptionSection({
    required this.title,
    required this.descriptions,
    required this.icon,
    required this.iconColor,
    super.key,
  });
  final String title;
  final List<String> descriptions;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: m18w600(context)),
        Spacing.mediumH,
        ...descriptions.map(
          (description) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _buildDescriptionItem(
              context,
              icon: icon,
              iconColor: iconColor,
              text: description,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 12),
          child: Icon(
            icon,
            size: 16,
            color: iconColor,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: m14w500(context).copyWith(
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
