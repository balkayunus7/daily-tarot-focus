import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_response_model.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef SaveReadingRequest = SaveReadingRequestModel;

class SaveReadingRequestModel {
  const SaveReadingRequestModel({
    required this.session,
    required this.spreadId,
    required this.cardInterpretations,
    required this.generalInterpretation,
    this.readerId,
    this.question,
    this.note,
  });
  Map<String, dynamic> toMap() {
    return {
      'spread_id': spreadId,
      'reader_id': readerId,
      'question': question,
      'card_interpretations': cardInterpretations.map((c) => c.toMap()).toList(),
      'general_interpretation': generalInterpretation,
      'note': note,
    };
  }

  List<Object?> get props => [
    session,
    spreadId,
    readerId,
    question,
    cardInterpretations,
    generalInterpretation,
    note,
  ];

  final AuthSession session;
  final String spreadId;
  final String? readerId;
  final String? question;
  final List<CardInterpretationModel> cardInterpretations;
  final String generalInterpretation;
  final String? note;
}
