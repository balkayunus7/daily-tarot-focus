import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotCard with EquatableMixin {
  const TarotCard({
    required this.id,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.meanings,
    required this.uprightMeanings,
    required this.reversedMeanings,
    required this.advices,
    required this.warnings,
    this.savedAt,
  });

  factory TarotCard.fromMap(Map<String, dynamic> map) {
    return TarotCard(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imagePath: map['imagePath'] as String,
      category: TarotCategory.fromString(map['category'] as String),
      meanings: List<String>.from(map['meanings'] as List),
      uprightMeanings: List<String>.from(map['uprightMeanings'] as List),
      reversedMeanings: List<String>.from(map['reversedMeanings'] as List),
      advices: List<String>.from(map['advices'] as List),
      warnings: List<String>.from(map['warnings'] as List),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'category': category.value,
      'meanings': meanings,
      'uprightMeanings': uprightMeanings,
      'reversedMeanings': reversedMeanings,
      'advices': advices,
      'warnings': warnings,
    };
  }

  final String id;
  final String title;
  final String description;
  final String imagePath;
  final TarotCategory category;
  final List<String> meanings;
  final List<String> uprightMeanings;
  final List<String> reversedMeanings;
  final List<String> advices;
  final List<String> warnings;
  final DateTime? savedAt;

  bool get hasAdvices => advices.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasMeanings => meanings.isNotEmpty;

  TarotCard copyWith({
    String? id,
    String? title,
    String? description,
    String? imagePath,
    TarotCategory? category,
    List<String>? meanings,
    List<String>? uprightMeanings,
    List<String>? reversedMeanings,
    List<String>? advices,
    List<String>? warnings,
    DateTime? savedAt,
  }) {
    return TarotCard(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      meanings: meanings ?? this.meanings,
      uprightMeanings: uprightMeanings ?? this.uprightMeanings,
      reversedMeanings: reversedMeanings ?? this.reversedMeanings,
      advices: advices ?? this.advices,
      warnings: warnings ?? this.warnings,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imagePath,
    category,
    meanings,
    uprightMeanings,
    reversedMeanings,
    advices,
    warnings,
    savedAt,
  ];
}
