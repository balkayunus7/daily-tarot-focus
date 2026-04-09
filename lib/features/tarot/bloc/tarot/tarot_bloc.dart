// tarot_bloc.dart
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_event.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/tarot_repository.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot_localization/tarot_localization_repository.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotBloc extends Bloc<TarotEvent, TarotState> {
  TarotBloc(this._tarotRepository, this._localizationRepository) : super(TarotState.initial()) {
    on<TarotEvent>((event, emit) async {
      if (event is TarotFetchDailyCardsRequested) {
        await _onFetchDailyCardsRequested(event, emit);
      } else if (event is TarotRecordDailyCardRequested) {
        await _onRecordDailyCardRequested(event, emit);
      } else if (event is TarotReadingRequested) {
        await _onReadingRequested(event, emit);
      }
    }, transformer: sequential());
  }

  void addFetchDailyCardsRequested({required FetchDailyCardsRequest request}) {
    add(TarotFetchDailyCardsRequested(request: request));
  }

  void addRecordDailyCardRequested({required RecordDailyCardRequest request}) {
    add(TarotRecordDailyCardRequested(request: request));
  }

  void addReadingRequested({required ReadingRequest request}) {
    add(TarotReadingRequested(request: request));
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

    final failOrRecords = await _tarotRepository.requestFetchDailyCards(request: event.request);

    final newState = await failOrRecords.fold(
      (failure) async => state.copyWith(
        fetchFailureOrDailyCards: some(left(failure)),
        isFetchingDailyCards: false,
      ),
      (response) async {
        final cards = <TarotCardModel>[];
        for (final record in response.records.asList()) {
          final failOrCard = await _localizationRepository.findCardById(
            event.request.languageCode,
            record.cardId,
          );

          failOrCard.fold(
            (failure) => null,
            (card) {
              if (card != null) {
                cards.add(card.copyWith(savedAt: record.date));
              }
            },
          );
        }
        cards.sort((a, b) => (b.savedAt ?? DateTime(0)).compareTo(a.savedAt ?? DateTime(0)));
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
    emit(
      state.copyWith(
        isSavingDailyCard: true,
        saveDailyCardFailureOrUnit: none(),
      ),
    );

    final failOrUnit = await _tarotRepository.requestRecordDailyCard(request: event.request);

    final newState = await failOrUnit.fold(
      (failure) async => state.copyWith(
        saveDailyCardFailureOrUnit: some(left(failure)),
        isSavingDailyCard: false,
      ),
      (response) async => state.copyWith(
        saveDailyCardFailureOrUnit: some(right(unit)),
        isSavingDailyCard: false,
      ),
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

  Future<void> _onReadingRequested(
    TarotReadingRequested event,
    Emitter<TarotState> emit,
  ) async {
    emit(
      state.copyWith(
        isAskingQuestion: true,
        askQuestionFailureOrResponse: none(),
      ),
    );

    final failOrResponse = await _tarotRepository.requestTarotReading(request: event.request);

    final newState = await failOrResponse.fold(
      (failure) async => state.copyWith(
        askQuestionFailureOrResponse: some(left(failure)),
        isAskingQuestion: false,
      ),
      (response) async => state.copyWith(
        askQuestionFailureOrResponse: some(right(response)),
        isAskingQuestion: false,
      ),
    );

    emit(newState);
  }

  final ImplTarotRepository _tarotRepository;
  final ImplTarotLocalizationRepository _localizationRepository;
}
