part of '../../pages/tarot_reveal_page.dart';

class TarotFlipCard extends StatelessWidget {
  const TarotFlipCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get random tarot card with full data
    final randomCard = TarotMockDatas.randomTarotLibraryCard;
    final randomImagePath = randomCard.imagePath;
    final randomTarotIdentify = randomCard.toTarotIdentify();

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(seconds: 8),
        curve: Curves.easeIn,
        onEnd: () {
          Future.delayed(const Duration(seconds: 3), () async {
            if (context.mounted) {
              await context.push(
                AppRoutes.tarotRevealDetail,
                extra: {
                  'imagePath': randomImagePath,
                  'tarot': randomTarotIdentify.toMap(),
                },
              );
            }
          });
        },
        builder: (context, value, child) {
          // Gradually accelerating flip animation with multiple rotations
          // 4 rotations = 8 * pi radians
          final rotateY = value * 8 * math.pi;
          // First 80%: rotation, last 20%: card appears
          final isFrontVisible = value >= 0.8;
          // Scale animation: starts larger, then grows
          final scale =
              value < 0.8
                  ? 0.7 + (value / 0.8) * 0.2
                  : 0.9 + ((value - 0.8) / 0.2) * 1.0;

          // Show front face only in last 20%, back face visible during rotation
          final shouldShowFront = isFrontVisible;

          final transform =
              Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(rotateY)
                ..scale(scale, scale, scale);

          return Stack(
            alignment: Alignment.center,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: transform,
                child:
                    shouldShowFront
                        ? _TarotFrontCard(
                          title: randomCard.title,
                          imagePath: randomImagePath,
                        )
                        : const _TarotBackCard(),
              ),
              if (isFrontVisible) const _TarotShiningStars(),
              // Show loading message during rotation
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
      tag: 'daily_tarot_card_hero',
      child: Container(
        width: SpacingConsts.flipCardWidth,
        height: SpacingConsts.flipCardHeight,
        padding: Spacing.xsmallPadding,
        decoration: BoxDecoration(
          borderRadius: Spacing.xsmallBorderRadius,
          border: Border.all(color: context.colors.primary, width: 2),
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withValues(alpha: 0.3),
              blurRadius: SpacingConsts.cardShadowBlurRadius,
              spreadRadius: 10,
            ),
          ],
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
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
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
      tag: 'daily_tarot_card_hero',
      child: Container(
        width: SpacingConsts.flipCardWidth,
        height: SpacingConsts.flipCardHeight,
        decoration: BoxDecoration(
          borderRadius: Spacing.xsmallBorderRadius,
          border: Border.all(color: context.colors.primary),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: SpacingConsts.cardShadowBlurRadius,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: Spacing.xsmallBorderRadius,
          child: Image.asset(
            TarotAppAssets.cardDesign.path,
            fit: BoxFit.cover,
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
    starsController.stop();
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
