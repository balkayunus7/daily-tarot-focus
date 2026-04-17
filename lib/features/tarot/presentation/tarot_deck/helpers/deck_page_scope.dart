import 'package:daily_tarot_focus/features/tarot/presentation/tarot_deck/pages/tarot_deck_page.dart';
import 'package:flutter/material.dart';

class DeckPageScope extends InheritedWidget {
  const DeckPageScope({
    required this.state,
    required super.child,
    super.key,
  });

  final DeckPageStateMixin state;

  static DeckPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<DeckPageScope>();
    assert(result != null, 'No TarotDataScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DeckPageScope oldWidget) => false;
}
