import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/presentation/tarot_daily/helpers/daily_page_mixin.dart';
import 'package:daily_tarot_focus/presentation/tarot_daily/page/tarot_daily_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/bottom_sheets/core_bottom_sheet.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

mixin DailyPageDateRangeSheet on State<TarotDailyPage> {
  ValueNotifier<TarotDailyDateFilter> get selectedFilter;
  ValueNotifier<DateTimeRange?> get customDateRange;
  void updateFilter(TarotDailyDateFilter filter, DateTimeRange? range);

  Future<void> showFilterBottomSheet() async {
    TarotDailyDateFilter? result;

    await showCoreBottomSheet(
      context,
      backgroundColor: context.colors.surface,
      buildWidget: (bottomSheetContext) {
        return Padding(
          padding: Spacing.xsmallPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filtrele',
                style: m18w700(bottomSheetContext),
              ),
              Spacing.mediumH,
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                shape: RoundedRectangleBorder(
                  side:
                      selectedFilter.value == TarotDailyDateFilter.allTime
                          ? BorderSide(color: context.colors.border)
                          : BorderSide.none,
                  borderRadius: Spacing.defaultBorderRadius,
                ),
                title: const Text('Tüm Zamanlar'),
                onTap: () {
                  result = TarotDailyDateFilter.allTime;
                  Navigator.pop(bottomSheetContext);
                },
                selected: selectedFilter.value == TarotDailyDateFilter.allTime,
                selectedColor: bottomSheetContext.colors.primary,
              ),
              Spacing.xsmallH,
              ListTile(
                shape: RoundedRectangleBorder(
                  side:
                      selectedFilter.value == TarotDailyDateFilter.lastWeek
                          ? BorderSide(color: context.colors.border)
                          : BorderSide.none,
                  borderRadius: Spacing.defaultBorderRadius,
                ),
                leading: const Icon(Icons.view_week),
                title: const Text('Son 1 Hafta'),
                onTap: () {
                  result = TarotDailyDateFilter.lastWeek;
                  Navigator.pop(bottomSheetContext);
                },
                selected: selectedFilter.value == TarotDailyDateFilter.lastWeek,
                selectedColor: bottomSheetContext.colors.primary,
              ),
              Spacing.xsmallH,
              ListTile(
                shape: RoundedRectangleBorder(
                  side:
                      selectedFilter.value == TarotDailyDateFilter.lastMonth
                          ? BorderSide(color: context.colors.border)
                          : BorderSide.none,
                  borderRadius: Spacing.defaultBorderRadius,
                ),
                leading: const Icon(Icons.calendar_month),
                title: const Text('Son 1 Ay'),
                onTap: () {
                  result = TarotDailyDateFilter.lastMonth;
                  Navigator.pop(bottomSheetContext);
                },
                selected: selectedFilter.value == TarotDailyDateFilter.lastMonth,
                selectedColor: bottomSheetContext.colors.primary,
              ),
              Spacing.xsmallH,
              ListTile(
                shape: RoundedRectangleBorder(
                  side:
                      selectedFilter.value == TarotDailyDateFilter.custom
                          ? BorderSide(color: context.colors.border)
                          : BorderSide.none,
                  borderRadius: Spacing.defaultBorderRadius,
                ),
                leading: const Icon(Icons.date_range),
                title: const Text('Tarih Seçimi'),
                onTap: () {
                  result = TarotDailyDateFilter.custom;
                  Navigator.pop(bottomSheetContext);
                },
                selected: selectedFilter.value == TarotDailyDateFilter.custom,
                selectedColor: bottomSheetContext.colors.primary,
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) return;

    if (result != null) {
      if (result == TarotDailyDateFilter.custom) {
        final dateRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: customDateRange.value,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: context.colors.primary,
                  onPrimary: context.colors.textPrimary,
                  surface: context.colors.surface,
                  onSurface: context.colors.textPrimary,
                  onSurfaceVariant: context.colors.textPrimary.withValues(alpha: 0.7),
                ),
                scaffoldBackgroundColor: context.colors.surface,
                appBarTheme: AppBarTheme(
                  backgroundColor: context.colors.surface,
                  foregroundColor: context.colors.textPrimary,
                ),
              ),
              child: child!,
            );
          },
        );

        if (dateRange != null) {
          updateFilter(result!, dateRange);
        }
      } else {
        updateFilter(result!, null);
      }
    }
  }
}
