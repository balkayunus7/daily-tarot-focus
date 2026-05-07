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
    final radius = Sp.xsmall.radiusR;

    Color? backgroundColor = Colors.transparent;
    if (hasCard) {
      backgroundColor = null;
    } else if (isToday) {
      backgroundColor = colors.primary.withValues(alpha: 0.10);
    } else if (isPast) {
      backgroundColor = colors.primary.withValues(alpha: 0.04);
    }

    var borderColor = colors.borderSecondary.withValues(alpha: 0.22);
    if (isToday) {
      borderColor = colors.primary;
    } else if (hasCard) {
      borderColor = colors.primary.withValues(alpha: 0.55);
    } else if (isPast) {
      borderColor = colors.primary.withValues(alpha: 0.18);
    }

    var borderWidth = 0.7;
    if (isToday) {
      borderWidth = 1.8;
    } else if (hasCard) {
      borderWidth = 1.2;
    }

    return GestureDetector(
      onTap: hasCard ? () => context.push(AppRoutes.tarotDailyDetail, extra: card) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: radius,
                color: backgroundColor,
                border: Border.all(color: borderColor, width: borderWidth),
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: Builder(
                  builder: (context) {
                    if (hasCard) {
                      return CustomCacheNetworkImage(
                        imageUrl: card!.imageUrl,
                        fit: BoxFit.fitWidth,
                      );
                    } else {
                      return Center(
                        child: Text(
                          '✦',
                          style: m11w500(context).copyWith(
                            color: colors.primary.withValues(alpha: isToday ? 0.38 : 0.16),
                          ),
                        ),
                      );
                    }
                  },
                ),
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
          const SizedBox(height: Sp.tiny),
        ],
      ),
    );
  }
}
