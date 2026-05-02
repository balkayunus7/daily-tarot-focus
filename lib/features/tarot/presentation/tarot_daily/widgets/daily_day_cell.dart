part of '../pages/tarot_daily_calendar_page.dart';

class DayCell extends StatelessWidget {
  const DayCell({required this.date, required this.card, required this.isToday, super.key});
  final DateTime date;
  final TarotCardModel? card;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasCard = card != null;
    final now = DateTime.now();
    final isPast = date.isBefore(DateTime(now.year, now.month, now.day)) && !isToday;
    const radius = BorderRadius.all(Radius.circular(8));

    return GestureDetector(
      onTap: hasCard ? () => context.push(AppRoutes.tarotDailyDetail, extra: card) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: radius,
                color:
                    hasCard
                        ? null
                        : isToday
                        ? colors.primary.withValues(alpha: 0.10)
                        : isPast
                        ? colors.primary.withValues(alpha: 0.04)
                        : Colors.transparent,
                border: Border.all(
                  color:
                      isToday
                          ? colors.primary
                          : hasCard
                          ? colors.primary.withValues(alpha: 0.55)
                          : isPast
                          ? colors.primary.withValues(alpha: 0.18)
                          : colors.borderSecondary.withValues(alpha: 0.22),
                  width:
                      isToday
                          ? 1.8
                          : hasCard
                          ? 1.2
                          : 0.7,
                ),
              ),
              child: ClipRRect(
                borderRadius: radius,
                child:
                    hasCard
                        ? CustomCacheNetworkImage(imageUrl: card!.imageUrl, fit: BoxFit.fitWidth)
                        : (isPast || isToday)
                        ? Center(
                          child: Text(
                            '✦',
                            style: m11w500(context).copyWith(
                              color: colors.primary.withValues(alpha: isToday ? 0.38 : 0.16),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ),
          Sp.tiny.heightBox,
          Text(
            '${date.day}',
            textAlign: TextAlign.center,
            style: m10w600(context).copyWith(
              color: isToday ? colors.primary : colors.textSecondary,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}
