part of '../pages/tarot_library_page.dart';

mixin LibraryPageStateMixin on State<TarotDataPage> {
  void onCategoryChanged(TarotCategory? category) {
    context.read<TarotCardCubit>().filterByCategory(category);
  }
}
