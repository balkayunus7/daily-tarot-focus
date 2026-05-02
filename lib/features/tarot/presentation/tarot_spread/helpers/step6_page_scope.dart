import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/helpers/step6_page_mixin.dart';
import 'package:flutter/widgets.dart';

class Step6PageScope extends InheritedWidget {
  const Step6PageScope({required this.state, required super.child, super.key});
  final Step6PageMixin state;

  static Step6PageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Step6PageScope>();
    assert(result != null, 'No Step6PageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Step6PageScope oldWidget) => false;
}
