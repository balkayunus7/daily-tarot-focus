part of '../pages/tarot_explore_page.dart';

class ExploreSpreadCard extends StatelessWidget {
  const ExploreSpreadCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.suHeight;
    final cardHeight = screenHeight / 6;
    final colors = context.colors;

    return ScalingContainer(
      onTap: () async {
        context.read<TarotBloc>().addReadingFlowReset(flowType: TarotFlowType.otherSpreads);
        await context.push(AppRoutes.tarotQuestionStep1);
      },
      child: Container(
        width: double.infinity,
        height: cardHeight,
        padding: Sp.xlarge.padAllR,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.gradientStart, colors.gradientEnd, colors.background],
          ),
          borderRadius: Sp.large.radiusR,
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
    final screenWidth = context.suWidth;
    final contentSize = screenWidth * 0.4;
    final buttonWidth = screenWidth * 0.28;
    final buttonHeight = buttonWidth * 0.32;

    return SizedBox(
      width: contentSize,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.explore_page_spread_title.tr(),
            style: m16w600(context).copyWith(color: context.colors.textOnPrimary),
          ),
          Sp.small.heightBox,
          IgnorePointer(
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: FancyButton(
                width: buttonWidth,
                height: buttonHeight,
                onTap: () {},
                backgroundColor: context.colors.primary,
                text: LocaleKeys.explore_page_spread_button.tr(),
                textStyle: m12w600(context).copyWith(color: context.colors.textOnPrimary),
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
  static const double _kPaddingRatio = 0.14;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.suWidth;
    final cardWidth = screenWidth * _kWidthRatio;
    final cardHeight = cardWidth / _kAspectRatio;

    return Positioned(
      right: -cardWidth * _kPaddingRatio,
      top: -cardHeight * _kPaddingRatio,
      bottom: -cardHeight * _kPaddingRatio,
      child: CustomCacheNetworkImage(
        imageUrl: TarotAppAssets.maskotDailyHttp,
        width: cardWidth,
        height: cardHeight,
      ),
    );
  }
}
