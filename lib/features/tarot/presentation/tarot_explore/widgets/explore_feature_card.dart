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
    final screenHeight = context.suHeight;
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
            borderRadius: Sp.medium.radiusR,
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
                        padding: Sp.tiny.padAllR,
                        child: ClipRRect(
                          borderRadius: Sp.small.radiusR,
                          child: Opacity(
                            opacity: 0.9,
                            child: CustomCacheNetworkImage(imageUrl: imagePath, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
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
                  ],
                ),
              ),
              Padding(
                padding: Sp.small.padOnlyR(b: true, l: true, r: true),
                child: Builder(
                  builder: (context) {
                    final showCountdown = isDisabled && countdownText != null;
                    if (showCountdown) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer_outlined, color: colors.textSecondary, size: 13),
                          Sp.tiny.widthBox,
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
