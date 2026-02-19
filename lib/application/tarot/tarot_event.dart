import 'package:mobile_boilerplate/domain/auth/session.dart';

sealed class TarotEvent {
  const TarotEvent();

  List<Object?> get props => [];
}

final class TarotDailyCardsFetched extends TarotEvent {
  const TarotDailyCardsFetched({required this.session});
  final Session session;

  @override
  List<Object?> get props => [session];
}

final class TarotDailyCardSaved extends TarotEvent {
  const TarotDailyCardSaved({required this.tarotCardId, required this.session});
  final String tarotCardId;
  final Session session;

  @override
  List<Object?> get props => [tarotCardId, session];
}
