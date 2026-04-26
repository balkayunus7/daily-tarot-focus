part of '../pages/register_step_relationship_page.dart';

class RelationshipItem extends StatelessWidget {
  const RelationshipItem({
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
      child: FancyContainer(
        padding: Sp.small.padSymR(h: Sp.large, v: Sp.small),
        color:
            isSelected
                ? colors.primary.withValues(alpha: 0.4)
                : colors.primary.withValues(alpha: 0.08),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.gradientStart, colors.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: Sp.small.radiusR,
              ),
              alignment: Alignment.center,
              child: Iconify(status.icon, color: colors.accent, size: Sp.large),
            ),
            Sp.medium.widthBox,
            Expanded(
              child: Text(
                status.localizedName,
                style: m15w600(context).copyWith(color: isSelected ? colors.textOnPrimary : null),
              ),
            ),
            if (isSelected) ...[
              Sp.medium.widthBox,
              Iconify(Mdi.check_circle, color: colors.textOnPrimary),
            ],
          ],
        ),
      ),
    );
  }
}
