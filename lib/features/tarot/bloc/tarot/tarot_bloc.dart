import 'dart:async';

import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_event.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/impl_tarot_cache_service.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/impl_tarot_repository.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

class TarotBloc extends Bloc<TarotEvent, TarotState> {
  TarotBloc(this._tarotRepository, this._cacheService) : super(TarotState.initial()) {
    on<TarotEvent>(
      (event, emit) async {
        if (event is TarotFetchAllCardsRequested) {
          await _onFetchAllCardsRequested(event, emit);
        } else if (event is TarotFetchDailyCardsRequested) {
          await _onFetchDailyCardsRequested(event, emit);
        } else if (event is TarotRecordDailyCardRequested) {
          await _onRecordDailyCardRequested(event, emit);
        } else if (event is TarotFetchSpreadsRequested) {
          await _onFetchSpreadsRequested(event, emit);
        } else if (event is TarotFetchReadersRequested) {
          await _onFetchReadersRequested(event, emit);
        } else if (event is TarotSetupAccountRequested) {
          await _onSetupAccountRequested(event, emit);
        } else if (event is TarotSelectSpreadCategory) {
          emit(state.copyWith(selectedSpreadCategory: event.category));
        } else if (event is TarotSelectSpread) {
          emit(state.copyWith(selectedSpread: event.spread));
        } else if (event is TarotSelectReader) {
          emit(state.copyWith(selectedReader: event.reader));
        }
      },
      transformer: sequential(),
    );
  }

  // ── Public helpers ──────────────────────────────────────────────────────────
  void addFetchDailyCardsRequested({required FetchDailyCardsRequest request}) =>
      add(TarotFetchDailyCardsRequested(request: request));

  void addRecordDailyCardRequested({required RecordDailyCardRequest request}) =>
      add(TarotRecordDailyCardRequested(request: request));

  void addFetchAllCardsRequested({required FetchAllCardsRequest request}) =>
      add(TarotFetchAllCardsRequested(request: request));

  void addSetupAccountRequested({required AuthSession session}) =>
      add(TarotSetupAccountRequested(session: session));

  void addSelectSpreadCategory({required TarotSpreadCategoryModel category}) =>
      add(TarotSelectSpreadCategory(category: category));

  void addSelectSpread({required TarotSpreadModel spread}) =>
      add(TarotSelectSpread(spread: spread));

  void addSelectReader({required TarotReaderModel reader}) =>
      add(TarotSelectReader(reader: reader));

  // ── Private cache helpers ───────────────────────────────────────────────────
  Future<FailureOr<KtList<TarotCardModel>>> _fetchAndCacheAllCards(
    AuthSession session,
  ) async {
    final cached = await _cacheService.getCards();
    if (cached != null && cached.isNotEmpty) {
      return right(KtList.from(cached));
    }

    final result = await _tarotRepository.requestAllCards(
      request: FetchAllCardsRequest(session: session),
    );

    await result.fold(
      (_) {},
      (r) async {
        await _cacheService.saveCards(r.cards.asList());
      },
    );
    return result.map((r) => r.cards);
  }

  Future<FailureOr<KtList<TarotSpreadCategoryModel>>> _fetchAndCacheSpreads(
    AuthSession session,
  ) async {
    final cached = await _cacheService.getSpreads();
    if (cached != null && cached.isNotEmpty) {
      return right(KtList.from(cached));
    }

    final result = await _tarotRepository.requestFetchSpreads(
      request: FetchSpreadsRequest(session: session),
    );
    await result.fold(
      (_) {},
      (r) async {
        await _cacheService.saveSpreads(r.spreadCategories.asList());
      },
    );
    return result.map((r) => r.spreadCategories);
  }

  Future<FailureOr<KtList<TarotReaderModel>>> _fetchAndCacheReaders(
    AuthSession session,
  ) async {
    final cached = await _cacheService.getReaders();
    if (cached != null && cached.isNotEmpty) {
      return right(KtList.from(cached));
    }

    final result = await _tarotRepository.requestFetchReaders(
      request: FetchReadersRequest(session: session),
    );
    await result.fold(
      (_) {},
      (r) async {
        await _cacheService.saveReaders(r.readers.asList());
      },
    );
    return result.map((r) => r.readers);
  }

  // ── Event handlers ──────────────────────────────────────────────────────────
  Future<void> _onSetupAccountRequested(
    TarotSetupAccountRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(state.copyWith(isSettingUpAccount: true, hasAccountSetupCompleted: false));

    final cardsResult = await _fetchAndCacheAllCards(event.session);
    final spreadsResult = await _fetchAndCacheSpreads(event.session);
    final readersResult = await _fetchAndCacheReaders(event.session);

    emit(
      state.copyWith(
        isSettingUpAccount: false,
        hasAccountSetupCompleted: true,
        fetchAllCardsFailureOrCards: some(cardsResult),
        fetchSpreadsFailureOrSpreads: some(spreadsResult),
        fetchReadersFailureOrReaders: some(readersResult),
      ),
    );
  }

  Future<void> _onFetchAllCardsRequested(
    TarotFetchAllCardsRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(state.copyWith(isFetchingAllCards: true));
    final result = await _fetchAndCacheAllCards(event.request.session);
    emit(
      state.copyWith(
        fetchAllCardsFailureOrCards: some(result),
        isFetchingAllCards: false,
      ),
    );
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
            response.records.map((r) {
              final card = state.getById(r.cardId);
              if (card == null) return null;
              return card.copyWith(savedAt: r.date);
            }).filterNotNull();

        return state.copyWith(
          fetchFailureOrDailyCards: some(right(cards)),
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
      (_) => state.copyWith(
        recordDailyCardFailureOrUnit: some(right(unit)),
        isRecordDailyCard: false,
      ),
    );

    emit(newState);

    if (newState.hasRecordDailyCardSucceeded) {
      addFetchDailyCardsRequested(
        request: FetchDailyCardsRequest(session: event.request.session),
      );
    }
  }

  Future<void> _onFetchSpreadsRequested(
    TarotFetchSpreadsRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(state.copyWith(isFetchingSpreads: true, fetchSpreadsFailureOrSpreads: none()));
    final result = await _fetchAndCacheSpreads(event.request.session);
    emit(
      state.copyWith(
        fetchSpreadsFailureOrSpreads: some(result),
        isFetchingSpreads: false,
      ),
    );
  }

  Future<void> _onFetchReadersRequested(
    TarotFetchReadersRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(state.copyWith(isFetchingReaders: true, fetchReadersFailureOrReaders: none()));
    final result = await _fetchAndCacheReaders(event.request.session);
    emit(
      state.copyWith(
        fetchReadersFailureOrReaders: some(result),
        isFetchingReaders: false,
      ),
    );
  }

  final ImplTarotRepository _tarotRepository;
  final ImplTarotCacheService _cacheService;
}
