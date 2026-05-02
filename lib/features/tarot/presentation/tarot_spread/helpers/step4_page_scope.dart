import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/helpers/step4_page_mixin.dart';
import 'package:flutter/widgets.dart';

class Step4PageScope extends InheritedWidget {
  const Step4PageScope({required this.state, required super.child, super.key});
  final Step4PageMixin state;

  static Step4PageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Step4PageScope>();
    assert(result != null, 'No Step4PageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Step4PageScope oldWidget) => false;
}
