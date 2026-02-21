import 'package:daily_tarot_focus/domain/tarot/i_tarot_localization_service.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

part 'tarot_localization_state.dart';

/// Cubit for managing tarot card data with locale-aware loading.
/// Acts as a middleware layer between the UI and ITarotLocalizationService.
class TarotLocalizationCubit extends Cubit<TarotLocalizationState> {
  TarotLocalizationCubit(this._localizationService) : super(TarotLocalizationState.initial());

  Future<void> loadCards(String languageCode) async {
    if (state.status == TarotCardStatus.loading) return;
    emit(state.copyWith(status: TarotCardStatus.loading));

    try {
      final cards = await localizationService.getCards(languageCode);
      emit(state.copyWith(status: TarotCardStatus.loaded, allCards: cards, filteredCards: cards));
    } on Exception catch (e) {
      emit(state.copyWith(status: TarotCardStatus.error, errorMessage: e.toString()));
    }
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

  TarotCard? getRandomCard() {
    if (state.allCards.isEmpty) return null;
    final shuffled = List<TarotCard>.from(state.allCards)..shuffle();
    return shuffled.first;
  }

  TarotCard? getByTitle(String title) {
    if (state.allCards.isEmpty) return null;
    final matching = state.allCards.where(
      (card) => card.title.toLowerCase() == title.toLowerCase(),
    );
    return matching.isEmpty ? null : matching.first;
  }

  Future<void> refreshCards(String languageCode) async {
    emit(TarotLocalizationState.initial());
    await loadCards(languageCode);
  }

  void selectCard(TarotCard? card) {
    emit(state.copyWith(selectedCard: card));
  }

  void clearSelectedCard() {
    emit(state.copyWithNullSelectedCard());
  }

  final ITarotLocalizationService _localizationService;
  ITarotLocalizationService get localizationService => _localizationService;
}
