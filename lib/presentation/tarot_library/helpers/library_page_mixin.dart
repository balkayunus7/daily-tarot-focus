part of '../pages/tarot_library_page.dart';

mixin LibraryPageStateMixin on State<TarotLibraryPage> {
  late final ValueNotifier<TarotCategory?> selectedCategory;
  late final ValueNotifier<List<TarotLibrary>> filteredCards;

  @override
  void initState() {
    super.initState();
    selectedCategory = ValueNotifier(null);
    filteredCards = ValueNotifier(TarotMockData.fullTarotDeckMock);
  }

  void onCategoryChanged(TarotCategory? category) {
    final fullCards = TarotMockData.fullTarotDeckMock;
    if (category == null) {
      selectedCategory.value = null;
      filteredCards.value = fullCards;
      return;
    }
    selectedCategory.value = category;
    filteredCards.value =
        fullCards.where((card) => card.category == category).toList();
  }

  @override
  void dispose() {
    selectedCategory.dispose();
    filteredCards.dispose();
    super.dispose();
  }
}
