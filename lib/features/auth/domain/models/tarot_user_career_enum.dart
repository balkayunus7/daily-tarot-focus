import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconify_flutter/icons/mdi.dart';

enum CareerStatus {
  student('student'),
  employed('employed'),
  selfEmployed('self_employed'),
  unemployed('unemployed'),
  retired('retired'),
  preferNotToSay('prefer_not_to_say');

  const CareerStatus(this.value);

  factory CareerStatus.fromString(String value) =>
      CareerStatus.values.firstWhere((e) => e.value == value);

  final String value;

  String get localizedName {
    return switch (this) {
      CareerStatus.student => LocaleKeys.career_status_student.tr(),
      CareerStatus.employed => LocaleKeys.career_status_employed.tr(),
      CareerStatus.selfEmployed => LocaleKeys.career_status_self_employed.tr(),
      CareerStatus.unemployed => LocaleKeys.career_status_unemployed.tr(),
      CareerStatus.retired => LocaleKeys.career_status_retired.tr(),
      CareerStatus.preferNotToSay => LocaleKeys.career_status_prefer_not_to_say.tr(),
    };
  }

  String get icon => switch (this) {
    CareerStatus.student => Mdi.school,
    CareerStatus.employed => Mdi.briefcase,
    CareerStatus.selfEmployed => Mdi.account_tie,
    CareerStatus.unemployed => Mdi.briefcase_off,
    CareerStatus.retired => Mdi.account_clock,
    CareerStatus.preferNotToSay => Mdi.eye_off,
  };
}
