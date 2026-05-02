import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_saved_readings_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/save_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_flow_type.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reading_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/update_reading_note_request_model.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

sealed class TarotEvent {
  const TarotEvent();
  List<Object?> get props => [];
}

//// FETCH AND POST EVENTS
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

final class TarotFetchAllCardsRequested extends TarotEvent {
  const TarotFetchAllCardsRequested({required this.request});
  final FetchAllCardsRequest request;

  @override
  List<Object?> get props => [request.session];
}

final class TarotFetchSpreadsRequested extends TarotEvent {
  const TarotFetchSpreadsRequested({required this.request});
  final FetchSpreadsRequest request;

  @override
  List<Object?> get props => [request.session];
}

final class TarotFetchReadersRequested extends TarotEvent {
  const TarotFetchReadersRequested({required this.request});
  final FetchReadersRequest request;

  @override
  List<Object?> get props => [request.session];
}

//// SELECT QUESTION EVENTS
final class TarotSelectSpreadCategory extends TarotEvent {
  const TarotSelectSpreadCategory({required this.category});
  final TarotSpreadCategoryModel category;

  @override
  List<Object?> get props => [category];
}

final class TarotSelectSpread extends TarotEvent {
  const TarotSelectSpread({required this.spread});
  final TarotSpreadModel spread;

  @override
  List<Object?> get props => [spread];
}

final class TarotSelectReader extends TarotEvent {
  const TarotSelectReader({required this.reader});
  final TarotReaderModel reader;

  @override
  List<Object?> get props => [reader];
}

final class TarotSetupAccountRequested extends TarotEvent {
  const TarotSetupAccountRequested({required this.session});
  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

final class TarotSelectQuestion extends TarotEvent {
  const TarotSelectQuestion({required this.question});
  final String question;

  @override
  List<Object?> get props => [question];
}

final class TarotSetReadingCards extends TarotEvent {
  const TarotSetReadingCards({required this.cards});
  final List<TarotSelectedReadingCard> cards;

  @override
  List<Object?> get props => [cards];
}

final class TarotGenerateReadingRequested extends TarotEvent {
  const TarotGenerateReadingRequested({required this.session});
  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

final class TarotSetFlowType extends TarotEvent {
  const TarotSetFlowType({required this.flowType});
  final TarotFlowType flowType;

  @override
  List<Object?> get props => [flowType];
}

final class TarotSaveReadingRequested extends TarotEvent {
  const TarotSaveReadingRequested({required this.request});
  final SaveReadingRequest request;

  @override
  List<Object?> get props => [request.spreadId, request.note, request.session];
}

final class TarotFetchSavedReadingsRequested extends TarotEvent {
  const TarotFetchSavedReadingsRequested({required this.request});
  final FetchSavedReadingsRequest request;

  @override
  List<Object?> get props => [request.session];
}

final class TarotReadingFlowReset extends TarotEvent {
  const TarotReadingFlowReset({required this.flowType});
  final TarotFlowType flowType;

  @override
  List<Object?> get props => [flowType];
}

final class TarotCacheCleared extends TarotEvent {
  const TarotCacheCleared();

  @override
  List<Object?> get props => [];
}

final class TarotUpdateReadingNoteRequested extends TarotEvent {
  const TarotUpdateReadingNoteRequested({required this.request});
  final UpdateReadingNoteRequest request;

  @override
  List<Object?> get props => [request.readingId, request.note, request.session];
}
