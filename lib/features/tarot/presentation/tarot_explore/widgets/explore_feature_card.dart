part of '../pages/tarot_explore_page.dart';

class ExploreFeatureCard extends StatelessWidget {
  const ExploreFeatureCard({
    required this.title,
    this.isDisabled = false,
    this.imagePath,
    this.imageWidget,
    this.onTap,
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
