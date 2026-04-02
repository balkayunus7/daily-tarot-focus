import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/presentation/tarot_question/helpers/question_topic_enum.dart';
import 'package:daily_tarot_focus/presentation/tarot_question/pages/tarot_question_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

enum QuestionCardCount {
  singleCardCount(1),
  multipleCardCount(3);

  const QuestionCardCount(this.value);
  final int value;
}

mixin QuestionPageStateMixin on State<TarotQuestionPage> {
  late final TextEditingController questionController;
  late final ValueNotifier<QuestionTopic?> selectedTopic;
  late final ValueNotifier<QuestionCardCount?> selectedCardCount;

  @override
  void initState() {
    questionController = TextEditingController();
    selectedTopic = ValueNotifier(QuestionTopic.career);
    selectedCardCount = ValueNotifier(QuestionCardCount.singleCardCount);
    super.initState();
  }

  @override
  void dispose() {
    questionController.dispose();
    selectedTopic.dispose();
    selectedCardCount.dispose();
    super.dispose();
  }

  set topic(QuestionTopic topic) {
    selectedTopic.value = topic;
  }

  set cardCount(QuestionCardCount count) {
    selectedCardCount.value = count;
  }

  void getSuggestedQuestion() {
    final suggestedQuestions = [
      LocaleKeys.question_page_suggested_question_1,
      LocaleKeys.question_page_suggested_question_2,
      LocaleKeys.question_page_suggested_question_3,
      LocaleKeys.question_page_suggested_question_4,
      LocaleKeys.question_page_suggested_question_5,
      LocaleKeys.question_page_suggested_question_6,
      LocaleKeys.question_page_suggested_question_7,
      LocaleKeys.question_page_suggested_question_8,
      LocaleKeys.question_page_suggested_question_9,
      LocaleKeys.question_page_suggested_question_10,
      LocaleKeys.question_page_suggested_question_11,
      LocaleKeys.question_page_suggested_question_12,
      LocaleKeys.question_page_suggested_question_13,
      LocaleKeys.question_page_suggested_question_14,
      LocaleKeys.question_page_suggested_question_15,
      LocaleKeys.question_page_suggested_question_16,
      LocaleKeys.question_page_suggested_question_17,
      LocaleKeys.question_page_suggested_question_18,
      LocaleKeys.question_page_suggested_question_19,
      LocaleKeys.question_page_suggested_question_20,
    ];

    final currentText = questionController.text;
    final otherQuestions = suggestedQuestions
        .where((key) => key.tr() != currentText)
        .toList();
    
    if (otherQuestions.isNotEmpty) {
      questionController.text = (otherQuestions..shuffle()).first.tr();
    } else {
      questionController.text = (List<String>.from(suggestedQuestions)..shuffle()).first.tr();
    }
  }
}
