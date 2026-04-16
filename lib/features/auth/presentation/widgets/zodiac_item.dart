part of '../pages/register_step_zodiac_page.dart';

class ZodiacItem extends StatelessWidget {
  const ZodiacItem({
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

    return ScalingContainer(
      onTap: onTap,
      child: GlassContainer(
        width: double.infinity,
        borderRadius: Sp.xlarge,
        glassColor:
            isSelected
                ? colors.primary.withValues(alpha: 0.2)
                : colors.primary.withValues(alpha: 0.05),
        borderColor: colors.primary.withValues(alpha: 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ZodiacContainer(zodiac: zodiac),
            12.heightBox,
            Text(
              zodiac.localizedName,
              style: m12w500(context).copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.3,
                color: isSelected ? colors.textPrimary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZodiacContainer extends StatelessWidget {
  const _ZodiacContainer({required this.zodiac});
  final ZodiacSign zodiac;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.gradientStart, colors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: 12.radiusR,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        zodiac.svgPath,
        width: 24.w,
        height: 24.w,
        colorFilter: ColorFilter.mode(colors.textOnPrimary, BlendMode.srcIn),
      ),
    );
  }
}
