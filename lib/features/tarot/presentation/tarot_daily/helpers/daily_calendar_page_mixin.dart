import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_daily/pages/tarot_daily_calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin DailyCalendarPageMixin on State<TarotDailyCalendarPage> {
  static const int initialPage = 1200;

  String _localeCode() => Localizations.localeOf(context).languageCode;
  String dayFormattedLabel(DateTime month) => DateFormat('MMMM yyyy', _localeCode()).format(month);

  // Returns Mon-first short weekday names in the current locale.
  List<String> get daysLabels {
    final locale = _localeCode();
    // 2024-01-01 is a Monday — iterate 7 days to get Mon..Sun.
    return List.generate(7, (i) => DateFormat.E(locale).format(DateTime(2024, 1, 1 + i)));
  }

  late final PageController pageController;
  final ValueNotifier<int> currentPage = ValueNotifier(initialPage);

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    pageController.dispose();
    currentPage.dispose();
    super.dispose();
  }

  DateTime monthForPage(int page) {
    final now = DateTime.now();
    return DateTime(now.year, now.month + (page - initialPage));
  }

  Map<DateTime, TarotCardModel> buildCardMap(List<TarotCardModel> cards) {
    final map = <DateTime, TarotCardModel>{};
    for (final card in cards) {
      if (card.savedAt != null) {
        final key = DateTime(card.savedAt!.year, card.savedAt!.month, card.savedAt!.day);
        map[key] = card;
      }
    }
    return map;
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
