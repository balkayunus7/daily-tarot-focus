part of '../pages/tarot_daily_calendar_page.dart';

class _CalendarHero extends StatelessWidget {
  const _CalendarHero();

  @override
  Widget build(BuildContext context) {
    final scope = DailyCalendarPageScope.of(context).state;
    final colors = context.colors;

    return ValueListenableBuilder<int>(
      valueListenable: scope.currentPage,
      builder: (context, page, _) {
        final current = scope.monthForPage(page);

        return BlocBuilder<TarotBloc, TarotState>(
          builder: (context, state) {
            final cardMap = scope.buildCardMap(state.dailyCardsOrEmpty.asList());
            final totalDays = scope.daysInMonth(current);
            final cardsCount = scope.cardsInMonth(current, cardMap);
            final streak = scope.currentStreak(cardMap);
            final progress = totalDays > 0 ? cardsCount / totalDays : 0.0;

            return Container(
              margin: Sp.medium.padHR,
              padding: Sp.medium.padSymR(v: Sp.medium, h: Sp.large),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sp.medium.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.gradientStart,
                    colors.gradientEnd,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.30),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    top: -14,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 56,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          _HeroNavButton(
                            icon: Icons.chevron_left,
                            onTap: scope.goToPrev,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  scope.monthOnlyLabel(current),
                                  style: m20w800(context).copyWith(
                                    color: colors.textOnPrimary,
                                    letterSpacing: 0.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  scope.yearOnlyLabel(current),
                                  style: m11w500(context).copyWith(
                                    color: colors.textOnPrimary.withValues(alpha: 0.7),
                                    letterSpacing: 2.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          _HeroNavButton(
                            icon: Icons.chevron_right,
                            onTap: scope.goToNext,
                          ),
                        ],
                      ),
                      Sp.medium.heightBox,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.tarot_daily_calendar_cards_count.tr(
                                    namedArgs: {
                                      'count': '$cardsCount',
                                      'total': '$totalDays',
                                    },
                                  ),
                                  style: m13w600(context).copyWith(
                                    color: colors.textOnPrimary,
                                  ),
                                ),
                                Sp.xsmall.heightBox,
                                _HeroProgressBar(value: progress),
                              ],
                            ),
                          ),
                          if (streak >= 2) ...[
                            Sp.medium.widthBox,
                            _StreakChip(count: streak),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _HeroNavButton extends StatelessWidget {
  const _HeroNavButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colors.buttonOnGradient,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.22),
            width: 0.8,
          ),
        ),
        child: Icon(icon, size: 20, color: colors.buttonOnGradientText),
      ),
    );
  }
}

class _HeroProgressBar extends StatelessWidget {
  const _HeroProgressBar({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 6,
        backgroundColor: Colors.white.withValues(alpha: 0.18),
        valueColor: AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.92)),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.28),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 14,
            color: colors.textOnPrimary,
          ),
          const SizedBox(width: 4),
          Text(
            LocaleKeys.tarot_daily_calendar_streak.tr(
              namedArgs: {'count': '$count'},
            ),
            style: m11w500(context).copyWith(
              color: colors.textOnPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
