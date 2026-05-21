import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_daily/pages/tarot_daily_calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin DailyCalendarPageMixin on State<TarotDailyCalendarPage> {
  static const int initialPage = 1200;

  String _localeCode() => Localizations.localeOf(context).languageCode;
  String dayFormattedLabel(DateTime month) => DateFormat('MMMM yyyy', _localeCode()).format(month);
  String monthOnlyLabel(DateTime month) => DateFormat('MMMM', _localeCode()).format(month);
  String yearOnlyLabel(DateTime month) => DateFormat('yyyy', _localeCode()).format(month);

  // Returns Mon-first short weekday names in the current locale.
  List<String> get daysLabels {
    final locale = _localeCode();
    // 2024-01-01 is a Monday — iterate 7 days to get Mon..Sun.
    return List.generate(7, (i) => DateFormat.E(locale).format(DateTime(2024, 1, 1 + i)));
  }

  late final PageController pageController;
  final ValueNotifier<int> currentPage = ValueNotifier(initialPage);
  late final ValueNotifier<DateTime> selectedDate;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: initialPage);
    final now = DateTime.now();
    selectedDate = ValueNotifier(DateTime(now.year, now.month, now.day));
  }

  @override
  void dispose() {
    pageController.dispose();
    currentPage.dispose();
    selectedDate.dispose();
    super.dispose();
  }

  void selectDate(DateTime date) {
    selectedDate.value = DateTime(date.year, date.month, date.day);
  }

  bool isSelected(DateTime date) {
    final s = selectedDate.value;
    return s.year == date.year && s.month == date.month && s.day == date.day;
  }

  String dayLongLabel(DateTime date) =>
      DateFormat('d MMMM EEEE', _localeCode()).format(date);

  DateTime monthForPage(int page) {
    final now = DateTime.now();
    return DateTime(now.year, now.month + (page - initialPage));
  }

  Map<DateTime, DailyCardModel> buildCardMap(List<DailyCardModel> cards) {
    final map = <DateTime, DailyCardModel>{};
    for (final card in cards) {
      final key = DateTime(card.date.year, card.date.month, card.date.day);
      map[key] = card;
    }
    return map;
  }

  int daysInMonth(DateTime month) => DateTime(month.year, month.month + 1, 0).day;

  int cardsInMonth(DateTime month, Map<DateTime, DailyCardModel> cardMap) {
    var count = 0;
    final last = daysInMonth(month);
    for (var d = 1; d <= last; d++) {
      if (cardMap.containsKey(DateTime(month.year, month.month, d))) count++;
    }
    return count;
  }

  int currentStreak(Map<DateTime, DailyCardModel> cardMap) {
    if (cardMap.isEmpty) return 0;
    final now = DateTime.now();
    var cursor = DateTime(now.year, now.month, now.day);
    if (!cardMap.containsKey(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
      if (!cardMap.containsKey(cursor)) return 0;
    }
    var streak = 0;
    while (cardMap.containsKey(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  void goToPrev() => pageController.previousPage(
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeInOut,
  );

  void goToNext() => pageController.nextPage(
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeInOut,
  );
}
