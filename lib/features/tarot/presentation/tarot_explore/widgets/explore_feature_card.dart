part of '../pages/tarot_explore_page.dart';

class ExploreFeatureCard extends StatelessWidget {
  const ExploreFeatureCard({
    required this.title,
    this.imagePath,
    this.imageWidget,
    this.onTap,
    this.isDisabled = false,
    this.countdownText,
    super.key,
  });

  final String title;
  final String? imagePath;
  final Widget? imageWidget;
  final VoidCallback? onTap;
  final bool isDisabled;
  final String? countdownText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenHeight = context.suHeight;
    final cardHeight = screenHeight * 0.17;

    return AnimatedOpacity(
      opacity: isDisabled ? 0.65 : 1.0,
      duration: const Duration(milliseconds: 400),
      child: ScalingContainer(
        onTap: isDisabled ? null : onTap,
        child: Container(
          width: double.infinity,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: Sp.medium.radiusR,
            border: Border.all(color: colors.borderSecondary, width: 0.5),
          ),
          child: ClipRRect(
            borderRadius: Sp.medium.radiusR,
            child: Stack(
              fit: StackFit.expand,
              children: [
                imageWidget!,
                Positioned(
                  top: Sp.small,
                  right: Sp.small,
                  child: FancyContainer(
                    borderRadius: Sp.xlarge,
                    padding: Sp.tiny.padAllR,
                    color: colors.primary.withValues(alpha: 0.5),
                    child: Icon(
                      isDisabled ? Icons.lock_outline : Icons.arrow_outward,
                      color: colors.textOnPrimary,
                      size: 16.sp,
                    ),
                  ),
                ),
                Positioned(
                  left: Sp.small,
                  right: Sp.small,
                  bottom: Sp.small,
                  child: Builder(
                    builder: (context) {
                      final showCountdown = isDisabled && countdownText != null;
                      if (showCountdown) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_outlined, color: Colors.white, size: 13),
                            Sp.tiny.widthBox,
                            Text(
                              countdownText!,
                              style: m14w600(context).copyWith(
                                color: Colors.white,
                                fontFeatures: [const FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text(
                          title,
                          style: m14w600(context).copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DailyFateIllustration extends StatelessWidget {
  const _DailyFateIllustration();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final darkest = colors.primary;
    final mid = colors.secondary;
    const moonGold = Color(0xFFE8D5A3);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [darkest, mid, colors.secondary],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(top: 10, left: 16, child: _Sparkle(size: 3.5, opacity: 0.9)),
          const Positioned(top: 24, right: 22, child: _Sparkle(size: 2, opacity: 0.7)),
          const Positioned(top: 42, left: 28, child: _Sparkle(size: 2.5, opacity: 0.6)),
          const Positioned(top: 12, left: 52, child: _Sparkle(size: 1.5, opacity: 0.8)),
          const Positioned(bottom: 20, left: 12, child: _Sparkle(size: 2, opacity: 0.6)),
          const Positioned(bottom: 32, right: 14, child: _Sparkle(size: 1.5, opacity: 0.5)),
          const Positioned(top: 6, right: 38, child: _Sparkle(size: 2.5, opacity: 0.75)),
          const Positioned(bottom: 14, left: 40, child: _Sparkle(size: 1.5, opacity: 0.4)),
          const Center(
            child: SizedBox(
              width: 64,
              height: 64,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40E8D5A3),
                      blurRadius: 28,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 56,
              height: 56,
              child: ClipOval(
                child: Stack(
                  children: [
                    const ColoredBox(color: moonGold, child: SizedBox.expand()),
                    Positioned(
                      right: -13,
                      top: -13,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.lerp(colors.secondary, Colors.black, 0.75),
                        ),
                      ),
                    ),
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

class _SacredDecksIllustration extends StatelessWidget {
  const _SacredDecksIllustration();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final darkest = colors.primary;
    final mid = colors.secondary;
    final light = colors.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [darkest, mid, light],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: const Stack(
        children: [
          Positioned(top: 8, left: 14, child: _Sparkle(size: 2, opacity: 0.7)),
          Positioned(top: 20, right: 10, child: _Sparkle(size: 1.5, opacity: 0.6)),
          Positioned(bottom: 14, right: 18, child: _Sparkle(size: 2.5, opacity: 0.8)),
          Positioned(bottom: 22, left: 8, child: _Sparkle(size: 1.5, opacity: 0.5)),
          Positioned(top: 10, right: 30, child: _Sparkle(size: 1.5, opacity: 0.55)),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _MiniTarotCard(rotationAngle: -0.38, isBack: true, offsetX: -16),
                _MiniTarotCard(rotationAngle: 0, isBack: true),
                _MiniTarotCard(rotationAngle: 0.38, isBack: false, offsetX: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniTarotCard extends StatelessWidget {
  const _MiniTarotCard({
    required this.rotationAngle,
    required this.isBack,
    this.offsetX = 0,
  });

  final double rotationAngle;
  final bool isBack;
  final double offsetX;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cardDark = Color.lerp(colors.primary, Colors.black, 0.75)!;
    final cardMid = Color.lerp(colors.primary, Colors.black, 0.48)!;

    return Transform.translate(
      offset: Offset(offsetX, 0),
      child: Transform.rotate(
        angle: rotationAngle,
        child: Container(
          width: 38.r,
          height: 56.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isBack
                      ? [cardDark, cardMid]
                      : [colors.accent, colors.accent.withValues(alpha: 0.7)],
            ),
            border: Border.all(
              color: colors.primary.withValues(alpha: isBack ? 0.4 : 0.7),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child:
              isBack
                  ? Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: colors.primary.withValues(alpha: 0.65),
                      size: 18.sp,
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wb_sunny_outlined, color: colors.primary, size: 16.sp),
                        const SizedBox(height: 6),
                        Container(height: 1, color: colors.primary.withValues(alpha: 0.45)),
                        const SizedBox(height: 4),
                        Container(height: 1, color: colors.primary.withValues(alpha: 0.3)),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.size, this.opacity = 1.0});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size.r,
        height: size.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
