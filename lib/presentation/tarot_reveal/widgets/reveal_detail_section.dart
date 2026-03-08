part of '../pages/tarot_reveal_detail_page.dart';

/// Legacy section widget — still available for external usage
/// (e.g. TarotDataDetailPage in library).
class RevealDetailSection extends StatelessWidget {
  const RevealDetailSection({
    required this.title,
    required this.descriptions,
    required this.icon,
    required this.iconColor,
    super.key,
  });
  final String title;
  final List<String> descriptions;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: Spacing.largePadding,
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.5),
        borderRadius: Spacing.largeBorderRadius,
        border: Border.all(color: context.colors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, size: 18, color: iconColor),
                ),
              ),
              Spacing.smallW,
              Expanded(
                child: Text(
                  title,
                  style: m16w700(context),
                ),
              ),
            ],
          ),
          Spacing.mediumH,
          // Bullets
          ...descriptions.map(
            (description) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(icon, size: 18, color: iconColor),
                  ),
                  Spacing.smallW,
                  Expanded(
                    child: Text(
                      description,
                      style: m14w500(context).copyWith(
                        color: context.colors.textPrimary.withValues(alpha: 0.75),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
