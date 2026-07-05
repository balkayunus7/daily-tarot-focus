part of '../pages/planetary_hours_page.dart';

class PlanetaryInfoRow extends StatelessWidget {
  const PlanetaryInfoRow({required this.schedule, super.key});
  final PlanetaryHourSchedule schedule;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = PlanetaryHoursPageScope.of(context).state;

    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Row(
        children: [
          Expanded(
            child: _InfoCell(
              icon: Icons.wb_sunny_outlined,
              label: LocaleKeys.planetary_page_sunrise.tr(),
              value: scope.formatTime(schedule.sunrise),
            ),
          ),
          Container(width: 1, height: 44.h, color: colors.border),
          Expanded(
            child: _InfoCell(
              icon: Icons.nights_stay_outlined,
              label: LocaleKeys.planetary_page_sunset.tr(),
              value: scope.formatTime(schedule.sunset),
            ),
          ),
          Container(width: 1, height: 44.h, color: colors.border),
          Expanded(
            child: _InfoCell(
              glyph: schedule.dayRuler.glyph,
              glyphColor: schedule.dayRuler.accentColor,
              label: LocaleKeys.planetary_page_day_ruler.tr(),
              value: schedule.dayRuler.localizedName,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({
    required this.label,
    required this.value,
    this.icon,
    this.glyph,
    this.glyphColor,
  });
  final IconData? icon;
  final String? glyph;
  final Color? glyphColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sp.xsmall.w),
      child: Column(
        children: [
          if (glyph != null)
            Text(
              glyph!,
              style: TextStyle(
                fontSize: 16.sp,
                height: 1,
                color: glyphColor ?? colors.textPrimary,
              ),
            )
          else
            Icon(icon, size: 16.sp, color: colors.textSecondary),
          Sp.xsmall.heightBox,
          Text(
            value,
            style: m14w700(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Sp.tiny.heightBox,
          Text(
            label,
            style: m11w500(context).copyWith(color: colors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
