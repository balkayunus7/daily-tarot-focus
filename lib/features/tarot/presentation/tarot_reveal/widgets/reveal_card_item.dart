import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/helpers/reveal_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class RevealCardItem extends StatelessWidget {
  const RevealCardItem({required this.index, required this.isSelected, super.key});
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final scope = RevealPageScope.of(context);
    final cardWidth = scope.getRevealCardWidth(isSelected: isSelected);
    final cardHeight = scope.getRevealCardHeight(isSelected: isSelected);

    return RotatedBox(
      quarterTurns: -1,
      child: Center(
        child: GestureDetector(
          onTap: () => scope.handleCardTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: cardWidth,
            height: cardHeight,
            margin: (isSelected ? 0.0 : 2.0).padYR,
            decoration: BoxDecoration(
              borderRadius: Sp.medium.radiusR,
              border: Border.all(color: context.colors.border),
              boxShadow: isSelected ? context.colors.primary.mediumShadow : [],
            ),
            child: ClipRRect(
              borderRadius: Sp.medium.radiusR,
              child: CustomCacheNetworkImage(
                imageUrl: TarotAppAssets.cardBgHttp,
                width: cardWidth,
                height: cardHeight,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
