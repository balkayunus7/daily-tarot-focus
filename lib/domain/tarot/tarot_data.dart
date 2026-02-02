import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotData with EquatableMixin {
  const TarotData({
    required this.title,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.meanings,
    required this.uprightMeanings,
    required this.reversedMeanings,
    required this.advices,
    required this.warnings,
  });

  factory TarotData.fromMap(Map<String, dynamic> map) {
    return TarotData(
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

  final String title;
  final String description;
  final String imagePath;
  final TarotCategory category;
  final List<String> meanings;
  final List<String> uprightMeanings;
  final List<String> reversedMeanings;
  final List<String> advices;
  final List<String> warnings;

  bool get hasAdvices => advices.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasMeanings => meanings.isNotEmpty;

  TarotData copyWith({
    String? title,
    String? description,
    String? imagePath,
    TarotCategory? category,
    List<String>? meanings,
    List<String>? uprightMeanings,
    List<String>? reversedMeanings,
    List<String>? advices,
    List<String>? warnings,
  }) {
    return TarotData(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      meanings: meanings ?? this.meanings,
      uprightMeanings: uprightMeanings ?? this.uprightMeanings,
      reversedMeanings: reversedMeanings ?? this.reversedMeanings,
      advices: advices ?? this.advices,
      warnings: warnings ?? this.warnings,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        imagePath,
        category,
        meanings,
        uprightMeanings,
        reversedMeanings,
        advices,
        warnings,
      ];
}
