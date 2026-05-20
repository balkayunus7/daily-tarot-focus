part of '../pages/tarot_daily_calendar_page.dart';

class DayGrid extends StatelessWidget {
  const DayGrid({required this.month, required this.cardMap, super.key});
  final DateTime month;
  final Map<DateTime, DailyCardModel> cardMap;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month);
    final startOffset = firstDay.weekday - 1;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final totalCells = startOffset + daysInMonth;

    return GridView.builder(
      padding: Sp.xlarge.padHR,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        childAspectRatio: 0.52,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final day = index - startOffset + 1;

        if (day < 1 || day > daysInMonth) return const SizedBox.shrink();

        final date = DateTime(month.year, month.month, day);

        return DayCell(
          date: date,
          dailyCard: cardMap[date],
          isToday: _isToday(date),
        );
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
