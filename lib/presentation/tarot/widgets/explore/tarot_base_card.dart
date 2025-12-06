part of '../../pages/tarot_explore_page.dart';

class TarotBaseCard extends StatelessWidget {
  const TarotBaseCard({
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
    super.key,
  });
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 190,
        decoration: BoxDecoration(
          borderRadius: Spacing.defaultBorderRadius,
          border: Border.all(color: colors.borderSecondary, width: 0.5),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Padding(
                padding: Spacing.tinyPadding,
                child: ClipRRect(
                  borderRadius: Spacing.smallBorderRadius,
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: Spacing.defaultPadding,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: FancyContainer(
                      color: context.colors.primary,
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
                    child: Text(
                      subtitle,
                      style: m16w600(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
