import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:daily_tarot_focus/presentation/tarot_daily/page/tarot_daily_page.dart';
import 'package:flutter/material.dart';

enum TarotDailyDateFilter {
  allTime,
  lastWeek,
  lastMonth,
  custom,
}

mixin DailyPageMixin on State<TarotDailyPage> {
  late final ValueNotifier<TarotDailyDateFilter> selectedFilter;
  late final ValueNotifier<DateTimeRange?> customDateRange;

  @override
  void initState() {
    super.initState();
    selectedFilter = ValueNotifier(TarotDailyDateFilter.allTime);
    customDateRange = ValueNotifier(null);
  }

  @override
  void dispose() {
    selectedFilter.dispose();
    customDateRange.dispose();
    super.dispose();
  }

  void updateFilter(TarotDailyDateFilter filter, DateTimeRange? range) {
    selectedFilter.value = filter;
    customDateRange.value = range;
  }

  String get filterLabel {
    switch (selectedFilter.value) {
      case TarotDailyDateFilter.allTime:
        return 'Tüm Zamanlar';
      case TarotDailyDateFilter.lastWeek:
        return 'Son 1 Hafta';
      case TarotDailyDateFilter.lastMonth:
        return 'Son 1 Ay';
      case TarotDailyDateFilter.custom:
        final range = customDateRange.value;
        if (range != null) {
          final start = range.start;
          final end = range.end;
          return '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}';
        }
        return 'Tarih Seçimi';
    }
  }

  List<TarotCard> filteredCards({
    required TarotDailyDateFilter filter,
    required List<TarotCard> allCards,
    required DateTimeRange<DateTime>? range,
  }) {
    final now = DateTime.now();
    var cards = allCards;

    if (filter == TarotDailyDateFilter.lastWeek) {
      final lastWeek = now.subtract(const Duration(days: 7));
      cards = cards.where((c) => c.savedAt != null && c.savedAt!.isAfter(lastWeek)).toList();
    } else if (filter == TarotDailyDateFilter.lastMonth) {
      final lastMonth = DateTime(now.year, now.month - 1, now.day);
      cards = cards.where((c) => c.savedAt != null && c.savedAt!.isAfter(lastMonth)).toList();
    } else if (filter == TarotDailyDateFilter.custom && range != null) {
      final start = range.start;
      final end = range.end.add(const Duration(days: 1));
      cards =
          cards.where((card) {
            return card.savedAt != null &&
                card.savedAt!.isAfter(start) &&
                card.savedAt!.isBefore(end);
          }).toList();
    }
    return cards;
  }

  void clearFilter() {
    selectedFilter.value = TarotDailyDateFilter.allTime;
    customDateRange.value = null;
  }
}
