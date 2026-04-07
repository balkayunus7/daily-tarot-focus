part of '../pages/tarot_library_page.dart';

mixin LibraryPageStateMixin on State<TarotLibraryPage> {
  final int freeCardCount = 5;

  void onCategoryChanged(TarotCategory? category) {
    context.read<TarotLocalizationCubit>().filterByCategory(category);
  }
}
