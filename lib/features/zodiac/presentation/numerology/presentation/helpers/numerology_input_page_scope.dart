import 'package:daily_tarot_focus/features/zodiac/presentation/numerology/presentation/helpers/numerology_input_page_mixin.dart';
import 'package:flutter/widgets.dart';

class NumerologyInputPageScope extends InheritedWidget {
  const NumerologyInputPageScope({required this.state, required super.child, super.key});
  final NumerologyInputPageMixin state;

  static NumerologyInputPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<NumerologyInputPageScope>();
    assert(result != null, 'No NumerologyInputPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(NumerologyInputPageScope oldWidget) => false;
}
