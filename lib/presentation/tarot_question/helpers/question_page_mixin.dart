import 'package:daily_tarot_focus/presentation/tarot_question/pages/tarot_question_page.dart';
import 'package:flutter/material.dart';

enum QuestionCardCount {
  singleCardCount(1),
  multipleCardCount(3);

  const QuestionCardCount(this.value);
  final int value;
}

mixin QuestionPageStateMixin on State<TarotQuestionPage> {
  late final TextEditingController questionController;
  late final ValueNotifier<TarotReadingTopic?> selectedReadingTopic;
  late final ValueNotifier<QuestionCardCount?> selectedCardCount;

  @override
  void initState() {
    questionController = TextEditingController();
    selectedReadingTopic = ValueNotifier(TarotReadingTopic.career);
    selectedCardCount = ValueNotifier(QuestionCardCount.singleCardCount);
    super.initState();
  }

  @override
  void dispose() {
    questionController.dispose();
    super.dispose();
  }

  set readingTopic(TarotReadingTopic topic) {
    selectedReadingTopic.value = topic;
  }

  set cardCount(QuestionCardCount count) {
    selectedCardCount.value = count;
  }
}
