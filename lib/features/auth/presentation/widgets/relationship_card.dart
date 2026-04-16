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
        padding: Sp.screen.padAllR,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: Sp.medium.radiusR,
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Text(status.emoji, style: m28w600(context)),
            Sp.medium.widthBox,
            Expanded(child: Text(status.localizedName, style: m16w600(context))),
            if (isSelected) ...[
              Sp.medium.widthBox,
              Icon(
                Icons.check_circle,
                color: colors.primary,
                size: Sp.xlarge,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
