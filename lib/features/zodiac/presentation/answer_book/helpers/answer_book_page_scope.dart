import 'package:daily_tarot_focus/features/zodiac/presentation/answer_book/helpers/answer_book_page_mixin.dart';
import 'package:flutter/widgets.dart';

class AnswerBookPageScope extends InheritedWidget {
  const AnswerBookPageScope({required this.state, required super.child, super.key});
  final AnswerBookPageMixin state;

  static AnswerBookPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AnswerBookPageScope>();
    assert(result != null, 'No AnswerBookPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AnswerBookPageScope oldWidget) => false;
}
