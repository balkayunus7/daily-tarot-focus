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
          // Even gentler curve for a more mystical feel
          final curvedValue = Curves.easeInOutSine.transform(
            scope.revealAnimController.value,
          );
          // 3 rotations (6 * pi) over the now 10-second duration
          final rotateY = curvedValue * 6 * math.pi;
          // Continuous growth from 0.7 (small/far) to 1.9 (large/close)
          final scale = 0.7 + (curvedValue * 1.2);
          // Transition to front card closer to the end for the final reveal (0.9 threshold)
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
                        title: selectedCard.title,
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
        padding: Spacing.xsmallPadding,
        decoration: BoxDecoration(
          borderRadius: Spacing.xsmallBorderRadius,
          border: Border.all(color: context.colors.primary, width: 2),
          boxShadow: context.colors.primary.mediumShadow,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colors.primary,
              context.colors.secondary,
              context.colors.accent,
            ],
          ),
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
            Container(
              padding: Spacing.tinyPadding,
              child: Text(title, style: m12w600(context)),
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
          border: Border.all(color: context.colors.primary),
          boxShadow: context.colors.primary.mediumShadow,
        ),
        child: ClipRRect(
          borderRadius: Spacing.xsmallBorderRadius,
          child: Image.asset(TarotAppAssets.cardBack.path, fit: BoxFit.fill),
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
