import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';

class TarotLibrary {
  const TarotLibrary({
    required this.title,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.meanings,
    required this.uprightMeanings,
    required this.reversedMeanings,
  });

  factory TarotLibrary.fromMap(Map<String, dynamic> map) {
    return TarotLibrary(
      title: map['title'] as String,
      description: map['description'] as String,
      imagePath: map['imagePath'] as String,
      category: TarotCategory.fromString(map['category'] as String),
      meanings: map['meanings'] as List<String>,
      uprightMeanings: map['uprightMeanings'] as List<String>,
      reversedMeanings: map['reversedMeanings'] as List<String>,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'category': category.value,
      'meanings': meanings,
      'uprightMeanings': uprightMeanings,
      'reversedMeanings': reversedMeanings,
    };
  }

  final String title;
  final String description;
  final String imagePath;
  final TarotCategory category;
  final List<String> meanings;
  final List<String> uprightMeanings;
  final List<String> reversedMeanings;

  TarotLibrary copyWith({
    String? title,
    String? description,
    String? imagePath,
    TarotCategory? category,
    List<String>? meanings,
    List<String>? uprightMeanings,
    List<String>? reversedMeanings,
  }) {
    return TarotLibrary(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      meanings: meanings ?? this.meanings,
      uprightMeanings: uprightMeanings ?? this.uprightMeanings,
      reversedMeanings: reversedMeanings ?? this.reversedMeanings,
    );
  }
}
