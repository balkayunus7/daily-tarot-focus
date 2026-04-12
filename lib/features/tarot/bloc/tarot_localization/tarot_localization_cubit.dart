import 'package:daily_tarot_focus/features/tarot/data/tarot_localization/tarot_localization_repository.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_category_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

part 'tarot_localization_state.dart';

class TarotLocalizationCubit extends Cubit<TarotLocalizationState> {
  TarotLocalizationCubit(this._localizationRepository) : super(TarotLocalizationState.initial());

  Future<void> loadCards(String languageCode) async {
    if (state.status == TarotCardStatus.loading) return;

    emit(state.copyWith(status: TarotCardStatus.loading));

    final result = await localizationRepository.getCards(languageCode);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TarotCardStatus.error,
          errorMessage: failure.toString(),
        ),
      ),
      (cards) => emit(
        state.copyWith(
          status: TarotCardStatus.loaded,
          allCards: cards,
          filteredCards: cards,
        ),
      ),
    );
  }

  void filterByCategory(TarotCategory? category) {
    if (state.allCards.isEmpty) return;

    if (category == null) {
      emit(state.copyWithClearedCategory());
    } else {
      final filtered = state.allCards.where((card) => card.category == category).toList();
      emit(state.copyWith(selectedCategory: category, filteredCards: filtered));
    }
  }

  TarotCardModel? getRandomCard() {
    if (state.allCards.isEmpty) return null;
    final shuffled = List<TarotCardModel>.from(state.allCards)..shuffle();
    return shuffled.first;
  }

  List<TarotCardModel> getRandomCards(int count) {
    if (state.allCards.isEmpty) return [];
    final shuffled = List<TarotCardModel>.from(state.allCards)..shuffle();
    return shuffled.take(count).toList();
  }

  TarotCardModel? getByTitle(String title) {
    if (state.allCards.isEmpty) return null;
    return state.allCards
        .where((card) => card.name.toLowerCase() == title.toLowerCase())
        .firstOrNull;
  }

  TarotCardModel? getById(String id) {
    if (state.allCards.isEmpty) return null;
    return state.allCards.where((card) => card.id == id).firstOrNull;
  }

  Future<void> refreshCards(String languageCode) async {
    localizationRepository.clearCache();
    emit(TarotLocalizationState.initial());
    await loadCards(languageCode);
  }

  void selectCard(TarotCardModel? card) {
    emit(state.copyWith(selectedCard: card));
  }

  void clearSelectedCard() {
    emit(state.copyWithNullSelectedCard());
  }

  final ImplTarotLocalizationRepository _localizationRepository;
  ImplTarotLocalizationRepository get localizationRepository => _localizationRepository;
}
