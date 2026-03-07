import 'package:daily_tarot_focus/application/tarot/tarot_event.dart';
import 'package:daily_tarot_focus/application/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/domain/tarot/i_tarot_repository.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:daily_tarot_focus/infrastructure/tarot/impl_tarot_localization_service.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

class TarotBloc extends Bloc<TarotEvent, TarotState> {
  TarotBloc(this._tarotRepository, this._localizationService) : super(TarotState.initial()) {
    on<TarotEvent>((event, emit) async {
      if (event is TarotDailyCardsFetched) {
        await _onDailyCardsFetched(event, emit);
      } else if (event is TarotDailyCardSaved) {
        await _onDailyCardSaved(event, emit);
      }
    }, transformer: sequential());
  }

  void addDailyCardsFetched({required AuthSession session, required String languageCode}) {
    add(TarotDailyCardsFetched(session: session, languageCode: languageCode));
  }

  void addDailyCardSaved({
    required AuthSession session,
    required String tarotCardId,
    required String languageCode,
  }) {
    add(
      TarotDailyCardSaved(
        tarotCardId: tarotCardId,
        session: session,
        languageCode: languageCode,
      ),
    );
  }

  Future<void> _onDailyCardsFetched(
    TarotDailyCardsFetched event,
    Emitter<TarotState> emit,
  ) async {
    emit(
      state.copyWith(
        isFetchingDailyCards: true,
        fetchFailureOrDailyCards: none(),
      ),
    );

    final failOrRecords = await _tarotRepository.getDailyCards(
      session: event.session,
    );

    final newState = await failOrRecords.fold(
      (failure) async {
        return state.copyWith(
          fetchFailureOrDailyCards: some(left(failure)),
          isFetchingDailyCards: false,
        );
      },
      (records) async {
        final cards = <TarotCard>[];
        for (final record in records) {
          final card = await _localizationService.findCardById(
            event.languageCode,
            record.cardId,
          );
          if (card != null) {
            cards.add(card.copyWith(savedAt: record.date));
          }
        }

        return state.copyWith(
          fetchFailureOrDailyCards: some(right(KtList.from(cards))),
          isFetchingDailyCards: false,
        );
      },
    );
    emit(newState);
  }

  Future<void> _onDailyCardSaved(
    TarotDailyCardSaved event,
    Emitter<TarotState> emit,
  ) async {
    emit(
      state.copyWith(
        isSavingDailyCard: true,
        saveDailyCardFailureOrUnit: none(),
      ),
    );

    final failOrUnit = await _tarotRepository.saveDailyCard(
      session: event.session,
      cardId: event.tarotCardId,
    );

    final newState = await failOrUnit.fold(
      (failure) async {
        return state.copyWith(
          saveDailyCardFailureOrUnit: some(left(failure)),
          isSavingDailyCard: false,
        );
      },
      (unit) async {
        return state.copyWith(
          saveDailyCardFailureOrUnit: some(right(unit)),
          isSavingDailyCard: false,
        );
      },
    );

    emit(newState);

    if (newState.hasSavedDailyCardSucceeded) {
      add(
        TarotDailyCardsFetched(
          session: event.session,
          languageCode: event.languageCode,
        ),
      );
    }
  }

  final ITarotRepository _tarotRepository;
  final ImplTarotLocalizationService _localizationService;
}
