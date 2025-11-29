class Tarot {
  const Tarot({
    required this.tarotTitle,
    required this.tarotDescription,
    required this.tarotAdvices,
    required this.tarotWarnings,
    required this.tarotMeanings,
  });

  factory Tarot.fromMap(Map<String, dynamic> map) {
    return Tarot(
      tarotTitle: map['tarot_title'] as String,
      tarotDescription: map['tarot_description'] as String,
      tarotAdvices: List<String>.from(map['tarot_advices'] as List),
      tarotWarnings: List<String>.from(map['tarot_warnings'] as List),
      tarotMeanings: List<String>.from(map['tarot_meanings'] as List),
    );
  }

  final String tarotTitle;
  final String tarotDescription;
  final List<String> tarotAdvices;
  final List<String> tarotWarnings;
  final List<String> tarotMeanings;

  Map<String, dynamic> toMap() {
    return {
      'tarot_title': tarotTitle,
      'tarot_description': tarotDescription,
      'tarot_advices': tarotAdvices,
      'tarot_warnings': tarotWarnings,
      'tarot_meanings': tarotMeanings,
    };
  }

  Tarot copyWith({
    String? tarotTitle,
    String? tarotDescription,
    List<String>? tarotAdvices,
    List<String>? tarotWarnings,
    List<String>? tarotMeanings,
  }) {
    return Tarot(
      tarotTitle: tarotTitle ?? this.tarotTitle,
      tarotDescription: tarotDescription ?? this.tarotDescription,
      tarotAdvices: tarotAdvices ?? this.tarotAdvices,
      tarotWarnings: tarotWarnings ?? this.tarotWarnings,
      tarotMeanings: tarotMeanings ?? this.tarotMeanings,
    );
  }
}
