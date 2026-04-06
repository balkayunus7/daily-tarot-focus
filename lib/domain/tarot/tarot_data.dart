import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class ContextualMeanings with EquatableMixin {
  const ContextualMeanings({
    required this.general,
    required this.love,
    required this.career,
    required this.spirituality,
  });

  factory ContextualMeanings.fromMap(Map<String, dynamic> map) {
    return ContextualMeanings(
      general: map['general'] as String? ?? '',
      love: map['love'] as String? ?? '',
      career: map['career'] as String? ?? '',
      spirituality: map['spirituality'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'general': general,
      'love': love,
      'career': career,
      'spirituality': spirituality,
    };
  }

  final String general;
  final String love;
  final String career;
  final String spirituality;

  @override
  List<Object?> get props => [general, love, career, spirituality];
}

class TarotCard with EquatableMixin {
  const TarotCard({
    required this.id,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.motto,
    required this.contextualMeanings,
    required this.advice,
    required this.affirmation,
    this.savedAt,
  });

  factory TarotCard.fromMap(Map<String, dynamic> map) {
    return TarotCard(
      id: map['id'] as String,
      title: map['title'] as String,
      motto: map['motto'] as String? ?? '',
      imagePath: map['imagePath'] as String? ?? '',
      category: TarotCategory.fromString(map['category'] as String? ?? ''),
      contextualMeanings: ContextualMeanings.fromMap(
        map['contextual_meanings'] as Map<String, dynamic>? ?? {},
      ),
      advice: map['advice'] as String? ?? '',
      affirmation: map['affirmation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'motto': motto,
      'imagePath': imagePath,
      'category': category.value,
      'contextual_meanings': contextualMeanings.toMap(),
      'advice': advice,
      'affirmation': affirmation,
    };
  }

  final String id;
  final String title;
  final String motto;
  final String imagePath;
  final TarotCategory category;
  final ContextualMeanings contextualMeanings;
  final String advice;
  final String affirmation;
  final DateTime? savedAt;

  TarotCard copyWith({
    String? id,
    String? title,
    String? motto,
    String? imagePath,
    TarotCategory? category,
    ContextualMeanings? contextualMeanings,
    String? advice,
    String? affirmation,
    DateTime? savedAt,
  }) {
    return TarotCard(
      id: id ?? this.id,
      title: title ?? this.title,
      motto: motto ?? this.motto,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      contextualMeanings: contextualMeanings ?? this.contextualMeanings,
      advice: advice ?? this.advice,
      affirmation: affirmation ?? this.affirmation,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    motto,
    imagePath,
    category,
    contextualMeanings,
    advice,
    affirmation,
    savedAt,
  ];
}
