import 'package:mobile_boilerplate/domain/auth/session.dart';

sealed class TarotEvent {
  const TarotEvent();

  List<Object?> get props => [];
}

final class TarotDailyCardsFetched extends TarotEvent {
  const TarotDailyCardsFetched({required this.session, required this.languageCode});
  final Session session;
  final String languageCode;

  @override
  List<Object?> get props => [session, languageCode];
}

final class TarotDailyCardSaved extends TarotEvent {
  const TarotDailyCardSaved({
    required this.tarotCardId,
    required this.session,
    required this.languageCode,
  });
  final String tarotCardId;
  final Session session;
  final String languageCode;

  @override
  List<Object?> get props => [tarotCardId, session, languageCode];
}
