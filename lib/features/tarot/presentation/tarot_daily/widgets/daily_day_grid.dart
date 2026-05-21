part of '../pages/tarot_daily_calendar_page.dart';

class DayGrid extends StatelessWidget {
  const DayGrid({required this.month, required this.cardMap, super.key});
  final DateTime month;
  final Map<DateTime, DailyCardModel> cardMap;

  static const double _cellSpacingH = 8;
  static const double _rowSpacingV = 8;
  static const double _cellAspectRatio = 0.55;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month);
    final startOffset = firstDay.weekday - 1;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final totalCells = startOffset + daysInMonth;
    final rowCount = (totalCells / 7).ceil();
    final scope = DailyCalendarPageScope.of(context).state;

    return ValueListenableBuilder<DateTime>(
      valueListenable: scope.selectedDate,
      builder: (context, selected, _) {
        return SingleChildScrollView(
          padding: Sp.large.padHR,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(rowCount, (rowIndex) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: rowIndex == rowCount - 1 ? 0 : _rowSpacingV.h,
                ),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(
                        7,
                        (colIndex) {
                          final cellIndex = rowIndex * 7 + colIndex;
                          final day = cellIndex - startOffset + 1;
                          final isValid = day >= 1 && day <= daysInMonth;
                          final cellDate = isValid ? DateTime(month.year, month.month, day) : null;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: _cellSpacingH / 2),
                              child: AspectRatio(
                                aspectRatio: _cellAspectRatio,
                                child:
                                    isValid
                                        ? DayCell(
                                          date: cellDate!,
                                          dailyCard: cardMap[cellDate],
                                          isToday: _isToday(cellDate),
                                          isSelected: _isSameDay(cellDate, selected),
                                        )
                                        : const SizedBox.shrink(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
