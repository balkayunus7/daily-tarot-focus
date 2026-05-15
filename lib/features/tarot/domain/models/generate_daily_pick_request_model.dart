import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef GenerateDailyPickRequest = GenerateDailyPickRequestModel;

class GenerateDailyPickRequestModel with EquatableMixin {
  const GenerateDailyPickRequestModel({
    required this.session,
    required this.card,
    required this.isReversed,
    required this.date,
    this.locale = 'en',
  });

  final AuthSession session;
  final TarotCardModel card;
  final bool isReversed;
  final DateTime date;
  final String locale;

  Map<String, dynamic> toMap() {
    return {
      'locale': locale,
      'date': date.toIso8601String(),
      'card': {
        'id': card.id,
        'name': card.name,
        'category': card.category.value,
        'description': card.description,
        'upright_keywords': card.uprightKeywords,
        'reversed_keywords': card.reversedKeywords,
        'upright': card.upright.toMap(),
        'reversed': card.reversed.toMap(),
        'correspondences': card.correspondences.toMap(),
      },
      'is_reversed': isReversed,
    };
  }

  @override
  List<Object?> get props => [session, card, isReversed, date, locale];
}
