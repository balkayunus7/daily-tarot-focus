import 'package:daily_tarot_focus/features/tarot/presentation/tarot_library/pages/tarot_library_page.dart';
import 'package:flutter/material.dart';

class LibraryPageScope extends InheritedWidget {
  const LibraryPageScope({
    required this.state,
    required super.child,
    super.key,
  });

  final LibraryPageStateMixin state;

  static LibraryPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LibraryPageScope>();
    assert(result != null, 'No TarotDataScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(LibraryPageScope oldWidget) => false;
}
