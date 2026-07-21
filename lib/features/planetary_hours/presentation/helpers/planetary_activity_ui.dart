import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/features/planetary_hours/domain/planetary_activity.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

extension PlanetaryActivityUi on PlanetaryActivity {
  String get localizedLabel {
    switch (this) {
      case PlanetaryActivity.study:
        return LocaleKeys.planetary_page_activity_study.tr();
      case PlanetaryActivity.workout:
        return LocaleKeys.planetary_page_activity_workout.tr();
      case PlanetaryActivity.meeting:
        return LocaleKeys.planetary_page_activity_meeting.tr();
      case PlanetaryActivity.meditation:
        return LocaleKeys.planetary_page_activity_meditation.tr();
      case PlanetaryActivity.date:
        return LocaleKeys.planetary_page_activity_date.tr();
      case PlanetaryActivity.creativity:
        return LocaleKeys.planetary_page_activity_creativity.tr();
      case PlanetaryActivity.business:
        return LocaleKeys.planetary_page_activity_business.tr();
      case PlanetaryActivity.travel:
        return LocaleKeys.planetary_page_activity_travel.tr();
    }
  }

  IconData get icon {
    switch (this) {
      case PlanetaryActivity.study:
        return Icons.menu_book_outlined;
      case PlanetaryActivity.workout:
        return Icons.fitness_center_outlined;
      case PlanetaryActivity.meeting:
        return Icons.groups_outlined;
      case PlanetaryActivity.meditation:
        return Icons.self_improvement_outlined;
      case PlanetaryActivity.date:
        return Icons.favorite_outline;
      case PlanetaryActivity.creativity:
        return Icons.palette_outlined;
      case PlanetaryActivity.business:
        return Icons.business_center_outlined;
      case PlanetaryActivity.travel:
        return Icons.flight_takeoff_outlined;
    }
  }
}
