import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

typedef GenerateDailyPickResponse = GenerateDailyPickResponseModel;

class DailyPickCategoryInsight with EquatableMixin {
  const DailyPickCategoryInsight({
    required this.emoji,
    required this.labelKey,
    required this.description,
    required this.color,
  });

  factory DailyPickCategoryInsight.fromSavedMap(Map<String, dynamic> map) {
    final labelKey = map['label_key'] as String? ?? '';
    final index = _labelKeys.indexOf(labelKey);
    final safeIndex = index < 0 ? 0 : index;
    return DailyPickCategoryInsight(
      emoji: _emojis[safeIndex],
      labelKey: labelKey.isEmpty ? _labelKeys[safeIndex] : labelKey,
      description: map['description'] as String? ?? '',
      color: _colors[safeIndex],
    );
  }

  final String emoji;
  final String labelKey;
  final String description;
  final Color color;

  @override
  List<Object?> get props => [emoji, labelKey, description, color];
}

const List<String> _emojis = ['❤️', '💰', '💼', '🩺', '🏠'];
const List<String> _labelKeys = [
  LocaleKeys.horoscope_page_category_love,
  LocaleKeys.horoscope_page_category_finance,
  LocaleKeys.horoscope_page_category_career,
  LocaleKeys.horoscope_page_category_health,
  LocaleKeys.horoscope_page_category_family,
];
const List<Color> _colors = [
  Color(0xFFE05A5A),
  Color(0xFFE07E5A),
  Color(0xFF5AE09E),
  Color(0xFF5A9EE0),
  Color(0xFF9E5AE0),
];

class GenerateDailyPickResponseModel with EquatableMixin {
  const GenerateDailyPickResponseModel({
    required this.generalText,
    required this.categories,
    required this.dailyAdvice,
  });

  factory GenerateDailyPickResponseModel.fromMap(Map<String, dynamic> map) {
    final cats = map['categories'] as List<dynamic>? ?? [];

    String descAt(int i) =>
        i < cats.length
            ? ((cats[i] as Map<String, dynamic>)['description'] as String?) ??
                ''
            : '';

    return GenerateDailyPickResponseModel(
      generalText: map['general_text'] as String? ?? '',
      categories: [
        DailyPickCategoryInsight(
          emoji: '❤️',
          labelKey: LocaleKeys.horoscope_page_category_love,
          description: descAt(0),
          color: const Color(0xFFE05A5A),
        ),
        DailyPickCategoryInsight(
          emoji: '💰',
          labelKey: LocaleKeys.horoscope_page_category_finance,
          description: descAt(1),
          color: const Color(0xFFE07E5A),
        ),
        DailyPickCategoryInsight(
          emoji: '💼',
          labelKey: LocaleKeys.horoscope_page_category_career,
          description: descAt(2),
          color: const Color(0xFF5AE09E),
        ),
        DailyPickCategoryInsight(
          emoji: '🩺',
          labelKey: LocaleKeys.horoscope_page_category_health,
          description: descAt(3),
          color: const Color(0xFF5A9EE0),
        ),
        DailyPickCategoryInsight(
          emoji: '🏠',
          labelKey: LocaleKeys.horoscope_page_category_family,
          description: descAt(4),
          color: const Color(0xFF9E5AE0),
        ),
      ],
      dailyAdvice: map['daily_advice'] as String? ?? '',
    );
  }

  final String generalText;
  final List<DailyPickCategoryInsight> categories;
  final String dailyAdvice;

  @override
  List<Object?> get props => [generalText, categories, dailyAdvice];
}
