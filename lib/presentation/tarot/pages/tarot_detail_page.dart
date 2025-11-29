import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/tarot_detail_desc_section.dart';

class TarotDetailPage extends StatelessWidget {
  const TarotDetailPage({super.key});

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
                    Text('The Star', style: m28w600(context)),
                    Spacing.smallH,
                    Text(
                      '– is a card of confidence, energy, and leadership. It suggests a day full of motivation and personal magnetism.',
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
                    const DetailDescriptionSection(
                      title: 'Advice',
                      descriptions: [
                        'Take bold steps – This is a great day to show initiative.',
                        'Be social – Your communication skills are strong today.',
                        'Pay attention to your appearance – A little extra confidence goes a long way.',
                      ],
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                    ),
                    Spacing.largeH,
                    const DetailDescriptionSection(
                      title: 'Warnings',
                      descriptions: [
                        'Avoid being too controlling – Let others have their space.',
                        'Watch your words – Your directness could come off as harsh.',
                        "Balance is key – Don't let ambition overshadow rest and emotional well-being.",
                      ],
                      icon: Icons.warning,
                      iconColor: Colors.amber,
                    ),
                    Spacing.largeH,
                    const DetailDescriptionSection(
                      title: 'Meaning for Your Day',
                      descriptions: [
                        "Energy & Inspiration – You'll feel motivated and ready to take action.",
                        'Charisma & Influence – People will notice and respect your confidence.',
                        'Attraction & Charm – You may naturally draw attention in both work and personal life.',
                      ],
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
