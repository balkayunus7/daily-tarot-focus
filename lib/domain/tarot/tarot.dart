class Tarot {
  const Tarot({
    required this.title,
    required this.description,
    required this.advices,
    required this.warnings,
    required this.meanings,
  });

  factory Tarot.fromMap(Map<String, dynamic> map) {
    return Tarot(
      title: map['title'] as String,
      description: map['description'] as String,
      advices: List<String>.from(map['advices'] as List),
      warnings: List<String>.from(map['warnings'] as List),
      meanings: List<String>.from(map['meanings'] as List),
    );
  }

  final String title;
  final String description;
  final List<String> advices;
  final List<String> warnings;
  final List<String> meanings;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'advices': advices,
      'warnings': warnings,
      'meanings': meanings,
    };
  }

  Tarot copyWith({
    String? title,
    String? description,
    List<String>? advices,
    List<String>? warnings,
    List<String>? meanings,
  }) {
    return Tarot(
      title: title ?? this.title,
      description: description ?? this.description,
      advices: advices ?? this.advices,
      warnings: warnings ?? this.warnings,
      meanings: meanings ?? this.meanings,
    );
  }
}
