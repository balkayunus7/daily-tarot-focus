part of '../pages/register_step_zodiac_page.dart';

class ZodiacCard extends StatelessWidget {
  const ZodiacCard({
    required this.zodiac,
    required this.isSelected,
    required this.onTap,
    super.key,
  });
  final ZodiacSign zodiac;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textColor = isSelected ? colors.primary : colors.textPrimary;
    final borderColor = isSelected ? colors.primary : colors.border;
    final bgColor = isSelected ? colors.surfaceSecondary : colors.surface;

    return ScalingContainer(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: Sp.screen.padAllR,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: Sp.medium.radiusR,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(zodiac.emoji, style: m32w600(context)),
            Sp.xsmall.heightBox,
            Text(
              zodiac.localizedName,
              style: m12w600(context).copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
