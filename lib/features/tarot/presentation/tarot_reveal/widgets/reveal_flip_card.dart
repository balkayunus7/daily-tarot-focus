part of '../pages/tarot_reveal_page.dart';

class RevealFlipCard extends StatelessWidget {
  const RevealFlipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = RevealPageScope.of(context);
    if (!scope.isCardSelected) return const SizedBox.shrink();
    final selectedCard = scope.selectedTarotCard.value!;

    return Center(
      child: AnimatedBuilder(
        animation: scope.revealAnimController,
        builder: (context, child) {
          final curvedValue = Curves.easeInOutSine.transform(scope.revealAnimController.value);
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
                        imagePath: selectedCard.imagePath,
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
  const _TarotFrontCard({required this.title, required this.imagePath});
  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: TarotMockData.dailyTarotCardHeroTag,
      child: Container(
        width: SpacingConsts.flipCardWidth,
        height: SpacingConsts.flipCardHeight,
        decoration: BoxDecoration(
          borderRadius: Spacing.xsmallBorderRadius,
          border: Border.all(color: context.colors.border, width: 2),
          boxShadow: context.colors.primary.mediumShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: Spacing.tinyBorderRadius,
                child: Image.asset(imagePath, fit: BoxFit.cover),
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
        width: SpacingConsts.flipCardWidth,
        height: SpacingConsts.flipCardHeight,
        decoration: BoxDecoration(
          borderRadius: Spacing.xsmallBorderRadius,
          border: Border.all(color: context.colors.border),
          boxShadow: context.colors.primary.mediumShadow,
        ),
        child: ClipRRect(
          borderRadius: Spacing.xsmallBorderRadius,
          child: Image.asset(TarotAppAssets.cardBg.path, fit: BoxFit.fill),
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

class _TarotShiningStarsState extends State<_TarotShiningStars> with TickerProviderStateMixin {
  late final AnimationController starsController;

  @override
  void initState() {
    super.initState();
    starsController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
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
