import 'package:mobile_boilerplate/common_dependencies.dart';

class ReadingResponseModel with EquatableMixin {
  const ReadingResponseModel({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory ReadingResponseModel.fromMap(Map<String, dynamic> map) {
    return ReadingResponseModel(
      success: map['success'] as bool? ?? false,
      data: ReadingDataResponseModel.fromMap(
        map['data'] as Map<String, dynamic>? ?? {},
      ),
      meta: ReadingMetaResponseModel.fromMap(
        map['meta'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  final bool success;
  final ReadingDataResponseModel data;
  final ReadingMetaResponseModel meta;

  @override
  List<Object?> get props => [success, data, meta];
}

class ReadingDataResponseModel with EquatableMixin {
  const ReadingDataResponseModel({
    required this.summary,
    required this.cards,
    required this.overallMessage,
    required this.affirmation,
    required this.energyLevel,
  });

  factory ReadingDataResponseModel.fromMap(Map<String, dynamic> map) {
    return ReadingDataResponseModel(
      summary: map['summary'] as String? ?? '',
      cards:
          (map['cards'] as List<dynamic>?)
              ?.map(
                (e) => ReadingCardResponseModel.fromMap(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      overallMessage: map['overall_message'] as String? ?? '',
      affirmation: map['affirmation'] as String? ?? '',
      energyLevel: map['energy_level'] as String? ?? '',
    );
  }

  final String summary;
  final List<ReadingCardResponseModel> cards;
  final String overallMessage;
  final String affirmation;
  final String energyLevel;

  @override
  List<Object?> get props => [summary, cards, overallMessage, affirmation, energyLevel];
}

class ReadingCardResponseModel with EquatableMixin {
  const ReadingCardResponseModel({
    required this.id,
    required this.position,
    required this.interpretation,
    required this.advice,
    required this.additionalNote,
  });

  factory ReadingCardResponseModel.fromMap(Map<String, dynamic> map) {
    return ReadingCardResponseModel(
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

class ReadingMetaResponseModel with EquatableMixin {
  const ReadingMetaResponseModel({
    required this.topic,
    required this.cardCount,
    required this.language,
    required this.createdAt,
  });

  factory ReadingMetaResponseModel.fromMap(Map<String, dynamic> map) {
    return ReadingMetaResponseModel(
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

typedef ReadingResponse = ReadingResponseModel;
typedef ReadingData = ReadingDataResponseModel;
typedef ReadingCardResponse = ReadingCardResponseModel;
typedef ReadingMeta = ReadingMetaResponseModel;
