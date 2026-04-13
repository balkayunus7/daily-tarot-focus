part of '../pages/tarot_explore_page.dart';

class ExploreFeatureCard extends StatelessWidget {
  const ExploreFeatureCard({
    required this.title,
    required this.imagePath,
    this.onTap,
    this.isDisabled = false,
    this.countdownText,
    super.key,
  });

  final String title;
  final String imagePath;
  final VoidCallback? onTap;
  final bool isDisabled;
  final String? countdownText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenHeight = Spacing.screenHeight(context);
    final cardHeight = screenHeight * 0.22;

    return AnimatedOpacity(
      opacity: isDisabled ? 0.65 : 1.0,
      duration: const Duration(milliseconds: 400),
      child: ScalingContainer(
        onTap: isDisabled ? null : onTap,
        child: Container(
          width: double.infinity,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: Spacing.defaultBorderRadius,
            border: Border.all(color: colors.borderSecondary, width: 0.5),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: Spacing.tinyPadding,
                        child: ClipRRect(
                          borderRadius: Spacing.smallBorderRadius,
                          child: Opacity(
                            opacity: 0.9,
                            child: Image.asset(imagePath, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: SpacingConsts.small,
                      right: SpacingConsts.small,
                      child: FancyContainer(
                        borderRadius: Spacing.xlargeBorderRadius,
                        padding: Spacing.tinyPadding,
                        borderColor: colors.textOnPrimary,
                        child: Icon(
                          isDisabled ? Icons.lock_outline : Icons.arrow_outward,
                          color: colors.textOnPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: SpacingConsts.small,
                  left: SpacingConsts.small,
                  right: SpacingConsts.small,
                ),
                child: Builder(
                  builder: (context) {
                    final showCountdown = isDisabled && countdownText != null;
                    if (showCountdown) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer_outlined, color: colors.textSecondary, size: 13),
                          Spacing.tinyW,
                          Text(
                            countdownText!,
                            style: m14w600(context).copyWith(
                              color: colors.textSecondary,
                              fontFeatures: [const FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text(
                        title,
                        style: m14w600(context),
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
    );
  }
}
