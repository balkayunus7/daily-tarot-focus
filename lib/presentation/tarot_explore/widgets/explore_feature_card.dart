part of '../pages/tarot_explore_page.dart';

class ExploreFeatureCard extends StatelessWidget {
  const ExploreFeatureCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
    super.key,
  });

  final String title;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenHeight = Spacing.screenHeight(context);
    final cardHeight = screenHeight * 0.22;

    return ScalingContainer(
      onTap: onTap,
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
                          opacity: 0.8,
                          child: Image.asset(imagePath, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: SpacingConsts.small,
                    right: SpacingConsts.small,
                    child: FancyContainer(
                      color: colors.primary,
                      borderRadius: Spacing.xlargeBorderRadius,
                      padding: Spacing.tinyPadding,
                      child: Icon(Icons.arrow_outward, color: colors.textPrimary, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: SpacingConsts.xsmall,
                left: SpacingConsts.small,
                right: SpacingConsts.small,
              ),
              child: Text(
                title,
                style: m14w600(context),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
