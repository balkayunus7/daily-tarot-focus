import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

class GenerateReadingRequest with EquatableMixin {
  const GenerateReadingRequest({
    required this.session,
    required this.spreadCategoryId,
    required this.spreadId,
    required this.readerId,
    this.question,
    required this.cards,
  });

  final AuthSession session;
  final String spreadCategoryId;
  final String spreadId;
  final String readerId;
  final String? question;
  final List<GenerateReadingCardRequest> cards;

  Map<String, dynamic> toMap() {
    return {
      'spread_category_id': spreadCategoryId,
      'spread_id': spreadId,
      'reader_id': readerId,
      'question': question,
      'cards': cards.map((c) => c.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [session, spreadCategoryId, spreadId, readerId, question, cards];
}

class GenerateReadingCardRequest with EquatableMixin {
  const GenerateReadingCardRequest({
    required this.cardId,
    required this.positionIndex,
    required this.isReversed,
  });

  final String cardId;
  final int positionIndex;
  final bool isReversed;

  Map<String, dynamic> toMap() {
    return {
      'card_id': cardId,
      'position_index': positionIndex,
      'is_reversed': isReversed,
    };
  }

  @override
  List<Object?> get props => [cardId, positionIndex, isReversed];
}
