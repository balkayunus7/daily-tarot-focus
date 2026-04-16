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

    return ScalingContainer(
      onTap: onTap,
      child: GlassContainer(
        padding: Sp.small.padSymR(h: Sp.large, v: Sp.small),
        borderRadius: Sp.medium,
        glassColor:
            isSelected
                ? colors.primary.withValues(alpha: 0.2)
                : colors.primary.withValues(alpha: 0.05),
        borderColor: colors.primary.withValues(alpha: 0.1),
        child: Row(
          children: [
            Text(status.emoji, style: m28w600(context)),
            Sp.medium.widthBox,
            Expanded(child: Text(status.localizedName, style: m15w600(context))),
            if (isSelected) ...[
              Sp.medium.widthBox,
              Icon(Icons.check_circle, color: colors.primary, size: Sp.xlarge),
            ],
          ],
        ),
      ),
    );
  }
}
