import 'package:daily_tarot_focus/domain/tarot/i_tarot_localization_service.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

part 'tarot_card_state.dart';

/// Cubit for managing tarot card data with locale-aware loading.
/// Acts as a middleware layer between the UI and ITarotLocalizationService.
class TarotCardCubit extends Cubit<TarotCardState> {
  TarotCardCubit(this._localizationService) : super(TarotCardState.initial());

  /// Load all tarot cards for the current locale
  Future<void> loadCards(BuildContext context) async {
    if (state.status == TarotCardStatus.loading) return;

    emit(state.copyWith(status: TarotCardStatus.loading));

    try {
      final cards = await localizationService.getCards(context);
      emit(
        state.copyWith(
          status: TarotCardStatus.loaded,
          allCards: cards,
          filteredCards: cards,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: TarotCardStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Filter cards by category
  void filterByCategory(TarotCategory? category) {
    if (state.allCards.isEmpty) return;

    if (category == null) {
      emit(state.copyWithClearedCategory());
    } else {
      final filtered =
          state.allCards.where((card) => card.category == category).toList();
      emit(
        state.copyWith(
          selectedCategory: category,
          filteredCards: filtered,
        ),
      );
    }
  }

  /// Get a random card from loaded cards
  TarotData? getRandomCard() {
    if (state.allCards.isEmpty) return null;
    final shuffled = List<TarotData>.from(state.allCards)..shuffle();
    return shuffled.first;
  }

  /// Get a card by title (case-insensitive)
  TarotData? getByTitle(String title) {
    if (state.allCards.isEmpty) return null;
    final matching = state.allCards.where(
      (card) => card.title.toLowerCase() == title.toLowerCase(),
    );
    return matching.isEmpty ? null : matching.first;
  }

  /// Clear cache and reload (useful when locale changes)
  Future<void> refreshCards(BuildContext context) async {
    emit(TarotCardState.initial());
    await loadCards(context);
  }

  /// Select a specific card
  void selectCard(TarotData? card) {
    emit(state.copyWith(selectedCard: card));
  }

  /// Clear selected card
  void clearSelectedCard() {
    emit(state.copyWithNullSelectedCard());
  }

  /// Check if cards are loaded

  final ITarotLocalizationService _localizationService;
  ITarotLocalizationService get localizationService => _localizationService;
}
