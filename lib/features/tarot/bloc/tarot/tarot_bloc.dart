import 'dart:async';

import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_event.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/impl_tarot_cache_service.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/impl_tarot_repository.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotBloc extends Bloc<TarotEvent, TarotState> {
  TarotBloc(this._tarotRepository, this._cacheService) : super(TarotState.initial()) {
    on<TarotEvent>((event, emit) async {
      if (event is TarotFetchAllCardsRequested) {
        await _onFetchAllCardsRequested(event, emit);
      } else if (event is TarotFetchDailyCardsRequested) {
        await _onFetchDailyCardsRequested(event, emit);
      } else if (event is TarotRecordDailyCardRequested) {
        await _onRecordDailyCardRequested(event, emit);
      } else if (event is TarotReadingRequested) {
        await _onReadingRequested(event, emit);
      }
    }, transformer: sequential());
  }

  void addFetchAllCardsRequested({required FetchAllCardsRequest request}) =>
      add(TarotFetchAllCardsRequested(request: request));

  void addFetchDailyCardsRequested({required FetchDailyCardsRequest request}) =>
      add(TarotFetchDailyCardsRequested(request: request));

  void addRecordDailyCardRequested({required RecordDailyCardRequest request}) =>
      add(TarotRecordDailyCardRequested(request: request));

  void addReadingRequested({required ReadingRequest request}) =>
      add(TarotReadingRequested(request: request));

  Future<void> _onFetchAllCardsRequested(
    TarotFetchAllCardsRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(state.copyWith(isFetchingAllCards: true));

    final cachedCards = await _cacheService.getCards();
    if (cachedCards != null && cachedCards.isNotEmpty) {
      emit(
        state.copyWith(
          fetchAllCardsFailureOrCards: some(right(KtList.from(cachedCards))),
          isFetchingAllCards: false,
        ),
      );
      return;
    }

    final failOrAllCards = await _tarotRepository.requestAllCards(request: event.request);

    final newState = failOrAllCards.fold(
      (failure) => state.copyWith(
        fetchAllCardsFailureOrCards: some(left(failure)),
        isFetchingAllCards: false,
      ),
      (response) {
        unawaited(_cacheService.saveCards(response.cards.asList()));
        return state.copyWith(
          fetchAllCardsFailureOrCards: some(right(response.cards)),
          isFetchingAllCards: false,
        );
      },
    );

    emit(newState);
  }

  Future<void> _onFetchDailyCardsRequested(
    TarotFetchDailyCardsRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(state.copyWith(isFetchingDailyCards: true, fetchFailureOrDailyCards: none()));

    final failOrRecords = await _tarotRepository.requestFetchDailyCards(request: event.request);

    final newState = failOrRecords.fold(
      (failure) => state.copyWith(
        fetchFailureOrDailyCards: some(left(failure)),
        isFetchingDailyCards: false,
      ),
      (response) {
        final cards =
            response.records
                .asList()
                .map((record) {
                  final card = state.getById(record.cardId);
                  return card?.copyWith(savedAt: record.date);
                })
                .whereType<TarotCardModel>()
                .toList()
              ..sort((a, b) => (b.savedAt ?? DateTime(0)).compareTo(a.savedAt ?? DateTime(0)));

        return state.copyWith(
          fetchFailureOrDailyCards: some(right(KtList.from(cards))),
          isFetchingDailyCards: false,
        );
      },
    );

    emit(newState);
  }

  Future<void> _onRecordDailyCardRequested(
    TarotRecordDailyCardRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(state.copyWith(isRecordDailyCard: true, recordDailyCardFailureOrUnit: none()));

    final failOrUnit = await _tarotRepository.requestRecordDailyCard(request: event.request);

    final newState = failOrUnit.fold(
      (failure) => state.copyWith(
        recordDailyCardFailureOrUnit: some(left(failure)),
        isRecordDailyCard: false,
      ),
      (_) =>
          state.copyWith(recordDailyCardFailureOrUnit: some(right(unit)), isRecordDailyCard: false),
    );

    emit(newState);

    if (newState.hasRecordDailyCardSucceeded) {
      addFetchDailyCardsRequested(
        request: FetchDailyCardsRequest(
          session: event.request.session,
          languageCode: event.request.languageCode,
        ),
      );
    }
  }

  Future<void> _onReadingRequested(TarotReadingRequested event, Emitter<TarotState> emit) async {
    emit(state.copyWith(isReading: true, readingFailureOrResponse: none()));

    final failOrResponse = await _tarotRepository.requestTarotReading(request: event.request);

    final newState = failOrResponse.fold(
      (failure) => state.copyWith(readingFailureOrResponse: some(left(failure)), isReading: false),
      (response) =>
          state.copyWith(readingFailureOrResponse: some(right(response)), isReading: false),
    );

    emit(newState);
  }

  final ImplTarotRepository _tarotRepository;
  final ImplTarotCacheService _cacheService;
}
