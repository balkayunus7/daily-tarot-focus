import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

enum HoroscopePeriod { daily, weekly, monthly }

extension HoroscopePeriodX on HoroscopePeriod {
  String get labelKey {
    switch (this) {
      case HoroscopePeriod.daily:
        return LocaleKeys.horoscope_page_tab_daily;
      case HoroscopePeriod.weekly:
        return LocaleKeys.horoscope_page_tab_weekly;
      case HoroscopePeriod.monthly:
        return LocaleKeys.horoscope_page_tab_monthly;
    }
  }

  String get tabLabel {
    switch (this) {
      case HoroscopePeriod.daily:
        return 'Today';
      case HoroscopePeriod.weekly:
        return 'Week';
      case HoroscopePeriod.monthly:
        return 'Month';
    }
  }

  String get periodWord {
    switch (this) {
      case HoroscopePeriod.daily:
        return LocaleKeys.horoscope_page_period_daily.tr();
      case HoroscopePeriod.weekly:
        return LocaleKeys.horoscope_page_period_weekly.tr();
      case HoroscopePeriod.monthly:
        return LocaleKeys.horoscope_page_period_monthly.tr();
    }
  }
}
