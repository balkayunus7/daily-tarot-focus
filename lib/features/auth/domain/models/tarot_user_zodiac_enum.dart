import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

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
}
