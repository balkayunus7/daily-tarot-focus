part of '../pages/planetary_hours_page.dart';

class PlanetaryHoursList extends StatelessWidget {
  const PlanetaryHoursList({required this.hours, super.key});
  final List<PlanetaryHour> hours;

  @override
  Widget build(BuildContext context) {
    final scope = PlanetaryHoursPageScope.of(context).state;

    return ValueListenableBuilder(
      valueListenable: scope.currentHourIndex,
      builder: (context, currentIndex, _) {
        return Column(
          children: [
            for (final hour in hours)
              Padding(
                padding: EdgeInsets.only(bottom: Sp.small.h),
                child: _HourTile(
                  hour: hour,
                  isCurrent: hour.index == currentIndex,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _HourTile extends StatelessWidget {
  const _HourTile({required this.hour, required this.isCurrent});
  final PlanetaryHour hour;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = PlanetaryHoursPageScope.of(context).state;
    final accent = hour.ruler.accentColor;

    return FancyContainer(
      width: double.infinity,
      borderRadius: Sp.large,
      padding: EdgeInsets.symmetric(
        horizontal: Sp.medium.w,
        vertical: Sp.small.h,
      ),
      color: isCurrent
          ? colors.primary.withValues(alpha: 0.08)
          : colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(
        color: isCurrent
            ? colors.primary.withValues(alpha: 0.55)
            : colors.border,
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.12),
            ),
            child: Text(
              hour.ruler.glyph,
              style: TextStyle(fontSize: 16.sp, height: 1, color: accent),
            ),
          ),
          Sp.small.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hour.ruler.localizedName, style: m14w600(context)),
                Sp.tiny.heightBox,
                Text(
                  hour.ruler.localizedMeaning,
                  style: m11w400(
                    context,
                  ).copyWith(color: colors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Sp.small.widthBox,
          if (isCurrent) ...[
            FancyContainer(
              borderRadius: 100,
              padding: EdgeInsets.symmetric(
                horizontal: Sp.small.w,
                vertical: 3.h,
              ),
              gradient: LinearGradient(
                colors: [colors.gradientStart, colors.gradientEnd],
              ),
              child: Text(
                LocaleKeys.planetary_page_now.tr(),
                style: m10w700(
                  context,
                ).copyWith(color: colors.textOnPrimary),
              ),
            ),
            Sp.small.widthBox,
          ],
          Text(
            '${scope.formatTime(hour.start)} – ${scope.formatTime(hour.end)}',
            style: m12w500(context).copyWith(
              color: isCurrent ? colors.textPrimary : colors.textSecondary,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
