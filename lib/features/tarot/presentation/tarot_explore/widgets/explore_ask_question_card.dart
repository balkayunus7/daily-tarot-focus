part of '../pages/tarot_explore_page.dart';

class ExploreAskQuestionCard extends StatelessWidget {
  const ExploreAskQuestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = Spacing.screenHeight(context);
    final cardHeight = screenHeight / 4.7;
    final colors = context.colors;

    return ScalingContainer(
      onTap: () => context.push(AppRoutes.tarotQuestion),
      child: Container(
        width: double.infinity,
        height: cardHeight,
        padding: Spacing.xlargePadding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.gradientEnd, colors.background],
          ),
          borderRadius: Spacing.largeBorderRadius,
          border: Border.all(color: context.colors.border, width: 0.5),
        ),
        child: const Stack(
          clipBehavior: Clip.none,
          children: [_CardContent(), _OverlayCardImage()],
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent();

  @override
  Widget build(BuildContext context) {
    final screenWidth = Spacing.screenWidth(context);
    final contentSize = screenWidth * 0.4;
    final buttonWidth = screenWidth * 0.3;
    final buttonHeight = buttonWidth * 0.32;

    return SizedBox(
      width: contentSize,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.explore_page_ask_question_title.tr(),
            style: m18w600(context).copyWith(color: context.colors.textOnPrimary),
          ),
          Spacing.mediumH,
          IgnorePointer(
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: TarotButton(
                height: buttonHeight,
                width: buttonWidth,
                onTap: () {},
                buttonText: LocaleKeys.explore_page_ask_question_button.tr(),
                buttonTextStyle: m12w600(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlayCardImage extends StatelessWidget {
  const _OverlayCardImage();
  static const double _kWidthRatio = 0.35;
  static const double _kAspectRatio = 2.5 / 3;
  static const double _kPaddingRatio = 0.12;

  @override
  Widget build(BuildContext context) {
    final screenWidth = Spacing.screenWidth(context);
    final cardWidth = screenWidth * _kWidthRatio;
    final cardHeight = cardWidth / _kAspectRatio;

    return Positioned(
      right: -cardWidth * _kPaddingRatio,
      top: -cardHeight * _kPaddingRatio,
      bottom: -cardHeight * _kPaddingRatio,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: Spacing.defaultBorderRadius,
          image: DecorationImage(
            image: AssetImage(TarotAppAssets.maskotDaily.path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
