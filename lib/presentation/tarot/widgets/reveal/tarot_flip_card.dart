part of '../../pages/tarot_reveal_page.dart';

class TarotFlipCard extends StatefulWidget {
  const TarotFlipCard({super.key});

  @override
  State<TarotFlipCard> createState() => _TarotFlipCardState();
}

class _TarotFlipCardState extends State<TarotFlipCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: _TarotRevealConstants.cardFlipDuration,
        curve: Curves.easeInOutCubic,
        onEnd: () {
          context.go(AppRoutes.tarotCardDetail);
        },
        builder: (context, value, child) {
          final isFrontVisible = value >= 0.5;
          final rotateY = math.pi * value;
          final transform =
              Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(rotateY)
                ..scale(1.9, 1.9, 1.9);

          return Stack(
            alignment: Alignment.center,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: transform,
                child: Builder(
                  builder: (context) {
                    if (isFrontVisible) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(math.pi),
                        child: const _TarotFrontCard(title: 'Star'),
                      );
                    } else {
                      return const _TarotBackCard();
                    }
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
  const _TarotFrontCard({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'daily_tarot_card_hero',
      child: Container(
        width: SpacingConsts.cardWidth,
        height: SpacingConsts.cardHeight,
        padding: const EdgeInsets.all(8),
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
                  TarotAppAssets.starCard.path,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: Spacing.tinyPadding,
              child: Text('The Star', style: m12w600(context)),
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
        width: SpacingConsts.cardWidth,
        height: SpacingConsts.cardHeight,
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
      duration: _TarotRevealConstants.starsAnimationDuration,
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
