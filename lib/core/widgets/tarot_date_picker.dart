import 'dart:math' as math;

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotDatePicker {
  const TarotDatePicker._();

  static Future<DateTime?> showDate({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initialDate,
  }) {
    final selectedDate = _clampDate(
      initialDate ?? DateTime.now(),
      firstDate,
      lastDate,
    );

    return showDialog<DateTime>(
      context: context,
      barrierColor: context.colors.overlay,
      builder:
          (_) => _SpinnerPickerDialog(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: selectedDate,
            minDateTime: firstDate,
            maxDateTime: lastDate,
          ),
    );
  }

  static Future<TimeOfDay?> showTime({
    required BuildContext context,
    TimeOfDay? initialTime,
  }) async {
    final now = DateTime.now();
    final time = initialTime ?? const TimeOfDay(hour: 12, minute: 0);
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final picked = await showDialog<DateTime>(
      context: context,
      barrierColor: context.colors.overlay,
      builder:
          (_) => _SpinnerPickerDialog(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: selectedDateTime,
          ),
    );

    if (picked == null) return null;

    return TimeOfDay(hour: picked.hour, minute: picked.minute);
  }

  static Future<DateTimeRange?> showDateRange({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTimeRange? initialDateRange,
  }) {
    final selectedRange = _clampRange(initialDateRange, firstDate, lastDate);
    final displayedDate = selectedRange?.start ?? _clampDate(DateTime.now(), firstDate, lastDate);
    final pickerSize = _pickerSize(context);

    return showRangePickerDialog(
      context: context,
      minDate: firstDate,
      maxDate: lastDate,
      selectedRange: selectedRange,
      displayedDate: displayedDate,
      currentDate: DateTime.now(),
      width: pickerSize.width,
      height: pickerSize.height,
      padding: EdgeInsets.symmetric(horizontal: Sp.large.w),
      contentPadding: EdgeInsets.all(Sp.medium.r),
      barrierColor: context.colors.overlay,
      theme: _theme(context),
    );
  }

  static Size _pickerSize(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);
    final width = math.min(mediaSize.width - (Sp.large.w * 2), 360).toDouble();
    final height = mediaSize.height < 520 ? 340.0 : 420.0;

    return Size(width, height);
  }

  static DateTime _clampDate(
    DateTime value,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    final date = DateUtils.dateOnly(value);
    final minDate = DateUtils.dateOnly(firstDate);
    final maxDate = DateUtils.dateOnly(lastDate);

    if (date.isBefore(minDate)) return minDate;
    if (date.isAfter(maxDate)) return maxDate;

    return date;
  }

  static DateTimeRange? _clampRange(
    DateTimeRange? value,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    if (value == null) return null;

    final start = _clampDate(value.start, firstDate, lastDate);
    final end = _clampDate(value.end, firstDate, lastDate);

    if (end.isBefore(start)) {
      return DateTimeRange(start: end, end: start);
    }

    return DateTimeRange(start: start, end: end);
  }

  static DatePickerPlusTheme _theme(BuildContext context) {
    final colors = context.colors;
    final cellTextStyle = m14w600(context);
    final disabledTextStyle = cellTextStyle.copyWith(
      color: colors.textDisabled,
    );
    final selectedTextStyle = cellTextStyle.copyWith(
      color: colors.textOnPrimary,
    );
    final currentDecoration = BoxDecoration(
      border: Border.all(color: colors.primary),
      shape: BoxShape.circle,
    );
    final selectedDecoration = BoxDecoration(
      color: colors.primary,
      shape: BoxShape.circle,
    );
    final selectedRangeDecoration = BoxDecoration(
      color: colors.primary.withValues(alpha: 0.16),
    );
    final selectedEdgeDecoration = BoxDecoration(
      color: colors.primary,
      borderRadius: BorderRadius.circular(999),
    );

    return DatePickerPlusTheme(
      headerTheme: HeaderTheme(
        centerLeadingDate: true,
        leadingDateTextStyle: m16w700(
          context,
        ).copyWith(color: colors.textPrimary),
        forwardArrowWidget: Icon(
          Icons.chevron_right_rounded,
          color: colors.primary,
        ),
        backwardArrowWidget: Icon(
          Icons.chevron_left_rounded,
          color: colors.primary,
        ),
        forwardButtonDecoration: ShapeDecoration(
          color: colors.primary.withValues(alpha: 0.10),
          shape: const CircleBorder(),
        ),
        backwardButtonDecoration: ShapeDecoration(
          color: colors.primary.withValues(alpha: 0.10),
          shape: const CircleBorder(),
        ),
        headerPadding: EdgeInsets.only(bottom: Sp.small.h),
      ),
      daysPickerTheme: DaysPickerTheme(
        daysOfTheWeekTheme: DaysOfTheWeekTheme(
          textStyle: m13w700(context).copyWith(color: colors.textSecondary),
          weekdayLength: WeekdayLength.short,
        ),
        enabledCellsTextStyle: cellTextStyle.copyWith(
          color: colors.textPrimary,
        ),
        disabledCellsTextStyle: disabledTextStyle,
        currentDateTextStyle: cellTextStyle.copyWith(color: colors.primary),
        currentDateDecoration: currentDecoration,
        selectedCellTextStyle: selectedTextStyle,
        selectedCellDecoration: selectedDecoration,
        cellsPadding: EdgeInsets.all(2.r),
      ),
      monthsPickerTheme: MonthsPickerTheme(
        enabledCellsTextStyle: cellTextStyle.copyWith(
          color: colors.textPrimary,
        ),
        disabledCellsTextStyle: disabledTextStyle,
        currentDateTextStyle: cellTextStyle.copyWith(color: colors.primary),
        currentDateDecoration: BoxDecoration(
          border: Border.all(color: colors.primary),
          borderRadius: BorderRadius.circular(Sp.medium.r),
        ),
        selectedCellTextStyle: selectedTextStyle,
        selectedCellDecoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(Sp.medium.r),
        ),
      ),
      yearsPickerTheme: YearsPickerTheme(
        enabledCellsTextStyle: cellTextStyle.copyWith(
          color: colors.textPrimary,
        ),
        disabledCellsTextStyle: disabledTextStyle,
        currentDateTextStyle: cellTextStyle.copyWith(color: colors.primary),
        currentDateDecoration: BoxDecoration(
          border: Border.all(color: colors.primary),
          borderRadius: BorderRadius.circular(Sp.medium.r),
        ),
        selectedCellTextStyle: selectedTextStyle,
        selectedCellDecoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(Sp.medium.r),
        ),
      ),
      rangePickerTheme: RangePickerTheme(
        enabledCellsTextStyle: cellTextStyle.copyWith(
          color: colors.textPrimary,
        ),
        disabledCellsTextStyle: disabledTextStyle,
        currentDateTextStyle: cellTextStyle.copyWith(color: colors.primary),
        currentDateDecoration: currentDecoration,
        selectedCellsTextStyle: cellTextStyle.copyWith(color: colors.primary),
        selectedCellsDecoration: selectedRangeDecoration,
        selectedEdgeCellTextStyle: selectedTextStyle,
        selectedEdgeCellDecoration: selectedEdgeDecoration,
        cellsPadding: EdgeInsets.all(2.r),
      ),
    );
  }
}

