import 'package:daily_tarot_focus/domain/tarot/tarot_question_data.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

sealed class TarotEvent {
  const TarotEvent();

  List<Object?> get props => [];
}

final class TarotDailyCardsFetched extends TarotEvent {
  const TarotDailyCardsFetched({required this.session, required this.languageCode});
  final AuthSession session;
  final String languageCode;

  @override
  List<Object?> get props => [session, languageCode];
}

final class TarotDailyCardSaved extends TarotEvent {
  const TarotDailyCardSaved({
    required this.session,
    required this.tarotCardId,
    required this.languageCode,
  });
  final String tarotCardId;
  final AuthSession session;
  final String languageCode;

  @override
  List<Object?> get props => [tarotCardId, session, languageCode];
}

final class TarotQuestionAsked extends TarotEvent {
  const TarotQuestionAsked({
    required this.session,
    required this.tarotQuestionData,
    required this.languageCode,
  });
  final AuthSession session;
  final TarotQuestionData tarotQuestionData;
  final String languageCode;

  @override
  List<Object?> get props => [session, tarotQuestionData, languageCode];
}
