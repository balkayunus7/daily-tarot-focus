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

  // ── Ruling planet ──────────────────────────────────────────────────────────

  String get rulingPlanet {
    switch (this) {
      case ZodiacSign.aries:
        return 'Mars';
      case ZodiacSign.taurus:
      case ZodiacSign.libra:
        return 'Venus';
      case ZodiacSign.gemini:
      case ZodiacSign.virgo:
        return 'Mercury';
      case ZodiacSign.cancer:
        return 'Moon';
      case ZodiacSign.leo:
        return 'Sun';
      case ZodiacSign.scorpio:
        return 'Pluto';
      case ZodiacSign.sagittarius:
        return 'Jupiter';
      case ZodiacSign.capricorn:
        return 'Saturn';
      case ZodiacSign.aquarius:
        return 'Uranus';
      case ZodiacSign.pisces:
        return 'Neptune';
    }
  }

  /// The Major Arcana card associated with the ruling planet.
  String get rulingPlanetCard {
    switch (this) {
      case ZodiacSign.aries:
        return 'The Tower';
      case ZodiacSign.taurus:
      case ZodiacSign.libra:
        return 'The Empress';
      case ZodiacSign.gemini:
      case ZodiacSign.virgo:
        return 'The Magician';
      case ZodiacSign.cancer:
        return 'The High Priestess';
      case ZodiacSign.leo:
        return 'The Sun';
      case ZodiacSign.scorpio:
        return 'Judgement';
      case ZodiacSign.sagittarius:
        return 'Wheel of Fortune';
      case ZodiacSign.capricorn:
        return 'The World';
      case ZodiacSign.aquarius:
        return 'The Fool';
      case ZodiacSign.pisces:
        return 'The Hanged Man';
    }
  }

  // ── Ruling house ───────────────────────────────────────────────────────────

  String get rulingHouse {
    const houses = [
      '1st · House of Self',
      '2nd · House of Values',
      '3rd · House of Communication',
      '4th · House of Home',
      '5th · House of Creativity',
      '6th · House of Health',
      '7th · House of Partnerships',
      '8th · House of Transformation',
      '9th · House of Philosophy',
      '10th · House of Career',
      '11th · House of Community',
      '12th · House of the Unconscious',
    ];
    return houses[index];
  }

  // ── Decan Minor Arcana cards ───────────────────────────────────────────────

  String get dateRangeKey {
    switch (this) {
      case ZodiacSign.aries:
        return LocaleKeys.horoscope_page_date_aries;
      case ZodiacSign.taurus:
        return LocaleKeys.horoscope_page_date_taurus;
      case ZodiacSign.gemini:
        return LocaleKeys.horoscope_page_date_gemini;
      case ZodiacSign.cancer:
        return LocaleKeys.horoscope_page_date_cancer;
      case ZodiacSign.leo:
        return LocaleKeys.horoscope_page_date_leo;
      case ZodiacSign.virgo:
        return LocaleKeys.horoscope_page_date_virgo;
      case ZodiacSign.libra:
        return LocaleKeys.horoscope_page_date_libra;
      case ZodiacSign.scorpio:
        return LocaleKeys.horoscope_page_date_scorpio;
      case ZodiacSign.sagittarius:
        return LocaleKeys.horoscope_page_date_sagittarius;
      case ZodiacSign.capricorn:
        return LocaleKeys.horoscope_page_date_capricorn;
      case ZodiacSign.aquarius:
        return LocaleKeys.horoscope_page_date_aquarius;
      case ZodiacSign.pisces:
        return LocaleKeys.horoscope_page_date_pisces;
    }
  }

  List<String> get minorArcanaCards {
    switch (this) {
      case ZodiacSign.aries:
        return ['2 of Wands', '3 of Wands', '4 of Wands'];
      case ZodiacSign.taurus:
        return ['5 of Pentacles', '6 of Pentacles', '7 of Pentacles'];
      case ZodiacSign.gemini:
        return ['8 of Swords', '9 of Swords', '10 of Swords'];
      case ZodiacSign.cancer:
        return ['2 of Cups', '3 of Cups', '4 of Cups'];
      case ZodiacSign.leo:
        return ['5 of Wands', '6 of Wands', '7 of Wands'];
      case ZodiacSign.virgo:
        return ['8 of Pentacles', '9 of Pentacles', '10 of Pentacles'];
      case ZodiacSign.libra:
        return ['2 of Swords', '3 of Swords', '4 of Swords'];
      case ZodiacSign.scorpio:
        return ['5 of Cups', '6 of Cups', '7 of Cups'];
      case ZodiacSign.sagittarius:
        return ['8 of Wands', '9 of Wands', '10 of Wands'];
      case ZodiacSign.capricorn:
        return ['2 of Pentacles', '3 of Pentacles', '4 of Pentacles'];
      case ZodiacSign.aquarius:
        return ['5 of Swords', '6 of Swords', '7 of Swords'];
      case ZodiacSign.pisces:
        return ['8 of Cups', '9 of Cups', '10 of Cups'];
    }
  }

  // ── Keywords ───────────────────────────────────────────────────────────────

  List<String> get strengths {
    switch (this) {
      case ZodiacSign.aries:
        return ['Bold', 'Courageous', 'Pioneering'];
      case ZodiacSign.taurus:
        return ['Patient', 'Reliable', 'Sensual'];
      case ZodiacSign.gemini:
        return ['Adaptable', 'Witty', 'Curious'];
      case ZodiacSign.cancer:
        return ['Nurturing', 'Intuitive', 'Empathic'];
      case ZodiacSign.leo:
        return ['Generous', 'Confident', 'Creative'];
      case ZodiacSign.virgo:
        return ['Analytical', 'Precise', 'Devoted'];
      case ZodiacSign.libra:
        return ['Diplomatic', 'Charming', 'Fair'];
      case ZodiacSign.scorpio:
        return ['Passionate', 'Resourceful', 'Perceptive'];
      case ZodiacSign.sagittarius:
        return ['Optimistic', 'Adventurous', 'Visionary'];
      case ZodiacSign.capricorn:
        return ['Disciplined', 'Ambitious', 'Patient'];
      case ZodiacSign.aquarius:
        return ['Innovative', 'Humanitarian', 'Independent'];
      case ZodiacSign.pisces:
        return ['Compassionate', 'Intuitive', 'Dreamy'];
    }
  }

  List<String> get shadows {
    switch (this) {
      case ZodiacSign.aries:
        return ['Impulsive', 'Reckless', 'Impatient'];
      case ZodiacSign.taurus:
        return ['Stubborn', 'Possessive', 'Indulgent'];
      case ZodiacSign.gemini:
        return ['Scattered', 'Inconsistent', 'Anxious'];
      case ZodiacSign.cancer:
        return ['Moody', 'Clingy', 'Oversensitive'];
      case ZodiacSign.leo:
        return ['Arrogant', 'Dramatic', 'Attention-seeking'];
      case ZodiacSign.virgo:
        return ['Critical', 'Perfectionist', 'Anxious'];
      case ZodiacSign.libra:
        return ['Indecisive', 'People-pleasing', 'Vain'];
      case ZodiacSign.scorpio:
        return ['Secretive', 'Jealous', 'Vengeful'];
      case ZodiacSign.sagittarius:
        return ['Restless', 'Tactless', 'Overconfident'];
      case ZodiacSign.capricorn:
        return ['Cold', 'Rigid', 'Pessimistic'];
      case ZodiacSign.aquarius:
        return ['Detached', 'Rebellious', 'Aloof'];
      case ZodiacSign.pisces:
        return ['Escapist', 'Overidealistic', 'Naive'];
    }
  }
}
