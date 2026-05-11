import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

typedef GenerateCompatibilityResponse = GenerateCompatibilityResponseModel;

class CompatibilityCategoryModel with EquatableMixin {
  const CompatibilityCategoryModel({
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

class GenerateCompatibilityResponseModel with EquatableMixin {
  const GenerateCompatibilityResponseModel({
    required this.summary,
    required this.overallScore,
    required this.categories,
  });

  factory GenerateCompatibilityResponseModel.fromMap(Map<String, dynamic> map) {
    final summary = map['summary'] as String? ?? '';
    final overallScore = (map['overall_score'] as num?)?.toInt() ?? 0;
    final cats = map['categories'] as List<dynamic>? ?? [];

    int scoreAt(int i) =>
        i < cats.length ? ((cats[i] as Map<String, dynamic>)['score'] as num?)?.toInt() ?? 0 : 0;
    String descAt(int i) =>
        i < cats.length
            ? ((cats[i] as Map<String, dynamic>)['description'] as String?) ?? ''
            : '';

    return GenerateCompatibilityResponseModel(
      summary: summary,
      overallScore: overallScore,
      categories: [
        CompatibilityCategoryModel(
          emoji: '⚡',
          labelKey: LocaleKeys.compat_page_category_sexuality,
          score: scoreAt(0),
          barColor: const Color(0xFFE05A5A),
          description: descAt(0),
        ),
        CompatibilityCategoryModel(
          emoji: '🤝',
          labelKey: LocaleKeys.compat_page_category_trust,
          score: scoreAt(1),
          barColor: const Color(0xFF5A9EE0),
          description: descAt(1),
        ),
        CompatibilityCategoryModel(
          emoji: '💬',
          labelKey: LocaleKeys.compat_page_category_communication,
          score: scoreAt(2),
          barColor: const Color(0xFF5AE09E),
          description: descAt(2),
        ),
        CompatibilityCategoryModel(
          emoji: '💜',
          labelKey: LocaleKeys.compat_page_category_emotions,
          score: scoreAt(3),
          barColor: const Color(0xFF9E5AE0),
          description: descAt(3),
        ),
        CompatibilityCategoryModel(
          emoji: '🌿',
          labelKey: LocaleKeys.compat_page_category_values,
          score: scoreAt(4),
          barColor: const Color(0xFFE0B85A),
          description: descAt(4),
        ),
      ],
    );
  }

  final String summary;
  final int overallScore;
  final List<CompatibilityCategoryModel> categories;

  Map<String, dynamic> toMap() => {
    'summary': summary,
    'overall_score': overallScore,
    'categories': categories
        .map((c) => {'score': c.score, 'description': c.description})
        .toList(),
  };

  String get titleKey {
    if (overallScore >= 70) return LocaleKeys.compat_page_title_high;
    if (overallScore >= 50) return LocaleKeys.compat_page_title_medium;
    if (overallScore >= 30) return LocaleKeys.compat_page_title_low;
    return LocaleKeys.compat_page_title_very_low;
  }

  @override
  List<Object?> get props => [summary, overallScore, categories];
}
