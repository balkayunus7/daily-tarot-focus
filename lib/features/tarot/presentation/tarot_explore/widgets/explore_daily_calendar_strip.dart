part of '../pages/tarot_explore_page.dart';

class ExploreDailyCalendarStrip extends StatelessWidget {
  const ExploreDailyCalendarStrip({super.key});

  List<DateTime> _currentWeekDays() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final daysFromMonday = today.weekday - 1;
    final monday = today.subtract(Duration(days: daysFromMonday));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weekDays = _currentWeekDays();

    return BlocBuilder<TarotBloc, TarotState>(
      builder: (context, state) {
        final cards = state.dailyCardsOrEmpty.asList();
        final cardSet = <DateTime>{};
        for (final card in cards) {
          cardSet.add(DateTime(card.date.year, card.date.month, card.date.day));
        }

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final cardsThisWeek = weekDays.where(cardSet.contains).length;

        return ScalingContainer(
          onTap: () => unawaited(context.push(AppRoutes.tarotDailyCalendar)),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: Sp.medium.radiusR,
              border: Border.all(color: colors.borderSecondary, width: 0.5),
            ),
            child: Row(
              children: [
                const _CalendarStripIcon(),
                Sp.medium.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocaleKeys.tarot_daily_calendar_title.tr(),
                        style: m13w600(context).copyWith(color: colors.textPrimary),
                      ),
                      SizedBox(height: 8.h),
                      _WeekDotRow(
                        weekDays: weekDays,
                        cardSet: cardSet,
                        today: today,
                      ),
                    ],
                  ),
                ),
                Sp.small.widthBox,
                _WeekCountChip(count: cardsThisWeek),
                SizedBox(width: 6.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
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

class _CalendarStripIcon extends StatelessWidget {
  const _CalendarStripIcon();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.gradientStart, colors.gradientEnd],
        ),
        borderRadius: Sp.small.radiusR,
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        Icons.calendar_month_rounded,
        size: 18,
        color: colors.textOnPrimary,
      ),
    );
  }
}

class _WeekDotRow extends StatelessWidget {
  const _WeekDotRow({
    required this.weekDays,
    required this.cardSet,
    required this.today,
  });
  final List<DateTime> weekDays;
  final Set<DateTime> cardSet;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: weekDays.map((day) {
        final hasCard = cardSet.contains(day);
        final isToday = day.isAtSameMomentAs(today);
        final isFuture = day.isAfter(today);
        final isLast = day == weekDays.last;
        return Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : 5.w),
          child: _DayDot(
            day: day,
            hasCard: hasCard,
            isToday: isToday,
            isFuture: isFuture,
          ),
        );
      }).toList(),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.day,
    required this.hasCard,
    required this.isToday,
    required this.isFuture,
  });
  final DateTime day;
  final bool hasCard;
  final bool isToday;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dotSize = 24.r;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: hasCard
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colors.gradientStart, colors.gradientEnd],
                  )
                : null,
            color: hasCard
                ? null
                : isToday
                    ? colors.primary.withValues(alpha: 0.12)
                    : colors.surfaceSecondary,
            border: Border.all(
              color: isToday && !hasCard
                  ? colors.primary.withValues(alpha: 0.55)
                  : hasCard
                      ? Colors.transparent
                      : colors.borderSecondary.withValues(alpha: isFuture ? 0.4 : 0.7),
              width: isToday && !hasCard ? 1.4 : 0.8,
            ),
            boxShadow: hasCard
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.28),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: hasCard
              ? Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 11,
                    color: colors.textOnPrimary,
                  ),
                )
              : isToday
                  ? Center(
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary,
                        ),
                      ),
                    )
                  : null,
        ),
        SizedBox(height: 3.h),
        Text(
          '${day.day}',
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
            color: isToday
                ? colors.primary
                : isFuture
                    ? colors.textDisabled
                    : hasCard
                        ? colors.textPrimary
                        : colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _WeekCountChip extends StatelessWidget {
  const _WeekCountChip({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count/7',
        style: m11w500(context).copyWith(
          color: colors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
