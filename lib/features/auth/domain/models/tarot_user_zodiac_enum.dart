import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

enum ZodiacElement { fire, earth, air, water }

enum ZodiacModality { cardinal, fixed, mutable }

enum ZodiacSign {
  aries('Aries'),
  taurus('Taurus'),
  gemini('Gemini'),
  cancer('Cancer'),
  leo('Leo'),
  virgo('Virgo'),
  libra('Libra'),
  scorpio('Scorpio'),
  sagittarius('Sagittarius'),
  capricorn('Capricorn'),
  aquarius('Aquarius'),
  pisces('Pisces');

  const ZodiacSign(this.value);
  factory ZodiacSign.fromString(String value) =>
      ZodiacSign.values.firstWhere((e) => e.value == value);

  final String value;

  String get localizedName {
    switch (this) {
      case ZodiacSign.aries:
        return LocaleKeys.zodiac_aries.tr();
      case ZodiacSign.taurus:
        return LocaleKeys.zodiac_taurus.tr();
      case ZodiacSign.gemini:
        return LocaleKeys.zodiac_gemini.tr();
      case ZodiacSign.cancer:
        return LocaleKeys.zodiac_cancer.tr();
      case ZodiacSign.leo:
        return LocaleKeys.zodiac_leo.tr();
      case ZodiacSign.virgo:
        return LocaleKeys.zodiac_virgo.tr();
      case ZodiacSign.libra:
        return LocaleKeys.zodiac_libra.tr();
      case ZodiacSign.scorpio:
        return LocaleKeys.zodiac_scorpio.tr();
      case ZodiacSign.sagittarius:
        return LocaleKeys.zodiac_sagittarius.tr();
      case ZodiacSign.capricorn:
        return LocaleKeys.zodiac_capricorn.tr();
      case ZodiacSign.aquarius:
        return LocaleKeys.zodiac_aquarius.tr();
      case ZodiacSign.pisces:
        return LocaleKeys.zodiac_pisces.tr();
    }
  }

  String get emoji {
    switch (this) {
      case ZodiacSign.aries:
        return '♈';
      case ZodiacSign.taurus:
        return '♉';
      case ZodiacSign.gemini:
        return '♊';
      case ZodiacSign.cancer:
        return '♋';
      case ZodiacSign.leo:
        return '♌';
      case ZodiacSign.virgo:
        return '♍';
      case ZodiacSign.libra:
        return '♎';
      case ZodiacSign.scorpio:
        return '♏';
      case ZodiacSign.sagittarius:
        return '♐';
      case ZodiacSign.capricorn:
        return '♑';
      case ZodiacSign.aquarius:
        return '♒';
      case ZodiacSign.pisces:
        return '♓';
    }
  }

  String get svgPath => 'assets/svg/zodiac-${value.toLowerCase()}.svg';

  ZodiacElement get element {
    switch (this) {
      case ZodiacSign.aries:
      case ZodiacSign.leo:
      case ZodiacSign.sagittarius:
        return ZodiacElement.fire;
      case ZodiacSign.taurus:
      case ZodiacSign.virgo:
      case ZodiacSign.capricorn:
        return ZodiacElement.earth;
      case ZodiacSign.gemini:
      case ZodiacSign.libra:
      case ZodiacSign.aquarius:
        return ZodiacElement.air;
      case ZodiacSign.cancer:
      case ZodiacSign.scorpio:
      case ZodiacSign.pisces:
        return ZodiacElement.water;
    }
  }

  ZodiacModality get modality {
    switch (this) {
      case ZodiacSign.aries:
      case ZodiacSign.cancer:
      case ZodiacSign.libra:
      case ZodiacSign.capricorn:
        return ZodiacModality.cardinal;
      case ZodiacSign.taurus:
      case ZodiacSign.leo:
      case ZodiacSign.scorpio:
      case ZodiacSign.aquarius:
        return ZodiacModality.fixed;
      case ZodiacSign.gemini:
      case ZodiacSign.virgo:
      case ZodiacSign.sagittarius:
      case ZodiacSign.pisces:
        return ZodiacModality.mutable;
    }
  }

  String get majorArcanaName {
    switch (this) {
      case ZodiacSign.aries:
        return 'The Emperor';
      case ZodiacSign.taurus:
        return 'The Hierophant';
      case ZodiacSign.gemini:
        return 'The Lovers';
      case ZodiacSign.cancer:
        return 'The Chariot';
      case ZodiacSign.leo:
        return 'Strength';
      case ZodiacSign.virgo:
        return 'The Hermit';
      case ZodiacSign.libra:
        return 'Justice';
      case ZodiacSign.scorpio:
        return 'Death';
      case ZodiacSign.sagittarius:
        return 'Temperance';
      case ZodiacSign.capricorn:
        return 'The Devil';
      case ZodiacSign.aquarius:
        return 'The Star';
      case ZodiacSign.pisces:
        return 'The Moon';
    }
  }

  String get elementLocalized {
    switch (element) {
      case ZodiacElement.fire:
        return LocaleKeys.zodiac_page_element_fire.tr();
      case ZodiacElement.earth:
        return LocaleKeys.zodiac_page_element_earth.tr();
      case ZodiacElement.air:
        return LocaleKeys.zodiac_page_element_air.tr();
      case ZodiacElement.water:
        return LocaleKeys.zodiac_page_element_water.tr();
    }
  }

  String get modalityLocalized {
    switch (modality) {
      case ZodiacModality.cardinal:
        return LocaleKeys.zodiac_page_modality_cardinal.tr();
      case ZodiacModality.fixed:
        return LocaleKeys.zodiac_page_modality_fixed.tr();
      case ZodiacModality.mutable:
        return LocaleKeys.zodiac_page_modality_mutable.tr();
    }
  }

  String get signDescription => 'zodiac_page.desc_${value.toLowerCase()}'.tr();
}
