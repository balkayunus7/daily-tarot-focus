part of '../pages/tarot_daily_calendar_page.dart';

class DayCell extends StatelessWidget {
  const DayCell({
    required this.date,
    required this.dailyCard,
    required this.isToday,
    required this.isSelected,
    super.key,
  });
  final DateTime date;
  final DailyCardModel? dailyCard;
  final bool isToday;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasCard = dailyCard != null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isPast = date.isBefore(today) && !isToday;
    final isFuture = date.isAfter(today);
    final radius = Sp.xsmall.radiusR;

    final style = _resolveStyle(
      colors: colors,
      hasCard: hasCard,
      isToday: isToday,
      isPast: isPast,
      isFuture: isFuture,
    );

    return GestureDetector(
      onTap: () => DailyCalendarPageScope.of(context).state.selectDate(date),
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    color: style.background,
                    gradient: style.gradient,
                    border: Border.all(
                      color: style.borderColor,
                      width: style.borderWidth,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: radius,
                    child:
                        hasCard
                            ? _CellCardImage(cardId: dailyCard!.cardId)
                            : Center(
                              child: style.emptyContent ?? const SizedBox.shrink(),
                            ),
                  ),
                ),
                if (isSelected )
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: radius,
                          border: Border.all(
                            color: colors.secondary.withValues(alpha: 0.6),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Sp.tiny.heightBox,
          Text(
            '${date.day}',
            textAlign: TextAlign.center,
            style: m10w600(context).copyWith(
              color: isSelected && !isToday ? colors.secondary : style.dayNumberColor,
              fontWeight: isSelected || isToday ? FontWeight.w700 : style.dayNumberWeight,
              fontSize: isToday || isSelected ? 11 : 10,
            ),
          ),
          const SizedBox(height: Sp.tiny),
        ],
      ),
    );
  }
}

class _CellCardImage extends StatelessWidget {
  const _CellCardImage({required this.cardId});
  final String cardId;

  @override
  Widget build(BuildContext context) {
    final tarotCard = context.read<TarotBloc>().state.getById(cardId);
    if (tarotCard == null) return const SizedBox.shrink();
    return SizedBox.expand(
      child: CustomCacheNetworkImage(
        imageUrl: tarotCard.imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class _CellStyle {
  const _CellStyle({
    required this.background,
    required this.gradient,
    required this.borderColor,
    required this.borderWidth,
    required this.emptyContent,
    required this.dayNumberColor,
    required this.dayNumberWeight,
  });

  final Color? background;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final Widget? emptyContent;
  final Color dayNumberColor;
  final FontWeight dayNumberWeight;
}

_CellStyle _resolveStyle({
  required AppColors colors,
  required bool hasCard,
  required bool isToday,
  required bool isPast,
  required bool isFuture,
}) {
  const double uniformBorder = 1;

  if (isToday && hasCard) {
    return _CellStyle(
      background: null,
      gradient: null,
      borderColor: colors.primary.withValues(alpha: 0.50),
      borderWidth: uniformBorder,
      emptyContent: null,
      dayNumberColor: colors.primary,
      dayNumberWeight: FontWeight.w700,
    );
  }

  // Today empty — invitation/CTA feel
  if (isToday) {
    return _CellStyle(
      background: null,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colors.primary.withValues(alpha: 0.18),
          colors.primary.withValues(alpha: 0.06),
        ],
      ),
      borderColor: colors.primary.withValues(alpha: 0.50),
      borderWidth: uniformBorder,
      emptyContent: Icon(
        Icons.auto_awesome,
        size: 20,
        color: colors.primary,
      ),
      dayNumberColor: colors.primary,
      dayNumberWeight: FontWeight.w700,
    );
  }

  // Past with card — clean
  if (hasCard && isPast) {
    return _CellStyle(
      background: null,
      gradient: null,
      borderColor: colors.primary.withValues(alpha: 0.50),
      borderWidth: uniformBorder,
      emptyContent: null,
      dayNumberColor: colors.textSecondary,
      dayNumberWeight: FontWeight.w600,
    );
  }

  // Future with card — rare, treat like past
  if (hasCard) {
    return _CellStyle(
      background: null,
      gradient: null,
      borderColor: colors.primary.withValues(alpha: 0.50),
      borderWidth: uniformBorder,
      emptyContent: null,
      dayNumberColor: colors.textSecondary,
      dayNumberWeight: FontWeight.w600,
    );
  }

  // Past empty — visible but quiet
  if (isPast) {
    return _CellStyle(
      background: Colors.transparent,
      gradient: null,
      borderColor: colors.primary.withValues(alpha: 0.25),
      borderWidth: uniformBorder,
      emptyContent: null,
      dayNumberColor: colors.textDisabled,
      dayNumberWeight: FontWeight.w500,
    );
  }

  // Future empty — anticipation
  return _CellStyle(
    background: colors.surfaceSecondary.withValues(alpha: 0.55),
    gradient: null,
    borderColor: colors.primary.withValues(alpha: 0.25),
    borderWidth: uniformBorder,
    emptyContent: Icon(
      Icons.auto_awesome_outlined,
      size: 12,
      color: colors.primary.withValues(alpha: 0.25),
    ),
    dayNumberColor: colors.textSecondary,
    dayNumberWeight: FontWeight.w500,
  );
}
