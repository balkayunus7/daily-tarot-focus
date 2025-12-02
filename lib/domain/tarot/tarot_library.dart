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
