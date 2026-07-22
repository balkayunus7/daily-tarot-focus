import 'dart:async';

import 'package:daily_tarot_focus/features/tarot/bloc/tarot_event.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/data/impl_tarot_cache_service.dart';
import 'package:daily_tarot_focus/features/tarot/data/impl_tarot_repository.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/delete_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_saved_readings_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_daily_pick_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/save_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_flow_type.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reading_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/update_reading_note_request_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

class TarotBloc extends Bloc<TarotEvent, TarotState> {
  TarotBloc(this._tarotRepository, this._cacheService)
    : super(TarotState.initial()) {
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
        } else if (event is TarotSelectQuestion) {
          emit(state.copyWith(selectedQuestion: event.question));
        } else if (event is TarotSetReadingCards) {
          emit(state.copyWith(selectedReadingCards: event.cards));
        } else if (event is TarotGenerateReadingRequested) {
          await _onGenerateReadingRequested(event, emit);
        } else if (event is TarotGenerateDailyPickRequested) {
          await _onGenerateDailyPickRequested(event, emit);
        } else if (event is TarotSetFlowType) {
          emit(state.copyWith(flowType: event.flowType));
        } else if (event is TarotReadingFlowReset) {
          _onReadingFlowReset(event, emit);
        } else if (event is TarotFetchSavedReadingsRequested) {
          await _onFetchSavedReadingsRequested(event, emit);
        } else if (event is TarotSaveReadingRequested) {
          await _onSaveReadingRequested(event, emit);
        } else if (event is TarotCacheCleared) {
          await _onCacheCleared(event, emit);
        } else if (event is TarotUpdateReadingNoteRequested) {
          await _onUpdateReadingNoteRequested(event, emit);
        } else if (event is TarotDeleteReadingRequested) {
          await _onDeleteReadingRequested(event, emit);
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

  void addSetupAccountRequested({
    required AuthSession session,
    String locale = 'en',
  }) => add(TarotSetupAccountRequested(session: session, locale: locale));

  void addSelectSpreadCategory({required TarotSpreadCategoryModel category}) =>
      add(TarotSelectSpreadCategory(category: category));

  void addSelectSpread({required TarotSpreadModel spread}) =>
      add(TarotSelectSpread(spread: spread));

  void addSelectReader({required TarotReaderModel reader}) =>
      add(TarotSelectReader(reader: reader));

  void addSelectQuestion({required String question}) =>
      add(TarotSelectQuestion(question: question));

  void addSetReadingCards({required List<TarotSelectedReadingCard> cards}) =>
      add(TarotSetReadingCards(cards: cards));

  void addGenerateReadingRequested({
    required AuthSession session,
    String locale = 'en',
  }) => add(TarotGenerateReadingRequested(session: session, locale: locale));

  void addGenerateDailyPickRequested({
    required GenerateDailyPickRequest request,
  }) => add(TarotGenerateDailyPickRequested(request: request));

  void addSetFlowType({required TarotFlowType flowType}) =>
      add(TarotSetFlowType(flowType: flowType));

  void addSaveReadingRequested({required SaveReadingRequest request}) =>
      add(TarotSaveReadingRequested(request: request));

  void addReadingFlowReset({required TarotFlowType flowType}) =>
      add(TarotReadingFlowReset(flowType: flowType));

  void addFetchSavedReadingsRequested({
    required FetchSavedReadingsRequest request,
  }) => add(TarotFetchSavedReadingsRequested(request: request));

  void addClearCache() => add(const TarotCacheCleared());

  void addUpdateReadingNoteRequested({
    required UpdateReadingNoteRequest request,
  }) => add(TarotUpdateReadingNoteRequested(request: request));

  void addDeleteReadingRequested({required DeleteReadingRequest request}) =>
      add(TarotDeleteReadingRequested(request: request));

  // ── Private cache helpers ───────────────────────────────────────────────────
  Future<FailureOr<KtList<TarotCardModel>>> _fetchAndCacheAllCards(
    AuthSession session,
    String locale,
  ) async {
    final cached = await _cacheService.getCards(locale);
    if (cached != null && cached.isNotEmpty) {
      return right(KtList.from(cached));
    }

    final result = await _tarotRepository.requestAllCards(
      request: FetchAllCardsRequest(session: session, locale: locale),
    );

    await result.fold(
      (_) {},
      (r) async {
        await _cacheService.saveCards(r.cards.asList(), locale);
      },
    );
    return result.map((r) => r.cards);
  }

  Future<FailureOr<KtList<TarotSpreadCategoryModel>>> _fetchAndCacheSpreads(
    AuthSession session,
    String locale,
  ) async {
    final cached = await _cacheService.getSpreads(locale);
    if (cached != null && cached.isNotEmpty) {
      return right(KtList.from(cached));
    }

    final result = await _tarotRepository.requestFetchSpreads(
      request: FetchSpreadsRequest(session: session, locale: locale),
    );
    await result.fold(
      (_) {},
      (r) async {
        await _cacheService.saveSpreads(r.spreadCategories.asList(), locale);
      },
    );
    return result.map((r) => r.spreadCategories);
  }

  Future<FailureOr<KtList<TarotReaderModel>>> _fetchAndCacheReaders(
    AuthSession session,
    String locale,
  ) async {
    final cached = await _cacheService.getReaders(locale);
    if (cached != null && cached.isNotEmpty) {
      return right(KtList.from(cached));
    }

    final result = await _tarotRepository.requestFetchReaders(
      request: FetchReadersRequest(session: session, locale: locale),
    );
    await result.fold(
      (_) {},
      (r) async {
        await _cacheService.saveReaders(r.readers.asList(), locale);
      },
    );
    return result.map((r) => r.readers);
  }

  // ── Event handlers
  void _onReadingFlowReset(
    TarotReadingFlowReset event,
    Emitter<TarotState> emit,
  ) {
    emit(
      TarotState(
        fetchFailureOrDailyCards: state.fetchFailureOrDailyCards,
        recordDailyCardFailureOrUnit: state.recordDailyCardFailureOrUnit,
        fetchAllCardsFailureOrCards: state.fetchAllCardsFailureOrCards,
        fetchSpreadsFailureOrSpreads: state.fetchSpreadsFailureOrSpreads,
        fetchReadersFailureOrReaders: state.fetchReadersFailureOrReaders,
        isFetchingDailyCards: state.isFetchingDailyCards,
        isRecordDailyCard: state.isRecordDailyCard,
        isFetchingAllCards: state.isFetchingAllCards,
        isFetchingSpreads: state.isFetchingSpreads,
        isFetchingReaders: state.isFetchingReaders,
        isSettingUpAccount: state.isSettingUpAccount,
        hasAccountSetupCompleted: state.hasAccountSetupCompleted,
        clearCacheFailureOrUnit: state.clearCacheFailureOrUnit,
        flowType: event.flowType,
        selectedSpreadCategory: null,
        selectedSpread: null,
        selectedReader: null,
        selectedQuestion: null,
        selectedReadingCards: const [],
        isGeneratingDailyPick: false,
        fetchFailureOrGenerateDailyPick: none(),
        isGeneratingReading: false,
        fetchFailureOrGenerateReading: none(),
        saveReadingFailureOrResponse: none(),
        isSavingReading: false,
        fetchSavedReadingsFailureOrResponse:
            state.fetchSavedReadingsFailureOrResponse,
        isFetchingSavedReadings: state.isFetchingSavedReadings,
        isUpdatingNote: false,
        updateNoteFailureOrUnit: none(),
        isDeletingReading: false,
        deleteReadingFailureOrUnit: none(),
      ),
    );
  }

  Future<void> _onCacheCleared(
    TarotCacheCleared event,
    Emitter<TarotState> emit,
  ) async {
    emit(state.copyWith(clearCacheFailureOrUnit: none()));
    await _cacheService.clearCache();
    emit(state.copyWith(clearCacheFailureOrUnit: some(right(unit))));
  }

  Future<void> _onSetupAccountRequested(
    TarotSetupAccountRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(
      state.copyWith(isSettingUpAccount: true, hasAccountSetupCompleted: false),
    );

    final locale = event.locale;
    final cardsF = _fetchAndCacheAllCards(event.session, locale);
    final spreadsF = _fetchAndCacheSpreads(event.session, locale);
    final readersF = _fetchAndCacheReaders(event.session, locale);
    final dailyCardsF = _tarotRepository.requestFetchDailyCards(
      request: FetchDailyCardsRequest(session: event.session),
    );
    final savedReadingsF = _tarotRepository.requestFetchSavedReadings(
      request: FetchSavedReadingsRequest(session: event.session),
    );

    final cardsResult = await cardsF;
    final spreadsResult = await spreadsF;
    final readersResult = await readersF;
    final dailyCardsRaw = await dailyCardsF;
    final savedReadingsResult = await savedReadingsF;

    final dailyCardsResult = dailyCardsRaw.map((response) => response.records);

    emit(
      state.copyWith(
        isSettingUpAccount: false,
        hasAccountSetupCompleted: true,
        fetchAllCardsFailureOrCards: some(cardsResult),
        fetchSpreadsFailureOrSpreads: some(spreadsResult),
        fetchReadersFailureOrReaders: some(readersResult),
        fetchFailureOrDailyCards: some(dailyCardsResult),
        fetchSavedReadingsFailureOrResponse: some(savedReadingsResult),
      ),
    );
  }

  Future<void> _onFetchAllCardsRequested(
    TarotFetchAllCardsRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(state.copyWith(isFetchingAllCards: true));
    final result = await _fetchAndCacheAllCards(
      event.request.session,
      event.request.locale,
    );
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
    emit(
      state.copyWith(
        isFetchingDailyCards: true,
        fetchFailureOrDailyCards: none(),
      ),
    );

    final failOrRecords = await _tarotRepository.requestFetchDailyCards(
      request: event.request,
    );

    final newState = failOrRecords.fold(
      (failure) => state.copyWith(
        fetchFailureOrDailyCards: some(left(failure)),
        isFetchingDailyCards: false,
      ),
      (response) {
        return state.copyWith(
          fetchFailureOrDailyCards: some(right(response.records)),
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
    emit(
      state.copyWith(
        isRecordDailyCard: true,
        recordDailyCardFailureOrUnit: none(),
      ),
    );

    final failOrUnit = await _tarotRepository.requestRecordDailyCard(
      request: event.request,
    );

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
    emit(
      state.copyWith(
        isFetchingSpreads: true,
        fetchSpreadsFailureOrSpreads: none(),
      ),
    );
    final result = await _fetchAndCacheSpreads(
      event.request.session,
      event.request.locale,
    );
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
    emit(
      state.copyWith(
        isFetchingReaders: true,
        fetchReadersFailureOrReaders: none(),
      ),
    );
    final result = await _fetchAndCacheReaders(
      event.request.session,
      event.request.locale,
    );
    emit(
      state.copyWith(
        fetchReadersFailureOrReaders: some(result),
        isFetchingReaders: false,
      ),
    );
  }

  Future<void> _onGenerateReadingRequested(
    TarotGenerateReadingRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(
      state.copyWith(
        isGeneratingReading: true,
        fetchFailureOrGenerateReading: none(),
      ),
    );

    final request = GenerateReadingRequest(
      session: event.session,
      spreadCategoryId: state.selectedSpreadCategory?.id ?? '',
      spreadId: state.selectedSpread?.id ?? '',
      readerId: state.selectedReader?.id ?? '',
      question: state.selectedQuestion,
      cards: state.selectedReadingCards.map((c) => c.toCardRequest()).toList(),
      locale: event.locale,
    );

    final result = await _tarotRepository.requestGenerateReading(
      request: request,
    );

    emit(
      state.copyWith(
        isGeneratingReading: false,
        fetchFailureOrGenerateReading: some(result),
      ),
    );
  }

  Future<void> _onGenerateDailyPickRequested(
    TarotGenerateDailyPickRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(
      state.copyWith(
        isGeneratingDailyPick: true,
        fetchFailureOrGenerateDailyPick: none(),
      ),
    );

    final result = await _tarotRepository.requestGenerateDailyPick(
      request: event.request,
    );

    emit(
      state.copyWith(
        isGeneratingDailyPick: false,
        fetchFailureOrGenerateDailyPick: some(result),
      ),
    );
  }

  Future<void> _onSaveReadingRequested(
    TarotSaveReadingRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(
      state.copyWith(
        isSavingReading: true,
        saveReadingFailureOrResponse: none(),
      ),
    );

    final result = await _tarotRepository.requestSaveReading(
      request: event.request,
    );

    emit(
      state.copyWith(
        isSavingReading: false,
        saveReadingFailureOrResponse: some(result),
      ),
    );

    if (result.isRight()) {
      addFetchSavedReadingsRequested(
        request: FetchSavedReadingsRequest(session: event.request.session),
      );
    }
  }

  Future<void> _onFetchSavedReadingsRequested(
    TarotFetchSavedReadingsRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(
      state.copyWith(
        isFetchingSavedReadings: true,
        fetchSavedReadingsFailureOrResponse: none(),
      ),
    );

    final result = await _tarotRepository.requestFetchSavedReadings(
      request: event.request,
    );

    emit(
      state.copyWith(
        isFetchingSavedReadings: false,
        fetchSavedReadingsFailureOrResponse: some(result),
      ),
    );
  }

  Future<void> _onUpdateReadingNoteRequested(
    TarotUpdateReadingNoteRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(state.copyWith(isUpdatingNote: true, updateNoteFailureOrUnit: none()));

    final result = await _tarotRepository.requestUpdateReadingNote(
      request: event.request,
    );

    emit(
      state.copyWith(
        isUpdatingNote: false,
        updateNoteFailureOrUnit: some(result),
      ),
    );

    if (result.isRight()) {
      addFetchSavedReadingsRequested(
        request: FetchSavedReadingsRequest(session: event.request.session),
      );
    }
  }

  Future<void> _onDeleteReadingRequested(
    TarotDeleteReadingRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(
      state.copyWith(
        isDeletingReading: true,
        deleteReadingFailureOrUnit: none(),
      ),
    );

    final result = await _tarotRepository.requestDeleteReading(
      request: event.request,
    );

    emit(
      state.copyWith(
        isDeletingReading: false,
        deleteReadingFailureOrUnit: some(result),
      ),
    );

    if (result.isRight()) {
      addFetchSavedReadingsRequested(
        request: FetchSavedReadingsRequest(session: event.request.session),
      );
    }
  }

  final ImplTarotRepository _tarotRepository;
  final ImplTarotCacheService _cacheService;
}
