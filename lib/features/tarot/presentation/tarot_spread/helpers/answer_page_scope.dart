import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/helpers/answer_page_mixin.dart';
import 'package:flutter/widgets.dart';

class AnswerPageScope extends InheritedWidget {
  const AnswerPageScope({required this.state, required super.child, super.key});
  final AnswerPageMixin state;

  static AnswerPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AnswerPageScope>();
    assert(result != null, 'No AnswerPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AnswerPageScope oldWidget) => false;
}