class _SpinnerPickerDialog extends StatefulWidget {
  const _SpinnerPickerDialog({
    required this.mode,
    required this.initialDateTime,
    this.minDateTime,
    this.maxDateTime,
  });

  final CupertinoDatePickerMode mode;
  final DateTime initialDateTime;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  @override
  State<_SpinnerPickerDialog> createState() => _SpinnerPickerDialogState();
}

class _SpinnerPickerDialogState extends State<_SpinnerPickerDialog> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Dialog(
      elevation: 0,
      backgroundColor: colors.surface,
      insetPadding: EdgeInsets.symmetric(horizontal: Sp.large.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sp.medium.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: math.min(
            MediaQuery.sizeOf(context).width - (Sp.large.w * 2),
            360,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 225.h,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: m16w600(context).copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: widget.mode,
                  initialDateTime: widget.initialDateTime,
                  minimumDate: widget.minDateTime,
                  maximumDate: widget.maxDateTime,
                  use24hFormat: true,
                  backgroundColor: colors.surface,
                  onDateTimeChanged: (dateTime) {
                    _selectedDateTime = dateTime;
                  },
                ),
              ),
            ),
            DefaultTextStyle(
              style: const TextStyle(decoration: TextDecoration.none),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        LocaleKeys.common_cancel.tr(),
                        style: m14w600(
                          context,
                        ).copyWith(color: colors.textSecondary),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(_selectedDateTime),
                      child: Text(
                        LocaleKeys.common_confirm.tr(),
                        style: m14w700(context).copyWith(color: colors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Sp.xsmall.heightBox,
          ],
        ),
      ),
    );
  }
}
