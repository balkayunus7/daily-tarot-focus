import 'package:mobile_boilerplate/common_dependencies.dart';

class GenerateReadingResponse with EquatableMixin {
  const GenerateReadingResponse({
    required this.id,
    required this.spreadId,
    required this.cardInterpretations,
    required this.generalInterpretation,
  });

  factory GenerateReadingResponse.fromMap(Map<String, dynamic> map) {
    return GenerateReadingResponse(
      id: map['id'] as String? ?? '',
      spreadId: map['spread_id'] as String? ?? '',
      cardInterpretations: (map['card_interpretations'] as List<dynamic>? ?? [])
          .map((e) => CardInterpretationModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      generalInterpretation: map['general_interpretation'] as String? ?? '',
    );
  }

  final String id;
  final String spreadId;
  final List<CardInterpretationModel> cardInterpretations;
  final String generalInterpretation;

  @override
  List<Object?> get props => [id, spreadId, cardInterpretations, generalInterpretation];
}

class CardInterpretationModel with EquatableMixin {
  const CardInterpretationModel({
    required this.positionIndex,
    required this.cardId,
    required this.cardName,
    required this.isReversed,
    required this.interpretation,
  });

  factory CardInterpretationModel.fromMap(Map<String, dynamic> map) {
    return CardInterpretationModel(
      positionIndex: map['position_index'] as int? ?? 0,
      cardId: map['card_id'] as String? ?? '',
      cardName: map['card_name'] as String? ?? '',
      isReversed: map['is_reversed'] as bool? ?? false,
      interpretation: map['interpretation'] as String? ?? '',
    );
  }

  final int positionIndex;
  final String cardId;
  final String cardName;
  final bool isReversed;
  final String interpretation;

  @override
  List<Object?> get props => [positionIndex, cardId, cardName, isReversed, interpretation];
}
