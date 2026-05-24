import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_saved_readings_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/pages/tarot_reading_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

enum TarotReadingDateFilter {
  allTime,
  lastWeek,
  lastMonth,
  custom,
}

mixin ReadingPageMixin on State<TarotReadingPage> {
  late final ValueNotifier<TarotReadingDateFilter> selectedFilter;
  late final ValueNotifier<DateTimeRange?> customDateRange;

  @override
  void initState() {
    super.initState();
    selectedFilter = ValueNotifier(TarotReadingDateFilter.allTime);
    customDateRange = ValueNotifier(null);
  }

  @override
  void dispose() {
    selectedFilter.dispose();
    customDateRange.dispose();
    super.dispose();
  }

  void updateFilter(TarotReadingDateFilter filter, DateTimeRange? range) {
    selectedFilter.value = filter;
    customDateRange.value = range;
  }

  String get filterLabel {
    switch (selectedFilter.value) {
      case TarotReadingDateFilter.allTime:
        return LocaleKeys.tarot_reading_filter_all_time.tr();
      case TarotReadingDateFilter.lastWeek:
        return LocaleKeys.tarot_reading_filter_last_7_days.tr();
      case TarotReadingDateFilter.lastMonth:
        return LocaleKeys.tarot_reading_filter_last_month.tr();
      case TarotReadingDateFilter.custom:
        final range = customDateRange.value;
        if (range != null) {
          final start = range.start;
          final end = range.end;
          return '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}';
        }
        return LocaleKeys.tarot_reading_filter_custom.tr();
    }
  }

  List<SavedReadingModel> filteredReadings({
    required TarotReadingDateFilter filter,
    required List<SavedReadingModel> allReadings,
    required DateTimeRange? range,
  }) {
    final now = DateTime.now();
    var readings = allReadings;
    if (filter == TarotReadingDateFilter.lastWeek) {
      final lastWeek = now.subtract(const Duration(days: 7));
      readings = readings.where((r) => r.createdAt.isAfter(lastWeek)).toList();
    } else if (filter == TarotReadingDateFilter.lastMonth) {
      final lastMonth = DateTime(now.year, now.month - 1, now.day);
      readings = readings.where((r) => r.createdAt.isAfter(lastMonth)).toList();
    } else if (filter == TarotReadingDateFilter.custom && range != null) {
      final start = range.start;
      final end = range.end.add(const Duration(days: 1));
      readings =
          readings
              .where(
                (r) => r.createdAt.isAfter(start) && r.createdAt.isBefore(end),
              )
              .toList();
    }
    return readings;
  }

  void clearFilter() {
    selectedFilter.value = TarotReadingDateFilter.allTime;
    customDateRange.value = null;
  }
}
