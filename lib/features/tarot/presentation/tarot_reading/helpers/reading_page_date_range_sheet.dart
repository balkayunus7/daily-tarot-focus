import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/helpers/reading_page_mixin.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/bottom_sheets/core_bottom_sheet.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class DateRangeSheet {
  static Future<void> showFilterBottomSheet({
    required BuildContext context,
    required ValueNotifier<TarotReadingDateFilter> selectedFilter,
    required ValueNotifier<DateTimeRange?> customDateRange,
    required void Function(TarotReadingDateFilter filter, DateTimeRange? range) updateFilter,
  }) async {
    TarotReadingDateFilter? result;

    final allTimeLabelColor =
        selectedFilter.value == TarotReadingDateFilter.allTime
            ? context.colors.primary
            : context.colors.textTertiary;

    final lastWeekLabelColor =
        selectedFilter.value == TarotReadingDateFilter.lastWeek
            ? context.colors.primary
            : context.colors.textTertiary;

    final lastMonthLabelColor =
        selectedFilter.value == TarotReadingDateFilter.lastMonth
            ? context.colors.primary
            : context.colors.textTertiary;

    final customDateLabelColor =
        selectedFilter.value == TarotReadingDateFilter.custom
            ? context.colors.primary
            : context.colors.textTertiary;

    final allTimeBorderColor =
        selectedFilter.value == TarotReadingDateFilter.allTime
            ? BorderSide(color: context.colors.primary)
            : BorderSide.none;

    final lastWeekBorderColor =
        selectedFilter.value == TarotReadingDateFilter.lastWeek
            ? BorderSide(color: context.colors.primary)
            : BorderSide.none;

    final lastMonthBorderColor =
        selectedFilter.value == TarotReadingDateFilter.lastMonth
            ? BorderSide(color: context.colors.primary)
            : BorderSide.none;

    final customDateBorderColor =
        selectedFilter.value == TarotReadingDateFilter.custom
            ? BorderSide(color: context.colors.primary)
            : BorderSide.none;

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
                  leading: Icon(
                    Icons.all_inclusive,
                    color: allTimeLabelColor,
                  ),
                  shape: RoundedRectangleBorder(
                    side: allTimeBorderColor,
                    borderRadius: Sp.medium.radiusR,
                  ),
                  title: Text(
                    LocaleKeys.tarot_daily_all_time.tr(),
                    style: m16w400(bottomSheetContext).copyWith(color: allTimeLabelColor),
                  ),
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
                    side: lastWeekBorderColor,
                    borderRadius: Sp.medium.radiusR,
                  ),
                  leading: Icon(
                    Icons.view_week,
                    color: lastWeekLabelColor,
                  ),
                  title: Text(
                    LocaleKeys.tarot_daily_last_week.tr(),
                    style: m16w400(bottomSheetContext).copyWith(color: lastWeekLabelColor),
                  ),
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
                    side: lastMonthBorderColor,
                    borderRadius: Sp.medium.radiusR,
                  ),
                  leading: Icon(
                    Icons.calendar_month,
                    color: lastMonthLabelColor,
                  ),
                  title: Text(
                    LocaleKeys.tarot_daily_last_month.tr(),
                    style: m16w400(bottomSheetContext).copyWith(color: lastMonthLabelColor),
                  ),
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
                    side: customDateBorderColor,
                    borderRadius: Sp.medium.radiusR,
                  ),
                  leading: Icon(
                    Icons.date_range,
                    color: customDateLabelColor,
                  ),
                  title: Text(
                    LocaleKeys.tarot_daily_custom_date.tr(),
                    style: m16w400(bottomSheetContext).copyWith(color: customDateLabelColor),
                  ),
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

    if (!context.mounted) return;

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
