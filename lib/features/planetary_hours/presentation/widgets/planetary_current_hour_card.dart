part of '../pages/planetary_hours_page.dart';

class PlanetaryCurrentHourCard extends StatelessWidget {
  const PlanetaryCurrentHourCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = PlanetaryHoursPageScope.of(context).state;

    return ValueListenableBuilder(
      valueListenable: scope.schedule,
      builder: (context, sched, _) {
        return ValueListenableBuilder(
          valueListenable: scope.currentHourIndex,
          builder: (context, index, _) {
            if (sched == null || index < 1) return const SizedBox.shrink();
            final hour = sched.hours[index - 1];

            return Column(
              children: [
                _PlanetAvatar(ruler: hour.ruler),
                Sp.medium.heightBox,
                Text(
                  LocaleKeys.planetary_page_hour_of.tr(
                    args: [hour.ruler.localizedName],
                  ),
                  style: m24w700(context),
                  textAlign: TextAlign.center,
                ),
                Sp.xsmall.heightBox,
                Text(
                  hour.ruler.localizedMeaning,
                  style: m13w400(
                    context,
                  ).copyWith(color: colors.textSecondary, height: 1.45),
                  textAlign: TextAlign.center,
                ),
                Sp.medium.heightBox,
                const _CityChip(),
                Sp.medium.heightBox,
                Container(height: 1, color: colors.border),
                Sp.medium.heightBox,
                _HourProgress(hour: hour),
              ],
            );
          },
        );
      },
    );
  }
}

class _PlanetAvatar extends StatelessWidget {
  const _PlanetAvatar({required this.ruler});
  final PlanetaryRuler ruler;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      borderRadius: Sp.huge,
      width: 72.w,
      height: 72.h,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colors.gradientStart, colors.gradientEnd],
      ),
      child: Center(
        child: Text(
          ruler.glyph,
          style: TextStyle(
            fontSize: 34.sp,
            height: 1,
            color: colors.textOnPrimary,
          ),
        ),
      ),
    );
  }
}

class _HourProgress extends StatelessWidget {
  const _HourProgress({required this.hour});
  final PlanetaryHour hour;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = PlanetaryHoursPageScope.of(context).state;

    return ValueListenableBuilder(
      valueListenable: scope.now,
      builder: (context, now, _) {
        final total = hour.end.difference(hour.start).inSeconds;
        final elapsed = now.difference(hour.start).inSeconds;
        final progress = total <= 0 ? 0.0 : (elapsed / total).clamp(0.0, 1.0);
        final remaining = hour.end.difference(now);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${scope.formatTime(hour.start)} – '
                    '${scope.formatTime(hour.end)}',
                    style: m12w500(context).copyWith(
                      color: colors.textSecondary,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                Icon(
                  Icons.timer_outlined,
                  size: 13.sp,
                  color: colors.textSecondary,
                ),
                Sp.tiny.widthBox,
                Text(
                  LocaleKeys.planetary_page_remaining.tr(
                    args: [scope.formatCountdown(remaining)],
                  ),
                  style: m12w600(context).copyWith(
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            Sp.xsmall.heightBox,
            ClipRRect(
              borderRadius: Sp.xsmall.radiusR,
              child: LinearProgressIndicator(
                value: progress,
                minHeight: Sp.xsmall.h,
                backgroundColor: colors.primary.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(colors.secondary),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CityChip extends StatelessWidget {
  const _CityChip();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = PlanetaryHoursPageScope.of(context).state;

    return ValueListenableBuilder(
      valueListenable: scope.location,
      builder: (context, loc, _) {
        return ScalingContainer(
          onTap: () => unawaited(scope.pickCity()),
          child: FancyContainer(
            borderRadius: 100,
            padding: EdgeInsets.symmetric(
              horizontal: Sp.medium.w,
              vertical: Sp.xsmall.h,
            ),
            color: colors.textSecondary.withValues(alpha: 0.05),
            border: Border.all(color: colors.border),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14.sp,
                  color: colors.textSecondary,
                ),
                Sp.tiny.widthBox,
                Flexible(
                  child: Text(
                    loc?.name ?? '',
                    style: m12w600(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Sp.tiny.widthBox,
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16.sp,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
