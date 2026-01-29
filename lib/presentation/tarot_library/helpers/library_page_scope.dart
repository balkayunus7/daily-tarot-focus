import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_library.dart';
import 'package:flutter/material.dart';

class TarotLibraryScope extends InheritedWidget {
  const TarotLibraryScope({
    required this.selectedCategory,
    required this.filteredCards,
    required this.onCategoryChanged,
    required super.child,
    super.key,
  });

  final ValueNotifier<TarotCategory?> selectedCategory;
  final ValueNotifier<List<TarotLibrary>> filteredCards;
  final void Function(TarotCategory?) onCategoryChanged;

  static TarotLibraryScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<TarotLibraryScope>();
    assert(result != null, 'No TarotLibraryScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TarotLibraryScope oldWidget) => false;
}
