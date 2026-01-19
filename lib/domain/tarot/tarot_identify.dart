import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotIdentify with EquatableMixin {
  const TarotIdentify({
    required this.title,
    required this.description,
    required this.advices,
    required this.warnings,
    required this.meanings,
  });

  factory TarotIdentify.fromMap(Map<String, dynamic> map) {
    return TarotIdentify(
      title: map['title'] as String,
      description: map['description'] as String,
      advices: (map['advices'] as List?) != null ? (map['advices'] as List) as List<String> : null,
      warnings: (map['warnings'] as List?) != null ? (map['warnings'] as List) as List<String> : null,
      meanings: (map['meanings'] as List?) != null ? (map['meanings'] as List) as List<String> : null,
    );
  }

  bool get hasAdvice => advices != null && advices!.isNotEmpty;
  bool get hasWarnings => warnings != null && warnings!.isNotEmpty;
  bool get hasMeanings => meanings != null && meanings!.isNotEmpty;

  final String title;
  final String description;
  final List<String>? advices;
  final List<String>? warnings;
  final List<String>? meanings;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'advices': advices,
      'warnings': warnings,
      'meanings': meanings,
    };
  }

  TarotIdentify copyWith({
    String? title,
    String? description,
    List<String>? advices,
    List<String>? warnings,
    List<String>? meanings,
  }) {
    return TarotIdentify(
      title: title ?? this.title,
      description: description ?? this.description,
      advices: advices ?? this.advices,
      warnings: warnings ?? this.warnings,
      meanings: meanings ?? this.meanings,
    );
  }

  @override
  List<Object?> get props => [title, description, advices, warnings, meanings];
}
