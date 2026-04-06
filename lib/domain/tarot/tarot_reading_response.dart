import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotReadingResponse with EquatableMixin {
  const TarotReadingResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory TarotReadingResponse.fromMap(Map<String, dynamic> map) {
    return TarotReadingResponse(
      success: map['success'] as bool? ?? false,
      data: TarotReadingData.fromMap(map['data'] as Map<String, dynamic>? ?? {}),
      meta: TarotReadingMeta.fromMap(map['meta'] as Map<String, dynamic>? ?? {}),
    );
  }

  final bool success;
  final TarotReadingData data;
  final TarotReadingMeta meta;

  @override
  List<Object?> get props => [success, data, meta];
}

class TarotReadingData with EquatableMixin {
  const TarotReadingData({
    required this.summary,
    required this.cards,
    required this.overallMessage,
    required this.affirmation,
    required this.energyLevel,
  });

  factory TarotReadingData.fromMap(Map<String, dynamic> map) {
    return TarotReadingData(
      summary: map['summary'] as String? ?? '',
      cards:
          (map['cards'] as List<dynamic>?)
              ?.map((e) => TarotReadingCardResponse.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      overallMessage: map['overall_message'] as String? ?? '',
      affirmation: map['affirmation'] as String? ?? '',
      energyLevel: map['energy_level'] as String? ?? '',
    );
  }

  final String summary;
  final List<TarotReadingCardResponse> cards;
  final String overallMessage;
  final String affirmation;
  final String energyLevel;

  @override
  List<Object?> get props => [summary, cards, overallMessage, affirmation, energyLevel];
}

class TarotReadingCardResponse with EquatableMixin {
  const TarotReadingCardResponse({
    required this.id,
    required this.position,
    required this.interpretation,
    required this.advice,
    required this.additionalNote,
  });

  factory TarotReadingCardResponse.fromMap(Map<String, dynamic> map) {
    return TarotReadingCardResponse(
      id: map['id'] as String? ?? '',
      position: map['position'] as String? ?? '',
      interpretation: map['interpretation'] as String? ?? '',
      advice: map['advice'] as String? ?? '',
      additionalNote: map['additional_note'] as String? ?? '',
    );
  }

  final String id;
  final String position;
  final String interpretation;
  final String advice;
  final String additionalNote;

  @override
  List<Object?> get props => [id, position, interpretation, advice, additionalNote];
}

class TarotReadingMeta with EquatableMixin {
  const TarotReadingMeta({
    required this.topic,
    required this.cardCount,
    required this.language,
    required this.createdAt,
  });

  factory TarotReadingMeta.fromMap(Map<String, dynamic> map) {
    return TarotReadingMeta(
      topic: map['topic'] as String? ?? '',
      cardCount: map['card_count'] as int? ?? 0,
      language: map['language'] as String? ?? '',
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at'] as String) : null,
    );
  }

  final String topic;
  final int cardCount;
  final String language;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [topic, cardCount, language, createdAt];
}
