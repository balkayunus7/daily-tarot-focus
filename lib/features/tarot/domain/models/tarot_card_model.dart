import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_category_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotCardModel with EquatableMixin {
  const TarotCardModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.correspondences,
    required this.symbols,
    required this.uprightKeywords,
    required this.reversedKeywords,
    required this.upright,
    required this.reversed,
    this.savedAt,
  });

  factory TarotCardModel.fromMap(Map<String, dynamic> map) {
    return TarotCardModel(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      imagePath: map['image_url'] as String? ?? '',
      category: TarotCategory.fromString(map['category'] as String? ?? ''),
      description: map['description'] as String? ?? '',
      correspondences: CorrespondencesModel.fromMap(
        map['correspondences'] as Map<String, dynamic>? ?? {},
      ),
      symbols:
          (map['symbols'] as List<dynamic>?)
              ?.map((s) => SymbolModel.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
      uprightKeywords:
          (map['upright_keywords'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      reversedKeywords:
          (map['reversed_keywords'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      upright: ReadingMeaningsModel.fromMap(
        map['upright'] as Map<String, dynamic>? ?? {},
      ),
      reversed: ReadingMeaningsModel.fromMap(
        map['reversed'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'category': category.value,
      'description': description,
      'correspondences': correspondences.toMap(),
      'symbols': symbols.map((s) => s.toMap()).toList(),
      'upright_keywords': uprightKeywords,
      'reversed_keywords': reversedKeywords,
      'upright': upright.toMap(),
      'reversed': reversed.toMap(),
    };
  }

  final String id;
  final String name;
  final String imagePath;
  final TarotCategory category;
  final String description;
  final CorrespondencesModel correspondences;
  final List<SymbolModel> symbols;
  final List<String> uprightKeywords;
  final List<String> reversedKeywords;
  final ReadingMeaningsModel upright;
  final ReadingMeaningsModel reversed;
  final DateTime? savedAt;

  TarotCardModel copyWith({
    String? id,
    String? name,
    String? imagePath,
    TarotCategory? category,
    String? description,
    CorrespondencesModel? correspondences,
    List<SymbolModel>? symbols,
    List<String>? uprightKeywords,
    List<String>? reversedKeywords,
    ReadingMeaningsModel? upright,
    ReadingMeaningsModel? reversed,
    DateTime? savedAt,
  }) {
    return TarotCardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      description: description ?? this.description,
      correspondences: correspondences ?? this.correspondences,
      symbols: symbols ?? this.symbols,
      uprightKeywords: uprightKeywords ?? this.uprightKeywords,
      reversedKeywords: reversedKeywords ?? this.reversedKeywords,
      upright: upright ?? this.upright,
      reversed: reversed ?? this.reversed,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    imagePath,
    category,
    description,
    correspondences,
    symbols,
    uprightKeywords,
    reversedKeywords,
    upright,
    reversed,
    savedAt,
  ];
}

/// Represents the astrological and elemental correspondences of a Tarot card.
class CorrespondencesModel with EquatableMixin {
  const CorrespondencesModel({
    required this.astrology,
    required this.element,
    required this.yesOrNo,
  });

  factory CorrespondencesModel.fromMap(Map<String, dynamic> map) {
    return CorrespondencesModel(
      astrology: map['astrology'] as String? ?? '',
      element: map['element'] as String? ?? '',
      yesOrNo: map['yes_or_no'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'astrology': astrology,
      'element': element,
      'yes_or_no': yesOrNo,
    };
  }

  final String astrology;
  final String element;
  final String yesOrNo;

  @override
  List<Object?> get props => [astrology, element, yesOrNo];
}

/// Represents a symbol on a Tarot card with its meaning.
class SymbolModel with EquatableMixin {
  const SymbolModel({required this.title, required this.meaning});

  factory SymbolModel.fromMap(Map<String, dynamic> map) {
    return SymbolModel(
      title: map['title'] as String? ?? '',
      meaning: map['meaning'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'meaning': meaning};
  }

  final String title;
  final String meaning;

  @override
  List<Object?> get props => [title, meaning];
}

/// Represents contextual meanings (General, Love, Career, Finances, Feelings, Actions)
/// for either the upright or reversed position of a Tarot card.
class ReadingMeaningsModel with EquatableMixin {
  const ReadingMeaningsModel({
    required this.general,
    required this.love,
    required this.career,
    required this.finances,
    required this.feelings,
    required this.actions,
  });

  factory ReadingMeaningsModel.fromMap(Map<String, dynamic> map) {
    return ReadingMeaningsModel(
      general: map['General'] as String? ?? '',
      love: map['Love'] as String? ?? '',
      career: map['Career'] as String? ?? '',
      finances: map['Finances'] as String? ?? '',
      feelings: map['Feelings'] as String? ?? '',
      actions: map['Actions'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'General': general,
      'Love': love,
      'Career': career,
      'Finances': finances,
      'Feelings': feelings,
      'Actions': actions,
    };
  }

  final String general;
  final String love;
  final String career;
  final String finances;
  final String feelings;
  final String actions;

  String byTopic(String topic) {
    return switch (topic.toLowerCase()) {
      'love' => love,
      'career' => career,
      'finances' => finances,
      'feelings' => feelings,
      'actions' => actions,
      'general' || _ => general,
    };
  }

  @override
  List<Object?> get props => [general, love, career, finances, feelings, actions];
}
