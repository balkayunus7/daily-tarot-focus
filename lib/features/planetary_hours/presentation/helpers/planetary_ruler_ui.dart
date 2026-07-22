part of '../pages/planetary_hours_page.dart';

extension PlanetaryRulerUi on PlanetaryRuler {
  String get glyph {
    switch (this) {
      case PlanetaryRuler.sun:
        return '☉';
      case PlanetaryRuler.moon:
        return '☽';
      case PlanetaryRuler.mars:
        return '♂';
      case PlanetaryRuler.mercury:
        return '☿';
      case PlanetaryRuler.jupiter:
        return '♃';
      case PlanetaryRuler.venus:
        return '♀';
      case PlanetaryRuler.saturn:
        return '♄';
    }
  }

  Color get accentColor {
    switch (this) {
      case PlanetaryRuler.sun:
        return const Color(0xFFE8B85A);
      case PlanetaryRuler.moon:
        return const Color(0xFFB8C4D8);
      case PlanetaryRuler.mars:
        return const Color(0xFFE05A5A);
      case PlanetaryRuler.mercury:
        return const Color(0xFF82C4E8);
      case PlanetaryRuler.jupiter:
        return const Color(0xFF7BC67A);
      case PlanetaryRuler.venus:
        return const Color(0xFFE05A82);
      case PlanetaryRuler.saturn:
        return const Color(0xFF9B8AC4);
    }
  }

  String get localizedName {
    switch (this) {
      case PlanetaryRuler.sun:
        return LocaleKeys.planetary_page_planet_sun.tr();
      case PlanetaryRuler.moon:
        return LocaleKeys.planetary_page_planet_moon.tr();
      case PlanetaryRuler.mars:
        return LocaleKeys.planetary_page_planet_mars.tr();
      case PlanetaryRuler.mercury:
        return LocaleKeys.planetary_page_planet_mercury.tr();
      case PlanetaryRuler.jupiter:
        return LocaleKeys.planetary_page_planet_jupiter.tr();
      case PlanetaryRuler.venus:
        return LocaleKeys.planetary_page_planet_venus.tr();
      case PlanetaryRuler.saturn:
        return LocaleKeys.planetary_page_planet_saturn.tr();
    }
  }

  String get localizedMeaning {
    switch (this) {
      case PlanetaryRuler.sun:
        return LocaleKeys.planetary_page_meaning_sun.tr();
      case PlanetaryRuler.moon:
        return LocaleKeys.planetary_page_meaning_moon.tr();
      case PlanetaryRuler.mars:
        return LocaleKeys.planetary_page_meaning_mars.tr();
      case PlanetaryRuler.mercury:
        return LocaleKeys.planetary_page_meaning_mercury.tr();
      case PlanetaryRuler.jupiter:
        return LocaleKeys.planetary_page_meaning_jupiter.tr();
      case PlanetaryRuler.venus:
        return LocaleKeys.planetary_page_meaning_venus.tr();
      case PlanetaryRuler.saturn:
        return LocaleKeys.planetary_page_meaning_saturn.tr();
    }
  }
}
