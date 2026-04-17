part of '../pages/tarot_deck_page.dart';

mixin DeckPageStateMixin on State<TarotDeckPage> {
  final int freeCardCount = 5;

  void onCategoryChanged(TarotCategory? category) {
    context.read<TarotLocalizationCubit>().filterByCategory(category);
  }
}
