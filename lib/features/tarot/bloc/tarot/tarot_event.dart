import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';

sealed class TarotEvent {
  const TarotEvent();
  List<Object?> get props => [];
}

final class TarotFetchDailyCardsRequested extends TarotEvent {
  const TarotFetchDailyCardsRequested({required this.request});
  final FetchDailyCardsRequest request;

  @override
  List<Object?> get props => [request.session];
}

final class TarotRecordDailyCardRequested extends TarotEvent {
  const TarotRecordDailyCardRequested({required this.request});
  final RecordDailyCardRequest request;

  @override
  List<Object?> get props => [request.cardId, request.session];
}

final class TarotReadingRequested extends TarotEvent {
  const TarotReadingRequested({required this.request});
  final ReadingRequest request;

  @override
  List<Object?> get props => [request.session, request.data];
}
