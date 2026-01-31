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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _CardBackground(imagePath: imagePath),
            _CardForeground(title: title),
          ],
        ),
      ),
    );
  }
}

class _CardBackground extends StatelessWidget {
  const _CardBackground({required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: Spacing.tinyPadding,
        child: ClipRRect(
          borderRadius: Spacing.smallBorderRadius,
          child: Opacity(
            opacity: 0.6,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

class _CardForeground extends StatelessWidget {
  const _CardForeground({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: Spacing.defaultPadding,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: FancyContainer(
              color: colors.primary,
              borderRadius: Spacing.xlargeBorderRadius,
              padding: Spacing.tinyPadding,
              child: Icon(
                Icons.arrow_outward,
                color: colors.textPrimary,
                size: 20,
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(title, style: m16w600(context)),
          ),
        ],
      ),
    );
  }
}
