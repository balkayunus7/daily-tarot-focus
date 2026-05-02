import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/helpers/step5_page_mixin.dart';
import 'package:flutter/widgets.dart';

class Step5PageScope extends InheritedWidget {
  const Step5PageScope({required this.state, required super.child, super.key});
  final Step5PageMixin state;

  static Step5PageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Step5PageScope>();
    assert(result != null, 'No Step5PageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Step5PageScope oldWidget) => false;
}
