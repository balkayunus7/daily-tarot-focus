import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/helpers/reading_page_mixin.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/pages/tarot_reading_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/bottom_sheets/core_bottom_sheet.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

mixin ReadingPageDateRangeSheet on State<TarotReadingPage> {
  ValueNotifier<TarotReadingDateFilter> get selectedFilter;
  ValueNotifier<DateTimeRange?> get customDateRange;
  void updateFilter(TarotReadingDateFilter filter, DateTimeRange? range);

  Future<void> showFilterBottomSheet() async {
    TarotReadingDateFilter? result;

    await showCoreBottomSheet(
      context,
      backgroundColor: context.colors.surface,
      buildWidget: (bottomSheetContext) {
        return Padding(
          padding: Sp.medium.padAllR,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.common_filter.tr(),
                  style: m18w700(bottomSheetContext),
                ),
                Sp.medium.heightBox,
                ListTile(
                  leading: const Icon(Icons.all_inclusive),
                  shape: RoundedRectangleBorder(
                    side:
                        selectedFilter.value == TarotReadingDateFilter.allTime
                            ? BorderSide(color: context.colors.border)
                            : BorderSide.none,
                    borderRadius: Sp.medium.radiusR,
                  ),
                  title: Text(LocaleKeys.tarot_daily_all_time.tr()),
                  onTap: () {
                    result = TarotReadingDateFilter.allTime;
                    Navigator.pop(bottomSheetContext);
                  },
                  selected: selectedFilter.value == TarotReadingDateFilter.allTime,
                  selectedColor: bottomSheetContext.colors.primary,
                ),
                Sp.xsmall.heightBox,
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        selectedFilter.value == TarotReadingDateFilter.lastWeek
                            ? BorderSide(color: context.colors.border)
                            : BorderSide.none,
                    borderRadius: Sp.medium.radiusR,
                  ),
                  leading: const Icon(Icons.view_week),
                  title: Text(LocaleKeys.tarot_daily_last_week.tr()),
                  onTap: () {
                    result = TarotReadingDateFilter.lastWeek;
                    Navigator.pop(bottomSheetContext);
                  },
                  selected: selectedFilter.value == TarotReadingDateFilter.lastWeek,
                  selectedColor: bottomSheetContext.colors.primary,
                ),
                Sp.xsmall.heightBox,
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        selectedFilter.value == TarotReadingDateFilter.lastMonth
                            ? BorderSide(color: context.colors.border)
                            : BorderSide.none,
                    borderRadius: Sp.medium.radiusR,
                  ),
                  leading: const Icon(Icons.calendar_month),
                  title: Text(LocaleKeys.tarot_daily_last_month.tr()),
                  onTap: () {
                    result = TarotReadingDateFilter.lastMonth;
                    Navigator.pop(bottomSheetContext);
                  },
                  selected: selectedFilter.value == TarotReadingDateFilter.lastMonth,
                  selectedColor: bottomSheetContext.colors.primary,
                ),
                Sp.xsmall.heightBox,
                ListTile(
                  shape: RoundedRectangleBorder(
                    side:
                        selectedFilter.value == TarotReadingDateFilter.custom
                            ? BorderSide(color: context.colors.border)
                            : BorderSide.none,
                    borderRadius: Sp.medium.radiusR,
                  ),
                  leading: const Icon(Icons.date_range),
                  title: Text(LocaleKeys.tarot_daily_custom_date.tr()),
                  onTap: () {
                    result = TarotReadingDateFilter.custom;
                    Navigator.pop(bottomSheetContext);
                  },
                  selected: selectedFilter.value == TarotReadingDateFilter.custom,
                  selectedColor: bottomSheetContext.colors.primary,
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;

    if (result != null) {
      if (result == TarotReadingDateFilter.custom) {
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
                  onSurfaceVariant: context.colors.textSecondary,
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
