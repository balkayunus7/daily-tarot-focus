import 'package:daily_tarot_focus/core/util/locale_keys.dart';

class NumerologyResultModel {
  const NumerologyResultModel({
    required this.birthDate,
    required this.fullName,
    required this.lifePath,
    required this.birthday,
    required this.destiny,
    required this.soulUrge,
    required this.personality,
    required this.maturity,
  });

  final DateTime birthDate;
  final String fullName;
  final int lifePath;
  final int birthday;
  final int destiny;
  final int soulUrge;
  final int personality;
  final int maturity;
}

class NumerologyMeaning {
  const NumerologyMeaning._({required this.titleKey, required this.descKey});

  final String titleKey;
  final String descKey;

  static const Map<int, NumerologyMeaning> _byNumber = {
    1: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_1,
      descKey: LocaleKeys.numerology_page_desc_1,
    ),
    2: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_2,
      descKey: LocaleKeys.numerology_page_desc_2,
    ),
    3: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_3,
      descKey: LocaleKeys.numerology_page_desc_3,
    ),
    4: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_4,
      descKey: LocaleKeys.numerology_page_desc_4,
    ),
    5: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_5,
      descKey: LocaleKeys.numerology_page_desc_5,
    ),
    6: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_6,
      descKey: LocaleKeys.numerology_page_desc_6,
    ),
    7: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_7,
      descKey: LocaleKeys.numerology_page_desc_7,
    ),
    8: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_8,
      descKey: LocaleKeys.numerology_page_desc_8,
    ),
    9: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_9,
      descKey: LocaleKeys.numerology_page_desc_9,
    ),
    11: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_11,
      descKey: LocaleKeys.numerology_page_desc_11,
    ),
    22: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_22,
      descKey: LocaleKeys.numerology_page_desc_22,
    ),
    33: NumerologyMeaning._(
      titleKey: LocaleKeys.numerology_page_title_33,
      descKey: LocaleKeys.numerology_page_desc_33,
    ),
  };

  static NumerologyMeaning forNumber(int n) => _byNumber[n] ?? _byNumber[1]!;
}
