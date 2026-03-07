import 'package:mobile_boilerplate/domain/auth/tarot_session.dart';

sealed class TarotEvent {
  const TarotEvent();

  List<Object?> get props => [];
}

final class TarotDailyCardsFetched extends TarotEvent {
  const TarotDailyCardsFetched({required this.session, required this.languageCode});
  final TarotSession session;
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
  final TarotSession session;
  final String languageCode;

  @override
  List<Object?> get props => [tarotCardId, session, languageCode];
}
