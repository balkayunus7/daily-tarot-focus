import 'package:daily_tarot_focus/features/tarot/presentation/tarot_daily/helpers/daily_calendar_page_mixin.dart';
import 'package:flutter/widgets.dart';

class DailyCalendarPageScope extends InheritedWidget {
  const DailyCalendarPageScope({required this.state, required super.child, super.key});
  final DailyCalendarPageMixin state;

  static DailyCalendarPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<DailyCalendarPageScope>();
    assert(result != null, 'No CalendarPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DailyCalendarPageScope oldWidget) => false;
}
