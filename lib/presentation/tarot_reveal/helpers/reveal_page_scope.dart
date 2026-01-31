import 'package:daily_tarot_focus/presentation/tarot_reveal/helpers/reveal_page_mixin.dart';
import 'package:flutter/material.dart';

class RevealPageScope extends InheritedWidget {
  const RevealPageScope({
    required this.state,
    required super.child,
    super.key,
  });

  final RevealPageStateMixin state;

  static RevealPageStateMixin of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<RevealPageScope>();
    assert(result != null, 'No RevealPageScope found in context');
    return result!.state;
  }

  @override
  bool updateShouldNotify(RevealPageScope oldWidget) => false;
}
