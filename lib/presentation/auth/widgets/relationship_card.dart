part of '../pages/register_step_relationship_page.dart';

class RelationshipCard extends StatelessWidget {
  const RelationshipCard({
    required this.status,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final RelationshipStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bgColor = isSelected ? colors.surfaceSecondary : colors.surface;
    final borderColor = isSelected ? colors.primary : colors.border;

    return ScalingContainer(
      onTap: onTap,
      child: Container(
        padding: Spacing.defaultPadding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: Spacing.defaultBorderRadius,
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Text(status.emoji, style: m28w600(context)),
            Spacing.mediumW,
            Expanded(child: Text(status.localizedName, style: m16w600(context))),
            if (isSelected) ...[
              Spacing.mediumW,
              Icon(
                Icons.check_circle,
                color: colors.primary,
                size: SpacingConsts.xlarge,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
