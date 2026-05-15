import 'dart:async';
import 'dart:math' as math;

import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/helpers/reveal_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class RevealFlipCard extends StatelessWidget {
  const RevealFlipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = RevealPageScope.of(context);
    if (!scope.isCardSelected) return const SizedBox.shrink();
    final selectedCard = scope.selectedTarotCard.value!;
    final isReversed = scope.selectedTarotCardIsReversed.value;

    return Center(
      child: AnimatedBuilder(
        animation: scope.revealAnimController,
        builder: (context, child) {
          final curvedValue = Curves.easeInOutSine.transform(
            scope.revealAnimController.value,
          );
          final rotateY = curvedValue * 6 * math.pi;
          final scale = 0.7 + (curvedValue * 1.2);
          final isFrontVisible = curvedValue >= 0.9;

          final transform =
              Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(rotateY)
                ..scaleByDouble(scale, scale, scale, 1);

          return Stack(
            alignment: Alignment.center,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: transform,
                child: Builder(
                  builder: (context) {
                    if (isFrontVisible) {
                      return _TarotFrontCard(
                        title: selectedCard.name,
                        imagePath: selectedCard.imageUrl,
                        isReversed: isReversed,
                      );
                    }
                    return const _TarotBackCard();
                  },
                ),
              ),
              if (isFrontVisible) const _TarotShiningStars(),
            ],
          );
        },
      ),
    );
  }
}

class _TarotFrontCard extends StatelessWidget {
  const _TarotFrontCard({
    required this.title,
    required this.imagePath,
    required this.isReversed,
  });
  final String title;
  final String imagePath;
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: TarotMockData.dailyTarotCardHeroTag,
      child: Container(
        width: CardSp.flipWidth,
        height: CardSp.flipHeight,
        decoration: BoxDecoration(
          borderRadius: Sp.xsmall.radiusR,
          border: Border.all(color: context.colors.border, width: 2),
          boxShadow: context.colors.primary.mediumShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: Sp.tiny.radiusR,
                child: Transform.rotate(
                  angle: isReversed ? math.pi : 0,
                  child: CustomCacheNetworkImage(
                    imageUrl: imagePath,
                    width: CardSp.flipWidth,
                    height: CardSp.flipHeight,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarotBackCard extends StatelessWidget {
  const _TarotBackCard();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: TarotMockData.dailyTarotCardHeroTag,
      child: Container(
        width: CardSp.flipWidth,
        height: CardSp.flipHeight,
        decoration: BoxDecoration(
          borderRadius: Sp.xsmall.radiusR,
          border: Border.all(color: context.colors.border),
          boxShadow: context.colors.primary.mediumShadow,
        ),
        child: ClipRRect(
          borderRadius: Sp.xsmall.radiusR,
          child: const CustomCacheNetworkImage(
            imageUrl: TarotAppAssets.cardBgHttp,
            width: CardSp.flipWidth,
            height: CardSp.flipHeight,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class _TarotShiningStars extends StatefulWidget {
  const _TarotShiningStars();

  @override
  State<_TarotShiningStars> createState() => _TarotShiningStarsState();
}

class _TarotShiningStarsState extends State<_TarotShiningStars>
    with TickerProviderStateMixin {
  late final AnimationController starsController;

  @override
  void initState() {
    super.initState();
    starsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    unawaited(starsController.repeat());
  }

  @override
  void dispose() {
    starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Transform.scale(
          scale: 5,
          child: Lottie.asset(
            TarotAppAssets.shiningStars.path,
            controller: starsController,
            fit: BoxFit.contain,
            repeat: true,
            animate: true,
          ),
        ),
      ),
    );
  }
}
