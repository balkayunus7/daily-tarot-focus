import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_request_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_response_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class ZodiacCompatibilityStaticData {
  static const List<_CategorySpec> _categorySpecs = [
    _CategorySpec(
      _CompatibilityCategory.sexuality,
      '⚡',
      LocaleKeys.compat_page_category_sexuality,
      Color(0xFFE05A5A),
    ),
    _CategorySpec(
      _CompatibilityCategory.trust,
      '🤝',
      LocaleKeys.compat_page_category_trust,
      Color(0xFF5A9EE0),
    ),
    _CategorySpec(
      _CompatibilityCategory.communication,
      '💬',
      LocaleKeys.compat_page_category_communication,
      Color(0xFF5AE09E),
    ),
    _CategorySpec(
      _CompatibilityCategory.emotions,
      '💜',
      LocaleKeys.compat_page_category_emotions,
      Color(0xFF9E5AE0),
    ),
    _CategorySpec(
      _CompatibilityCategory.coreValues,
      '🌿',
      LocaleKeys.compat_page_category_values,
      Color(0xFFE0B85A),
    ),
  ];

  static GenerateCompatibilityResponse calculate(
    GenerateCompatibilityRequestModel request,
  ) {
    final overall = _overall(request);

    return GenerateCompatibilityResponse(
      summary: _summary(request, overall),
      overallScore: overall,
      categories: _categories(request, overall),
    );
  }

  static int _overall(GenerateCompatibilityRequestModel request) {
    final a = request.mySign;
    final b = request.partnerSign;
    final score =
        50 +
        _elementBonus(a, b) +
        _distanceBonus(a, b) +
        _modalityBonus(a, b) +
        _directionalOverallBonus(request);
    return _bounded(score, 28, 96);
  }

  static int _elementBonus(ZodiacSign a, ZodiacSign b) {
    final ea = a.element;
    final eb = b.element;
    if (ea == eb) return 28;
    if (_compatible(ea, eb)) return 18;
    if (_neutral(ea, eb)) return 4;
    return -6;
  }

  static bool _compatible(ZodiacElement a, ZodiacElement b) {
    return (a == ZodiacElement.fire && b == ZodiacElement.air) ||
        (a == ZodiacElement.air && b == ZodiacElement.fire) ||
        (a == ZodiacElement.earth && b == ZodiacElement.water) ||
        (a == ZodiacElement.water && b == ZodiacElement.earth);
  }

  static bool _neutral(ZodiacElement a, ZodiacElement b) {
    return (a == ZodiacElement.air && b == ZodiacElement.earth) ||
        (a == ZodiacElement.earth && b == ZodiacElement.air) ||
        (a == ZodiacElement.air && b == ZodiacElement.water) ||
        (a == ZodiacElement.water && b == ZodiacElement.air);
  }

  static int _distanceBonus(ZodiacSign a, ZodiacSign b) {
    final dist = (a.index - b.index).abs();
    final minDist = dist > 6 ? 12 - dist : dist;
    return switch (minDist) {
      0 => 8,
      2 => 12,
      4 => 16,
      6 => 6,
      3 => -8,
      5 => -4,
      _ => 0,
    };
  }

  static int _modalityBonus(ZodiacSign a, ZodiacSign b) =>
      a.modality == b.modality ? -4 : 4;

  static int _directionalOverallBonus(
    GenerateCompatibilityRequestModel request,
  ) {
    final roleTotal =
        _categorySpecs
            .map((spec) => _roleBlendScore(spec.category, request))
            .fold<int>(0, (sum, score) => sum + score) ~/
        _categorySpecs.length;
    final orderBonus =
        _isWomanManPair(request.myGender, request.partnerGender)
            ? request.myGender.isFemale
                ? 1
                : -1
            : 0;

    return (roleTotal + orderBonus).clamp(-10, 10);
  }

  static List<CompatibilityCategoryModel> _categories(
    GenerateCompatibilityRequestModel request,
    int overall,
  ) {
    return _categorySpecs
        .map((spec) => _cat(spec, request, overall))
        .toList(growable: false);
  }

  static int _categoryOffset(
    _CompatibilityCategory category,
    GenerateCompatibilityRequestModel request,
  ) {
    final a = request.mySign;
    final b = request.partnerSign;
    final sameElement = a.element == b.element;
    final compatible = _compatible(a.element, b.element);
    final neutral = _neutral(a.element, b.element);
    final distance = _minDistance(a, b);
    final fixedPair =
        a.modality == ZodiacModality.fixed &&
        b.modality == ZodiacModality.fixed;
    final roleBlend = _roleBlendScore(category, request);
    final directionVariance = _directionVariance(category, request);

    return switch (category) {
      _CompatibilityCategory.sexuality =>
        (sameElement ? 8 : 0) +
            (compatible ? 7 : 0) +
            (_hasElement(a, b, ZodiacElement.fire) ? 4 : 0) +
            (distance == 4 || distance == 6 ? 5 : 0) +
            (distance == 3 ? -2 : 0) +
            roleBlend +
            directionVariance,
      _CompatibilityCategory.trust =>
        (sameElement ? 7 : 0) +
            (_earthWaterPair(a, b) ? 8 : 0) +
            (fixedPair ? 3 : 0) +
            (distance == 3 ? -9 : 0) +
            (distance == 5 ? -6 : 0) +
            (neutral ? 1 : 0) +
            roleBlend +
            directionVariance,
      _CompatibilityCategory.communication =>
        (_hasElement(a, b, ZodiacElement.air) ? 8 : 0) +
            (_fireAirPair(a, b) ? 6 : 0) +
            (a.modality != b.modality ? 3 : -2) +
            (distance == 2 ? 5 : 0) +
            (distance == 3 ? -5 : 0) +
            roleBlend +
            directionVariance,
      _CompatibilityCategory.emotions =>
        (_hasElement(a, b, ZodiacElement.water) ? 8 : 0) +
            (_earthWaterPair(a, b) ? 7 : 0) +
            (sameElement ? 5 : 0) +
            (distance == 6 ? 4 : 0) +
            (!compatible && !neutral && !sameElement ? -6 : 0) +
            roleBlend +
            directionVariance,
      _CompatibilityCategory.coreValues =>
        (sameElement ? 8 : 0) +
            (_hasElement(a, b, ZodiacElement.earth) ? 5 : 0) +
            (a.modality == b.modality ? 3 : 0) +
            (distance == 4 ? 4 : 0) +
            (distance == 3 ? -6 : 0) +
            (distance == 5 ? -4 : 0) +
            roleBlend +
            directionVariance,
    };
  }

  static CompatibilityCategoryModel _cat(
    _CategorySpec spec,
    GenerateCompatibilityRequestModel request,
    int overall,
  ) {
    final score = _bounded(
      overall + _categoryOffset(spec.category, request),
      20,
      98,
    );

    return CompatibilityCategoryModel(
      emoji: spec.emoji,
      labelKey: spec.labelKey,
      score: score,
      barColor: spec.barColor,
      description: _categoryDescription(spec.category, request, score),
    );
  }

  static String _summary(
    GenerateCompatibilityRequestModel request,
    int overall,
  ) {
    return LocaleKeys.compat_page_summary_template.tr(
      namedArgs: {
        'a': _signName(request.mySign),
        'b': _signName(request.partnerSign),
        'tone': _summaryTone(overall),
        'element': _elementSummary(request.mySign, request.partnerSign),
        'aspect': _aspectSummary(request.mySign, request.partnerSign),
        'aRole': _roleSummary(request.mySign, request.myGender),
        'bRole': _roleSummary(request.partnerSign, request.partnerGender),
        'balance': _balanceSummary(request),
        'gender': _genderSummary(request),
      },
    );
  }

  static String _categoryDescription(
    _CompatibilityCategory category,
    GenerateCompatibilityRequestModel request,
    int score,
  ) {
    return _categoryDescriptionKey(category, score).tr(
      namedArgs: {
        'a': _signName(request.mySign),
        'b': _signName(request.partnerSign),
        'aNeed': _signNeed(request.mySign),
        'bNeed': _signNeed(request.partnerSign),
        'reason': _categoryReason(category, request),
        'genderNote': _genderCategoryNote(category, request),
      },
    );
  }

  static String _categoryReason(
    _CompatibilityCategory category,
    GenerateCompatibilityRequestModel request,
  ) {
    final a = request.mySign;
    final b = request.partnerSign;
    final sameElement = a.element == b.element;
    final compatible = _compatible(a.element, b.element);
    final tense =
        !sameElement && !compatible && !_neutral(a.element, b.element);
    final aspect = _minDistance(a, b);

    return switch (category) {
      _CompatibilityCategory.sexuality =>
        sameElement
            ? LocaleKeys.compat_page_reason_sexuality_same.tr()
            : compatible
            ? LocaleKeys.compat_page_reason_sexuality_compatible.tr()
            : tense
            ? LocaleKeys.compat_page_reason_sexuality_tense.tr()
            : LocaleKeys.compat_page_reason_sexuality_neutral.tr(),
      _CompatibilityCategory.trust =>
        aspect == 3
            ? LocaleKeys.compat_page_reason_trust_square.tr()
            : aspect == 5
            ? LocaleKeys.compat_page_reason_trust_adjust.tr()
            : sameElement || _earthWaterPair(a, b)
            ? LocaleKeys.compat_page_reason_trust_stable.tr()
            : LocaleKeys.compat_page_reason_trust_default.tr(),
      _CompatibilityCategory.communication =>
        _hasElement(a, b, ZodiacElement.air)
            ? LocaleKeys.compat_page_reason_communication_air.tr()
            : aspect == 2
            ? LocaleKeys.compat_page_reason_communication_supportive.tr()
            : aspect == 3
            ? LocaleKeys.compat_page_reason_communication_square.tr()
            : LocaleKeys.compat_page_reason_communication_default.tr(),
      _CompatibilityCategory.emotions =>
        _hasElement(a, b, ZodiacElement.water)
            ? LocaleKeys.compat_page_reason_emotions_water.tr()
            : _earthWaterPair(a, b)
            ? LocaleKeys.compat_page_reason_emotions_earth_water.tr()
            : tense
            ? LocaleKeys.compat_page_reason_emotions_tense.tr()
            : LocaleKeys.compat_page_reason_emotions_default.tr(),
      _CompatibilityCategory.coreValues =>
        sameElement
            ? LocaleKeys.compat_page_reason_values_same.tr()
            : _hasElement(a, b, ZodiacElement.earth)
            ? LocaleKeys.compat_page_reason_values_earth.tr()
            : aspect == 4
            ? LocaleKeys.compat_page_reason_values_trine.tr()
            : LocaleKeys.compat_page_reason_values_default.tr(),
    };
  }

  static String _elementSummary(ZodiacSign a, ZodiacSign b) {
    if (a.element == b.element) {
      return LocaleKeys.compat_page_summary_element_same.tr();
    }
    if (_compatible(a.element, b.element)) {
      return LocaleKeys.compat_page_summary_element_compatible.tr();
    }
    if (_neutral(a.element, b.element)) {
      return LocaleKeys.compat_page_summary_element_neutral.tr();
    }
    return LocaleKeys.compat_page_summary_element_tense.tr();
  }

  static String _aspectSummary(ZodiacSign a, ZodiacSign b) {
    final distance = _minDistance(a, b);
    return switch (distance) {
      0 => LocaleKeys.compat_page_summary_aspect_same.tr(),
      2 => LocaleKeys.compat_page_summary_aspect_supportive.tr(),
      3 => LocaleKeys.compat_page_summary_aspect_square.tr(),
      4 => LocaleKeys.compat_page_summary_aspect_trine.tr(),
      5 => LocaleKeys.compat_page_summary_aspect_adjust.tr(),
      6 => LocaleKeys.compat_page_summary_aspect_opposite.tr(),
      _ => LocaleKeys.compat_page_summary_aspect_mixed.tr(),
    };
  }

  static String _genderSummary(GenerateCompatibilityRequestModel request) {
    if (!_isWomanManPair(request.myGender, request.partnerGender)) return '';

    if (request.myGender.isFemale) {
      return LocaleKeys.compat_page_summary_gender_female_male.tr(
        namedArgs: {
          'a': _signName(request.mySign),
          'b': _signName(request.partnerSign),
        },
      );
    }
    return LocaleKeys.compat_page_summary_gender_male_female.tr(
      namedArgs: {
        'a': _signName(request.mySign),
        'b': _signName(request.partnerSign),
      },
    );
  }

  static String _genderCategoryNote(
    _CompatibilityCategory category,
    GenerateCompatibilityRequestModel request,
  ) {
    if (!_isWomanManPair(request.myGender, request.partnerGender)) return '';

    return switch (category) {
      _CompatibilityCategory.sexuality => LocaleKeys
          .compat_page_gender_note_sexuality
          .tr(
            namedArgs: _pairArgs(request),
          ),
      _CompatibilityCategory.trust => LocaleKeys.compat_page_gender_note_trust
          .tr(namedArgs: _pairArgs(request)),
      _CompatibilityCategory.communication => LocaleKeys
          .compat_page_gender_note_communication
          .tr(
            namedArgs: _pairArgs(request),
          ),
      _CompatibilityCategory.emotions => LocaleKeys
          .compat_page_gender_note_emotions
          .tr(
            namedArgs: _pairArgs(request),
          ),
      _CompatibilityCategory.coreValues => LocaleKeys
          .compat_page_gender_note_values
          .tr(
            namedArgs: _pairArgs(request),
          ),
    };
  }

  static Map<String, String> _pairArgs(
    GenerateCompatibilityRequestModel request,
  ) {
    return {
      'a': _signName(request.mySign),
      'b': _signName(request.partnerSign),
    };
  }

  static String _balanceSummary(GenerateCompatibilityRequestModel request) {
    return LocaleKeys.compat_page_summary_balance_template.tr(
      namedArgs: {
        'aNeed': _signNeed(request.mySign),
        'bNeed': _signNeed(request.partnerSign),
      },
    );
  }

  static String _roleSummary(ZodiacSign sign, CompatGender gender) {
    if (gender.isFemale) {
      return switch (sign) {
        ZodiacSign.aries => LocaleKeys.compat_page_role_female_aries.tr(),
        ZodiacSign.taurus => LocaleKeys.compat_page_role_female_taurus.tr(),
        ZodiacSign.gemini => LocaleKeys.compat_page_role_female_gemini.tr(),
        ZodiacSign.cancer => LocaleKeys.compat_page_role_female_cancer.tr(),
        ZodiacSign.leo => LocaleKeys.compat_page_role_female_leo.tr(),
        ZodiacSign.virgo => LocaleKeys.compat_page_role_female_virgo.tr(),
        ZodiacSign.libra => LocaleKeys.compat_page_role_female_libra.tr(),
        ZodiacSign.scorpio => LocaleKeys.compat_page_role_female_scorpio.tr(),
        ZodiacSign.sagittarius =>
          LocaleKeys.compat_page_role_female_sagittarius.tr(),
        ZodiacSign.capricorn =>
          LocaleKeys.compat_page_role_female_capricorn.tr(),
        ZodiacSign.aquarius => LocaleKeys.compat_page_role_female_aquarius.tr(),
        ZodiacSign.pisces => LocaleKeys.compat_page_role_female_pisces.tr(),
      };
    }

    if (gender.isMale) {
      return switch (sign) {
        ZodiacSign.aries => LocaleKeys.compat_page_role_male_aries.tr(),
        ZodiacSign.taurus => LocaleKeys.compat_page_role_male_taurus.tr(),
        ZodiacSign.gemini => LocaleKeys.compat_page_role_male_gemini.tr(),
        ZodiacSign.cancer => LocaleKeys.compat_page_role_male_cancer.tr(),
        ZodiacSign.leo => LocaleKeys.compat_page_role_male_leo.tr(),
        ZodiacSign.virgo => LocaleKeys.compat_page_role_male_virgo.tr(),
        ZodiacSign.libra => LocaleKeys.compat_page_role_male_libra.tr(),
        ZodiacSign.scorpio => LocaleKeys.compat_page_role_male_scorpio.tr(),
        ZodiacSign.sagittarius =>
          LocaleKeys.compat_page_role_male_sagittarius.tr(),
        ZodiacSign.capricorn => LocaleKeys.compat_page_role_male_capricorn.tr(),
        ZodiacSign.aquarius => LocaleKeys.compat_page_role_male_aquarius.tr(),
        ZodiacSign.pisces => LocaleKeys.compat_page_role_male_pisces.tr(),
      };
    }

    return _signName(sign);
  }

  static String _signNeed(ZodiacSign sign) {
    return switch (sign) {
      ZodiacSign.aries => LocaleKeys.compat_page_need_aries.tr(),
      ZodiacSign.taurus => LocaleKeys.compat_page_need_taurus.tr(),
      ZodiacSign.gemini => LocaleKeys.compat_page_need_gemini.tr(),
      ZodiacSign.cancer => LocaleKeys.compat_page_need_cancer.tr(),
      ZodiacSign.leo => LocaleKeys.compat_page_need_leo.tr(),
      ZodiacSign.virgo => LocaleKeys.compat_page_need_virgo.tr(),
      ZodiacSign.libra => LocaleKeys.compat_page_need_libra.tr(),
      ZodiacSign.scorpio => LocaleKeys.compat_page_need_scorpio.tr(),
      ZodiacSign.sagittarius => LocaleKeys.compat_page_need_sagittarius.tr(),
      ZodiacSign.capricorn => LocaleKeys.compat_page_need_capricorn.tr(),
      ZodiacSign.aquarius => LocaleKeys.compat_page_need_aquarius.tr(),
      ZodiacSign.pisces => LocaleKeys.compat_page_need_pisces.tr(),
    };
  }

  static String _summaryTone(int score) {
    if (score >= 80) return LocaleKeys.compat_page_summary_tone_very_high.tr();
    if (score >= 65) return LocaleKeys.compat_page_summary_tone_high.tr();
    if (score >= 50) return LocaleKeys.compat_page_summary_tone_mid.tr();
    if (score >= 35) {
      return LocaleKeys.compat_page_summary_tone_low.tr();
    }
    return LocaleKeys.compat_page_summary_tone_very_low.tr();
  }

  static String _signName(ZodiacSign sign) {
    return switch (sign) {
      ZodiacSign.aries => LocaleKeys.zodiac_aries.tr(),
      ZodiacSign.taurus => LocaleKeys.zodiac_taurus.tr(),
      ZodiacSign.gemini => LocaleKeys.zodiac_gemini.tr(),
      ZodiacSign.cancer => LocaleKeys.zodiac_cancer.tr(),
      ZodiacSign.leo => LocaleKeys.zodiac_leo.tr(),
      ZodiacSign.virgo => LocaleKeys.zodiac_virgo.tr(),
      ZodiacSign.libra => LocaleKeys.zodiac_libra.tr(),
      ZodiacSign.scorpio => LocaleKeys.zodiac_scorpio.tr(),
      ZodiacSign.sagittarius => LocaleKeys.zodiac_sagittarius.tr(),
      ZodiacSign.capricorn => LocaleKeys.zodiac_capricorn.tr(),
      ZodiacSign.aquarius => LocaleKeys.zodiac_aquarius.tr(),
      ZodiacSign.pisces => LocaleKeys.zodiac_pisces.tr(),
    };
  }

  static String _categoryDescriptionKey(
    _CompatibilityCategory category,
    int score,
  ) {
    return switch ((_scoreBand(score), category)) {
      (_ScoreBand.high, _CompatibilityCategory.sexuality) =>
        LocaleKeys.compat_page_category_desc_sexuality_high,
      (_ScoreBand.mid, _CompatibilityCategory.sexuality) =>
        LocaleKeys.compat_page_category_desc_sexuality_mid,
      (_ScoreBand.low, _CompatibilityCategory.sexuality) =>
        LocaleKeys.compat_page_category_desc_sexuality_low,
      (_ScoreBand.high, _CompatibilityCategory.trust) =>
        LocaleKeys.compat_page_category_desc_trust_high,
      (_ScoreBand.mid, _CompatibilityCategory.trust) =>
        LocaleKeys.compat_page_category_desc_trust_mid,
      (_ScoreBand.low, _CompatibilityCategory.trust) =>
        LocaleKeys.compat_page_category_desc_trust_low,
      (_ScoreBand.high, _CompatibilityCategory.communication) =>
        LocaleKeys.compat_page_category_desc_communication_high,
      (_ScoreBand.mid, _CompatibilityCategory.communication) =>
        LocaleKeys.compat_page_category_desc_communication_mid,
      (_ScoreBand.low, _CompatibilityCategory.communication) =>
        LocaleKeys.compat_page_category_desc_communication_low,
      (_ScoreBand.high, _CompatibilityCategory.emotions) =>
        LocaleKeys.compat_page_category_desc_emotions_high,
      (_ScoreBand.mid, _CompatibilityCategory.emotions) =>
        LocaleKeys.compat_page_category_desc_emotions_mid,
      (_ScoreBand.low, _CompatibilityCategory.emotions) =>
        LocaleKeys.compat_page_category_desc_emotions_low,
      (_ScoreBand.high, _CompatibilityCategory.coreValues) =>
        LocaleKeys.compat_page_category_desc_values_high,
      (_ScoreBand.mid, _CompatibilityCategory.coreValues) =>
        LocaleKeys.compat_page_category_desc_values_mid,
      (_ScoreBand.low, _CompatibilityCategory.coreValues) =>
        LocaleKeys.compat_page_category_desc_values_low,
    };
  }

  static _ScoreBand _scoreBand(int score) {
    if (score >= 70) return _ScoreBand.high;
    if (score >= 50) return _ScoreBand.mid;
    return _ScoreBand.low;
  }

  static int _roleBlendScore(
    _CompatibilityCategory category,
    GenerateCompatibilityRequestModel request,
  ) {
    final myScore = _roleCategoryScore(
      request.mySign,
      request.myGender,
      category,
    );
    final partnerScore = _roleCategoryScore(
      request.partnerSign,
      request.partnerGender,
      category,
    );
    return ((myScore + partnerScore) / 2).round();
  }

  static int _roleCategoryScore(
    ZodiacSign sign,
    CompatGender gender,
    _CompatibilityCategory category,
  ) {
    return _signCategoryBase(sign, category) +
        _genderCategoryBias(sign, gender, category);
  }

  static int _signCategoryBase(
    ZodiacSign sign,
    _CompatibilityCategory category,
  ) {
    return switch (sign) {
      ZodiacSign.aries => switch (category) {
        _CompatibilityCategory.sexuality => 6,
        _CompatibilityCategory.trust => -2,
        _CompatibilityCategory.communication => 3,
        _CompatibilityCategory.emotions => -3,
        _CompatibilityCategory.coreValues => -1,
      },
      ZodiacSign.taurus => switch (category) {
        _CompatibilityCategory.sexuality => 3,
        _CompatibilityCategory.trust => 6,
        _CompatibilityCategory.communication => -1,
        _CompatibilityCategory.emotions => 3,
        _CompatibilityCategory.coreValues => 6,
      },
      ZodiacSign.gemini => switch (category) {
        _CompatibilityCategory.sexuality => 2,
        _CompatibilityCategory.trust => -1,
        _CompatibilityCategory.communication => 7,
        _CompatibilityCategory.emotions => -2,
        _CompatibilityCategory.coreValues => 0,
      },
      ZodiacSign.cancer => switch (category) {
        _CompatibilityCategory.sexuality => 1,
        _CompatibilityCategory.trust => 5,
        _CompatibilityCategory.communication => -2,
        _CompatibilityCategory.emotions => 7,
        _CompatibilityCategory.coreValues => 4,
      },
      ZodiacSign.leo => switch (category) {
        _CompatibilityCategory.sexuality => 6,
        _CompatibilityCategory.trust => 1,
        _CompatibilityCategory.communication => 4,
        _CompatibilityCategory.emotions => 2,
        _CompatibilityCategory.coreValues => 2,
      },
      ZodiacSign.virgo => switch (category) {
        _CompatibilityCategory.sexuality => 0,
        _CompatibilityCategory.trust => 5,
        _CompatibilityCategory.communication => 3,
        _CompatibilityCategory.emotions => 1,
        _CompatibilityCategory.coreValues => 6,
      },
      ZodiacSign.libra => switch (category) {
        _CompatibilityCategory.sexuality => 3,
        _CompatibilityCategory.trust => 2,
        _CompatibilityCategory.communication => 6,
        _CompatibilityCategory.emotions => 2,
        _CompatibilityCategory.coreValues => 3,
      },
      ZodiacSign.scorpio => switch (category) {
        _CompatibilityCategory.sexuality => 7,
        _CompatibilityCategory.trust => 0,
        _CompatibilityCategory.communication => -2,
        _CompatibilityCategory.emotions => 6,
        _CompatibilityCategory.coreValues => 2,
      },
      ZodiacSign.sagittarius => switch (category) {
        _CompatibilityCategory.sexuality => 5,
        _CompatibilityCategory.trust => -2,
        _CompatibilityCategory.communication => 4,
        _CompatibilityCategory.emotions => -1,
        _CompatibilityCategory.coreValues => -1,
      },
      ZodiacSign.capricorn => switch (category) {
        _CompatibilityCategory.sexuality => 1,
        _CompatibilityCategory.trust => 6,
        _CompatibilityCategory.communication => 0,
        _CompatibilityCategory.emotions => 0,
        _CompatibilityCategory.coreValues => 7,
      },
      ZodiacSign.aquarius => switch (category) {
        _CompatibilityCategory.sexuality => 2,
        _CompatibilityCategory.trust => 2,
        _CompatibilityCategory.communication => 7,
        _CompatibilityCategory.emotions => -3,
        _CompatibilityCategory.coreValues => 2,
      },
      ZodiacSign.pisces => switch (category) {
        _CompatibilityCategory.sexuality => 2,
        _CompatibilityCategory.trust => 3,
        _CompatibilityCategory.communication => 1,
        _CompatibilityCategory.emotions => 7,
        _CompatibilityCategory.coreValues => 1,
      },
    };
  }

  static int _genderCategoryBias(
    ZodiacSign sign,
    CompatGender gender,
    _CompatibilityCategory category,
  ) {
    if (gender.isFemale) return _femaleCategoryBias(sign, category);
    if (gender.isMale) return _maleCategoryBias(sign, category);
    return 0;
  }

  static int _femaleCategoryBias(
    ZodiacSign sign,
    _CompatibilityCategory category,
  ) {
    return switch (sign) {
      ZodiacSign.aries => switch (category) {
        _CompatibilityCategory.sexuality => 1,
        _CompatibilityCategory.trust => -1,
        _CompatibilityCategory.communication => 1,
        _ => 0,
      },
      ZodiacSign.taurus => switch (category) {
        _CompatibilityCategory.trust => 1,
        _CompatibilityCategory.coreValues => 1,
        _ => 0,
      },
      ZodiacSign.gemini => switch (category) {
        _CompatibilityCategory.sexuality => 1,
        _CompatibilityCategory.communication => 1,
        _ => 0,
      },
      ZodiacSign.cancer => switch (category) {
        _CompatibilityCategory.trust => 1,
        _CompatibilityCategory.communication => -1,
        _CompatibilityCategory.emotions => 2,
        _ => 0,
      },
      ZodiacSign.leo => switch (category) {
        _CompatibilityCategory.sexuality => 1,
        _CompatibilityCategory.communication => 1,
        _CompatibilityCategory.emotions => 1,
        _ => 0,
      },
      ZodiacSign.virgo => switch (category) {
        _CompatibilityCategory.sexuality => -1,
        _CompatibilityCategory.trust => 1,
        _CompatibilityCategory.coreValues => 2,
        _ => 0,
      },
      ZodiacSign.libra => switch (category) {
        _CompatibilityCategory.communication => 1,
        _CompatibilityCategory.emotions => 1,
        _ => 0,
      },
      ZodiacSign.scorpio => switch (category) {
        _CompatibilityCategory.sexuality => 2,
        _CompatibilityCategory.trust => -1,
        _CompatibilityCategory.emotions => 1,
        _ => 0,
      },
      ZodiacSign.sagittarius => switch (category) {
        _CompatibilityCategory.sexuality => 1,
        _CompatibilityCategory.communication => 1,
        _CompatibilityCategory.coreValues => -1,
        _ => 0,
      },
      ZodiacSign.capricorn => switch (category) {
        _CompatibilityCategory.emotions => -1,
        _CompatibilityCategory.trust => 1,
        _CompatibilityCategory.coreValues => 1,
        _ => 0,
      },
      ZodiacSign.aquarius => switch (category) {
        _CompatibilityCategory.communication => 2,
        _CompatibilityCategory.emotions => -1,
        _ => 0,
      },
      ZodiacSign.pisces => switch (category) {
        _CompatibilityCategory.trust => 1,
        _CompatibilityCategory.emotions => 2,
        _ => 0,
      },
    };
  }

  static int _maleCategoryBias(
    ZodiacSign sign,
    _CompatibilityCategory category,
  ) {
    return switch (sign) {
      ZodiacSign.aries => switch (category) {
        _CompatibilityCategory.sexuality => 2,
        _CompatibilityCategory.communication => 1,
        _CompatibilityCategory.emotions => -1,
        _ => 0,
      },
      ZodiacSign.taurus => switch (category) {
        _CompatibilityCategory.trust => 2,
        _CompatibilityCategory.communication => -1,
        _CompatibilityCategory.coreValues => 1,
        _ => 0,
      },
      ZodiacSign.gemini => switch (category) {
        _CompatibilityCategory.trust => -1,
        _CompatibilityCategory.communication => 2,
        _ => 0,
      },
      ZodiacSign.cancer => switch (category) {
        _CompatibilityCategory.trust => 1,
        _CompatibilityCategory.communication => -2,
        _CompatibilityCategory.emotions => 2,
        _ => 0,
      },
      ZodiacSign.leo => switch (category) {
        _CompatibilityCategory.sexuality => 1,
        _CompatibilityCategory.communication => 1,
        _CompatibilityCategory.coreValues => 1,
        _ => 0,
      },
      ZodiacSign.virgo => switch (category) {
        _CompatibilityCategory.trust => 1,
        _CompatibilityCategory.emotions => -1,
        _CompatibilityCategory.coreValues => 2,
        _ => 0,
      },
      ZodiacSign.libra => switch (category) {
        _CompatibilityCategory.trust => 1,
        _CompatibilityCategory.communication => 1,
        _ => 0,
      },
      ZodiacSign.scorpio => switch (category) {
        _CompatibilityCategory.sexuality => 2,
        _CompatibilityCategory.trust => -1,
        _CompatibilityCategory.communication => -2,
        _CompatibilityCategory.emotions => 1,
        _ => 0,
      },
      ZodiacSign.sagittarius => switch (category) {
        _CompatibilityCategory.sexuality => 2,
        _CompatibilityCategory.communication => 1,
        _CompatibilityCategory.coreValues => -2,
        _ => 0,
      },
      ZodiacSign.capricorn => switch (category) {
        _CompatibilityCategory.trust => 2,
        _CompatibilityCategory.emotions => -2,
        _CompatibilityCategory.coreValues => 2,
        _ => 0,
      },
      ZodiacSign.aquarius => switch (category) {
        _CompatibilityCategory.communication => 2,
        _CompatibilityCategory.emotions => -2,
        _ => 0,
      },
      ZodiacSign.pisces => switch (category) {
        _CompatibilityCategory.trust => 1,
        _CompatibilityCategory.communication => -1,
        _CompatibilityCategory.emotions => 2,
        _ => 0,
      },
    };
  }

  static int _directionVariance(
    _CompatibilityCategory category,
    GenerateCompatibilityRequestModel request,
  ) {
    final seed =
        (request.mySign.index + 1) * 19 +
        (request.partnerSign.index + 1) * 29 +
        (request.myGender.index + 1) * 7 +
        (request.partnerGender.index + 1) * 5 +
        category.index * 11;
    return seed % 9 - 4;
  }

  static bool _hasElement(ZodiacSign a, ZodiacSign b, ZodiacElement element) =>
      a.element == element || b.element == element;

  static bool _earthWaterPair(ZodiacSign a, ZodiacSign b) =>
      (a.element == ZodiacElement.earth && b.element == ZodiacElement.water) ||
      (a.element == ZodiacElement.water && b.element == ZodiacElement.earth);

  static bool _fireAirPair(ZodiacSign a, ZodiacSign b) =>
      (a.element == ZodiacElement.fire && b.element == ZodiacElement.air) ||
      (a.element == ZodiacElement.air && b.element == ZodiacElement.fire);

  static int _minDistance(ZodiacSign a, ZodiacSign b) {
    final dist = (a.index - b.index).abs();
    return dist > 6 ? 12 - dist : dist;
  }

  static bool _isWomanManPair(CompatGender a, CompatGender b) =>
      (a.isFemale && b.isMale) || (a.isMale && b.isFemale);

  static int _bounded(int value, int min, int max) => value.clamp(min, max);
}

enum _CompatibilityCategory {
  sexuality,
  trust,
  communication,
  emotions,
  coreValues,
}

enum _ScoreBand { low, mid, high }

class _CategorySpec {
  const _CategorySpec(
    this.category,
    this.emoji,
    this.labelKey,
    this.barColor,
  );

  final _CompatibilityCategory category;
  final String emoji;
  final String labelKey;
  final Color barColor;
}
