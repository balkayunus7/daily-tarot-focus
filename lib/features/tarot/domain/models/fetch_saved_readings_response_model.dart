import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_response_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

typedef FetchSavedReadingsResponse = FetchSavedReadingsResponseModel;

class FetchSavedReadingsResponseModel with EquatableMixin {
  const FetchSavedReadingsResponseModel({required this.readings});

  factory FetchSavedReadingsResponseModel.fromMap(Map<String, dynamic> map) {
    final list = map['readings'] as List<dynamic>? ?? [];
    return FetchSavedReadingsResponseModel(
      readings: KtList.from(
        list.map((e) => SavedReadingModel.fromMap(e as Map<String, dynamic>)),
      ),
    );
  }

  final KtList<SavedReadingModel> readings;

  @override
  List<Object?> get props => [readings];
}

class SavedReadingModel with EquatableMixin {
  const SavedReadingModel({
    required this.id,
    required this.spreadId,
    required this.cardInterpretations,
    required this.generalInterpretation,
    required this.createdAt,
    this.readerId,
    this.question,
    this.note,
  });

  factory SavedReadingModel.fromMap(Map<String, dynamic> map) {
    return SavedReadingModel(
      id: map['id'] as String,
      spreadId: map['spread_id'] as String,
      readerId: map['reader_id'] as String?,
      question: map['question'] as String?,
      cardInterpretations: (map['card_interpretations'] as List<dynamic>? ?? [])
          .map((e) => CardInterpretationModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      generalInterpretation: map['general_interpretation'] as String,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  final String id;
  final String spreadId;
  final String? readerId;
  final String? question;
  final List<CardInterpretationModel> cardInterpretations;
  final String generalInterpretation;
  final String? note;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, spreadId, readerId, question, cardInterpretations, generalInterpretation, note, createdAt];
}
