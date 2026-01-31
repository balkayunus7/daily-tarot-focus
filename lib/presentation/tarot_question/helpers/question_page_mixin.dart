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
      LocaleKeys.questionSuggestedQuestion1,
      LocaleKeys.questionSuggestedQuestion2,
      LocaleKeys.questionSuggestedQuestion3,
      LocaleKeys.questionSuggestedQuestion4,
      LocaleKeys.questionSuggestedQuestion5,
      LocaleKeys.questionSuggestedQuestion6,
      LocaleKeys.questionSuggestedQuestion7,
      LocaleKeys.questionSuggestedQuestion8,
      LocaleKeys.questionSuggestedQuestion9,
      LocaleKeys.questionSuggestedQuestion10,
      LocaleKeys.questionSuggestedQuestion11,
      LocaleKeys.questionSuggestedQuestion12,
      LocaleKeys.questionSuggestedQuestion13,
      LocaleKeys.questionSuggestedQuestion14,
      LocaleKeys.questionSuggestedQuestion15,
      LocaleKeys.questionSuggestedQuestion16,
      LocaleKeys.questionSuggestedQuestion17,
      LocaleKeys.questionSuggestedQuestion18,
      LocaleKeys.questionSuggestedQuestion19,
      LocaleKeys.questionSuggestedQuestion20,
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
