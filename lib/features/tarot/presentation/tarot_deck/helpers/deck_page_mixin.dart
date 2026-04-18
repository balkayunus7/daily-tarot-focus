part of '../pages/tarot_deck_page.dart';

mixin DeckPageStateMixin on State<TarotDeckPage> {
  final int freeCardCount = 5;
  late final ValueNotifier<TarotCategory?> selectedCategory;

  @override
  void initState() {
    selectedCategory = ValueNotifier<TarotCategory?>(null);
    super.initState();
  }

  set onCategoryChanged(TarotCategory? category) {
    selectedCategory.value = category;
  }
}
