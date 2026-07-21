part of '../pages/tarot_explore_page.dart';

/// First Explore tab, built entirely around Planetary Hours:
///  - the live current-hour card,
///  - a Best Time Planner (pick an activity, get the planetary hours that
///    best suit it today),
///  - a full-day timeline of every planetary hour.
/// All computed on-device from the day's real sunrise/sunset schedule.
class ExplorePlanetaryHoursTab extends StatefulWidget {
  const ExplorePlanetaryHoursTab({super.key});

  @override
  State<ExplorePlanetaryHoursTab> createState() => _ExplorePlanetaryHoursTabState();
}

class _ExplorePlanetaryHoursTabState extends State<ExplorePlanetaryHoursTab>
    with PlanetaryHoursPageMixin<ExplorePlanetaryHoursTab> {
  final ValueNotifier<PlanetaryActivity> _activity = ValueNotifier<PlanetaryActivity>(
    PlanetaryActivity.study,
  );

  @override
  void dispose() {
    _activity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlanetaryHoursPageScope(
      state: this,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ExplorePlanetaryHoursCard(),
          Sp.medium.heightBox,
          ValueListenableBuilder(
            valueListenable: location,
            builder: (context, loc, _) {
              if (loc == null) return const PlanetaryEmptyView();

              return ValueListenableBuilder(
                valueListenable: schedule,
                builder: (context, sched, _) {
                  if (sched == null) {
                    return Padding(
                      padding: EdgeInsets.only(top: Sp.xxxlarge.h),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BestTimePlanner(
                        schedule: sched,
                        activity: _activity,
                        formatTime: formatTime,
                      ),
                      Sp.large.heightBox,
                      Text(
                        LocaleKeys.planetary_page_timeline_title.tr(),
                        style: m15w600(context),
                      ),
                      Sp.small.heightBox,
                      _PlanetaryTimeline(
                        schedule: sched,
                        currentHourIndex: currentHourIndex,
                        formatTime: formatTime,
                        onRulerTap: _showPlanetDetails,
                      ),
                      Sp.medium.heightBox,
                      Center(
                        child: Text(
                          LocaleKeys.planetary_page_computed_note.tr(
                            args: [loc.name],
                          ),
                          style: m11w400(context).copyWith(
                            color: context.colors.textSecondary.withValues(
                              alpha: 0.6,
                            ),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showPlanetDetails(PlanetaryRuler ruler) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Sp.xlarge)),
      ),
      builder: (_) => _PlanetDetailsSheet(ruler: ruler),
    );
  }
}

/// Pick an activity, see the planet that rules it and every hour today that
/// is a good time for it — the next upcoming one highlighted.
class _BestTimePlanner extends StatelessWidget {
  const _BestTimePlanner({
    required this.schedule,
    required this.activity,
    required this.formatTime,
  });

  final PlanetaryHourSchedule schedule;
  final ValueNotifier<PlanetaryActivity> activity;
  final String Function(DateTime) formatTime;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      width: double.infinity,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      borderRadius: Sp.large,
      padding: Sp.medium.padAllR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_outlined,
                size: 16.sp,
                color: colors.primary,
              ),
              Sp.tiny.widthBox,
              Text(
                LocaleKeys.planetary_page_planner_title.tr(),
                style: m14w700(context),
              ),
            ],
          ),
          Sp.xsmall.heightBox,
          Text(
            LocaleKeys.planetary_page_planner_question.tr(),
            style: m12w400(context).copyWith(color: colors.textSecondary),
          ),
          Sp.small.heightBox,
          ValueListenableBuilder(
            valueListenable: activity,
            builder: (context, selected, _) {
              return Column(
                children: [
                  SizedBox(
                    height: 34.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: PlanetaryActivity.values.length,
                      separatorBuilder: (_, _) => Sp.xsmall.widthBox,
                      itemBuilder: (context, index) {
                        final item = PlanetaryActivity.values[index];
                        return _ActivityChip(
                          activity: item,
                          isSelected: item == selected,
                          onTap: () => activity.value = item,
                        );
                      },
                    ),
                  ),
                  Sp.medium.heightBox,
                  _PlannerResult(
                    activity: selected,
                    schedule: schedule,
                    formatTime: formatTime,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActivityChip extends StatelessWidget {
  const _ActivityChip({
    required this.activity,
    required this.isSelected,
    required this.onTap,
  });

  final PlanetaryActivity activity;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: Sp.small.w),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [colors.gradientStart, colors.gradientEnd],
                  )
                  : null,
          color: isSelected ? null : colors.background,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? Colors.transparent : colors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              activity.icon,
              size: 15.sp,
              color: isSelected ? colors.textOnPrimary : colors.textSecondary,
            ),
            Sp.tiny.widthBox,
            Text(
              activity.localizedLabel,
              style: m12w600(context).copyWith(
                color: isSelected ? colors.textOnPrimary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlannerResult extends StatelessWidget {
  const _PlannerResult({
    required this.activity,
    required this.schedule,
    required this.formatTime,
  });

  final PlanetaryActivity activity;
  final PlanetaryHourSchedule schedule;
  final String Function(DateTime) formatTime;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ruler = activity.ruler;
    final now = DateTime.now();

    final todaysHours = schedule.hours.where((h) => h.ruler == ruler).toList();
    final upcoming = todaysHours.where((h) => h.end.isAfter(now)).toList();
    final best = upcoming.isNotEmpty ? upcoming.first : null;
    final accent = ruler.accentColor;

    return Container(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      decoration: BoxDecoration(
        borderRadius: Sp.medium.radiusR,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.16),
            accent.withValues(alpha: 0.06),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 46.r,
            height: 46.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.16),
              border: Border.all(color: accent.withValues(alpha: 0.4)),
            ),
            child: Text(
              ruler.glyph,
              style: TextStyle(fontSize: 22.sp, height: 1, color: accent),
            ),
          ),
          Sp.small.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.planetary_page_planner_best_today.tr(),
                  style: m11w400(context).copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                Sp.tiny.heightBox,
                Text(
                  LocaleKeys.planetary_page_hour_of.tr(
                    args: [ruler.localizedName],
                  ),
                  style: m14w700(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Sp.tiny.heightBox,
                Text(
                  best != null
                      ? '${formatTime(best.start)} – ${formatTime(best.end)}'
                      : LocaleKeys.planetary_page_planner_no_upcoming.tr(),
                  style: m12w600(context).copyWith(
                    color: best != null ? colors.textPrimary : colors.textSecondary,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          Sp.small.widthBox,
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Sp.small.w,
              vertical: Sp.tiny.h,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: accent.withValues(alpha: 0.4)),
            ),
            child: Text(
              LocaleKeys.planetary_page_planner_hours_today.tr(
                args: ['${todaysHours.length}'],
              ),
              style: m10w600(context).copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Every planetary hour of the day in order, each with a duration-proportional
/// bar; the running hour is highlighted. Tapping a row opens the planet's
/// details.
class _PlanetaryTimeline extends StatelessWidget {
  const _PlanetaryTimeline({
    required this.schedule,
    required this.currentHourIndex,
    required this.formatTime,
    required this.onRulerTap,
  });

  final PlanetaryHourSchedule schedule;
  final ValueNotifier<int> currentHourIndex;
  final String Function(DateTime) formatTime;
  final Future<void> Function(PlanetaryRuler) onRulerTap;

  @override
  Widget build(BuildContext context) {
    final maxSeconds = schedule.hours
        .map((h) => h.end.difference(h.start).inSeconds)
        .fold<int>(1, (a, b) => b > a ? b : a);

    return ValueListenableBuilder(
      valueListenable: currentHourIndex,
      builder: (context, currentIndex, _) {
        return Column(
          children: [
            for (final hour in schedule.hours)
              Padding(
                padding: EdgeInsets.only(bottom: Sp.small.h),
                child: _TimelineRow(
                  hour: hour,
                  isCurrent: hour.index == currentIndex,
                  fraction: hour.end.difference(hour.start).inSeconds / maxSeconds,
                  formatTime: formatTime,
                  onTap: () => unawaited(onRulerTap(hour.ruler)),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.hour,
    required this.isCurrent,
    required this.fraction,
    required this.formatTime,
    required this.onTap,
  });

  final PlanetaryHour hour;
  final bool isCurrent;
  final double fraction;
  final String Function(DateTime) formatTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = hour.ruler.accentColor;

    return ScalingContainer(
      onTap: onTap,
      child: FancyContainer(
        width: double.infinity,
        borderRadius: Sp.large,
        padding: EdgeInsets.symmetric(
          horizontal: Sp.medium.w,
          vertical: Sp.small.h,
        ),
        color:
            isCurrent
                ? colors.primary.withValues(alpha: 0.08)
                : colors.textSecondary.withValues(alpha: 0.05),
        border: Border.all(
          color: isCurrent ? colors.primary.withValues(alpha: 0.55) : colors.border,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 44.w,
              child: Text(
                formatTime(hour.start),
                style: m12w600(context).copyWith(
                  color: isCurrent ? colors.textPrimary : colors.textSecondary,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ),
            Container(
              width: 34.w,
              height: 34.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.12),
              ),
              child: Text(
                hour.ruler.glyph,
                style: TextStyle(fontSize: 15.sp, height: 1, color: accent),
              ),
            ),
            Sp.small.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hour.ruler.localizedName,
                          style: m13w600(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        hour.isDaylight ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
                        size: 12.sp,
                        color: colors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: fraction.clamp(0.08, 1.0),
                      minHeight: 4.h,
                      backgroundColor: colors.primary.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        accent.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isCurrent) ...[
              Sp.small.widthBox,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Sp.small.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                    colors: [colors.gradientStart, colors.gradientEnd],
                  ),
                ),
                child: Text(
                  LocaleKeys.planetary_page_now.tr(),
                  style: m10w700(context).copyWith(color: colors.textOnPrimary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Planet reference: glyph, name, meaning and the activities it is a good
/// time for (reverse-mapped from the Best Time Planner).
class _PlanetDetailsSheet extends StatelessWidget {
  const _PlanetDetailsSheet({required this.ruler});

  final PlanetaryRuler ruler;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = ruler.accentColor;
    final activities = PlanetaryActivity.forRuler(ruler);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Sp.screen.w,
        Sp.large.h,
        Sp.screen.w,
        Sp.xxxlarge.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.14),
              border: Border.all(color: accent.withValues(alpha: 0.4)),
            ),
            child: Text(
              ruler.glyph,
              style: TextStyle(fontSize: 30.sp, height: 1, color: accent),
            ),
          ),
          Sp.medium.heightBox,
          Text(ruler.localizedName, style: m18w700(context)),
          Sp.small.heightBox,
          Text(
            ruler.localizedMeaning,
            textAlign: TextAlign.center,
            style: m13w400(context).copyWith(
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
          if (activities.isNotEmpty) ...[
            Sp.large.heightBox,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                LocaleKeys.planetary_page_good_for.tr(),
                style: m13w600(context),
              ),
            ),
            Sp.small.heightBox,
            Wrap(
              spacing: Sp.xsmall.w,
              runSpacing: Sp.xsmall.h,
              children: [
                for (final activity in activities)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sp.small.w,
                      vertical: Sp.xsmall.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.textSecondary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          activity.icon,
                          size: 14.sp,
                          color: accent,
                        ),
                        Sp.tiny.widthBox,
                        Text(
                          activity.localizedLabel,
                          style: m12w500(context),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
