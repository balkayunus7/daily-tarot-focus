import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconify_flutter/icons/mdi.dart';

enum CareerStatus {
  // Klasik Eğitim ve Çalışma
  student('Student'),
  employed('Employed'),
  selfEmployed('Self-employed'),

  // Modern Çalışma Modelleri
  freelancer('Freelancer'),
  entrepreneur('Entrepreneur'),

  // Arayış ve Molalar
  unemployed('Looking'),
  careerBreak('Career break'),

  // Ev ve Emeklilik
  homemaker('Homemaker'),
  retired('Retired'),

  // Gizlilik
  preferNotToSay('Skip');

  const CareerStatus(this.value);

  factory CareerStatus.fromString(String value) => CareerStatus.values.firstWhere(
    (e) => e.value == value,
    orElse: () => CareerStatus.preferNotToSay, // Güvenlik için eklendi
  );

  final String value;

  String get localizedName {
    return switch (this) {
      CareerStatus.student => LocaleKeys.career_status_student.tr(),
      CareerStatus.employed => LocaleKeys.career_status_employed.tr(),
      CareerStatus.selfEmployed => LocaleKeys.career_status_self_employed.tr(),
      CareerStatus.freelancer => LocaleKeys.career_status_freelancer.tr(),
      CareerStatus.entrepreneur => LocaleKeys.career_status_entrepreneur.tr(),
      CareerStatus.unemployed => LocaleKeys.career_status_unemployed.tr(),
      CareerStatus.careerBreak => LocaleKeys.career_status_career_break.tr(),
      CareerStatus.homemaker => LocaleKeys.career_status_homemaker.tr(),
      CareerStatus.retired => LocaleKeys.career_status_retired.tr(),
      CareerStatus.preferNotToSay => LocaleKeys.career_status_prefer_not_to_say.tr(),
    };
  }

  String get icon => switch (this) {
    CareerStatus.student => Mdi.school_outline,
    CareerStatus.employed => Mdi.briefcase_outline,
    CareerStatus.selfEmployed => Mdi.account_tie,
    CareerStatus.freelancer => Mdi.laptop,
    CareerStatus.entrepreneur => Mdi.rocket_launch_outline,
    CareerStatus.unemployed => Mdi.magnify,
    CareerStatus.careerBreak => Mdi.pause_circle_outline,
    CareerStatus.homemaker => Mdi.home_heart,
    CareerStatus.retired => Mdi.beach,
    CareerStatus.preferNotToSay => Mdi.eye_off_outline,
  };
}
