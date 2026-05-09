import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class HoroscopeStatCategory with EquatableMixin {
  const HoroscopeStatCategory({
    required this.emoji,
    required this.labelKey,
    required this.score,
    required this.barColor,
    required this.description,
  });

  final String emoji;
  final String labelKey;
  final int score;
  final Color barColor;
  final String description;

  @override
  List<Object?> get props => [emoji, labelKey, score, barColor, description];
}

class HoroscopeTipModel with EquatableMixin {
  const HoroscopeTipModel({required this.isAdvice, required this.text});
  final bool isAdvice;
  final String text;

  @override
  List<Object?> get props => [isAdvice, text];
}

class HoroscopeCriticalDaysModel with EquatableMixin {
  const HoroscopeCriticalDaysModel({required this.challenging, required this.highlight});

  final String challenging;
  final String highlight;

  @override
  List<Object?> get props => [challenging, highlight];
}

class HoroscopeResponseModel with EquatableMixin {
  const HoroscopeResponseModel({
    required this.generalText,
    required this.categories,
    required this.tips,
    required this.criticalDays,
  });

  factory HoroscopeResponseModel.fromMap(Map<String, dynamic> map) {
    final generalText = map['general_text'] as String? ?? '';
    final cats = map['categories'] as List<dynamic>? ?? [];
    final tipsRaw = map['tips'] as List<dynamic>? ?? [];
    final criticalRaw = map['critical_days'] as Map<String, dynamic>? ?? {};

    int scoreAt(int i) =>
        i < cats.length ? ((cats[i] as Map<String, dynamic>)['score'] as num?)?.toInt() ?? 0 : 0;
    String descAt(int i) =>
        i < cats.length
            ? ((cats[i] as Map<String, dynamic>)['description'] as String?) ?? ''
            : '';

    return HoroscopeResponseModel(
      generalText: generalText,
      categories: [
        HoroscopeStatCategory(
          emoji: '❤️',
          labelKey: LocaleKeys.horoscope_page_category_love,
          score: scoreAt(0),
          barColor: const Color(0xFFE05A5A),
          description: descAt(0),
        ),
        HoroscopeStatCategory(
          emoji: '💰',
          labelKey: LocaleKeys.horoscope_page_category_finance,
          score: scoreAt(1),
          barColor: const Color(0xFFE07E5A),
          description: descAt(1),
        ),
        HoroscopeStatCategory(
          emoji: '💼',
          labelKey: LocaleKeys.horoscope_page_category_career,
          score: scoreAt(2),
          barColor: const Color(0xFF5AE09E),
          description: descAt(2),
        ),
        HoroscopeStatCategory(
          emoji: '🩺',
          labelKey: LocaleKeys.horoscope_page_category_health,
          score: scoreAt(3),
          barColor: const Color(0xFF5A9EE0),
          description: descAt(3),
        ),
        HoroscopeStatCategory(
          emoji: '🏠',
          labelKey: LocaleKeys.horoscope_page_category_family,
          score: scoreAt(4),
          barColor: const Color(0xFF9E5AE0),
          description: descAt(4),
        ),
      ],
      tips: tipsRaw.map((e) {
        final t = e as Map<String, dynamic>;
        return HoroscopeTipModel(
          isAdvice: t['is_advice'] as bool? ?? true,
          text: t['text'] as String? ?? '',
        );
      }).toList(),
      criticalDays: HoroscopeCriticalDaysModel(
        challenging: criticalRaw['challenging'] as String? ?? '',
        highlight: criticalRaw['highlight'] as String? ?? '',
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'general_text': generalText,
      'categories': categories.map((c) => {
        'score': c.score,
        'description': c.description,
      }).toList(),
      'tips': tips.map((t) => {
        'is_advice': t.isAdvice,
        'text': t.text,
      }).toList(),
      'critical_days': {
        'challenging': criticalDays.challenging,
        'highlight': criticalDays.highlight,
      },
    };
  }

  final String generalText;
  final List<HoroscopeStatCategory> categories;
  final List<HoroscopeTipModel> tips;
  final HoroscopeCriticalDaysModel criticalDays;

  @override
  List<Object?> get props => [generalText, categories, tips, criticalDays];
}

List<HoroscopeStatCategory> buildDefaultHoroscopeCategories() => [
  const HoroscopeStatCategory(
    emoji: '❤️',
    labelKey: LocaleKeys.horoscope_page_category_love,
    score: 0,
    barColor: Color(0xFFE05A5A),
    description: '',
  ),
  const HoroscopeStatCategory(
    emoji: '💰',
    labelKey: LocaleKeys.horoscope_page_category_finance,
    score: 0,
    barColor: Color(0xFFE07E5A),
    description: '',
  ),
  const HoroscopeStatCategory(
    emoji: '💼',
    labelKey: LocaleKeys.horoscope_page_category_career,
    score: 0,
    barColor: Color(0xFF5AE09E),
    description: '',
  ),
  const HoroscopeStatCategory(
    emoji: '🩺',
    labelKey: LocaleKeys.horoscope_page_category_health,
    score: 0,
    barColor: Color(0xFF5A9EE0),
    description: '',
  ),
  const HoroscopeStatCategory(
    emoji: '🏠',
    labelKey: LocaleKeys.horoscope_page_category_family,
    score: 0,
    barColor: Color(0xFF9E5AE0),
    description: '',
  ),
];
