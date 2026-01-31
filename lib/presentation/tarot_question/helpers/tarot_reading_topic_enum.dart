part of '../pages/tarot_question_page.dart';

enum TarotReadingTopic {
  career('Career'),
  love('Love'),
  health('Health');

  const TarotReadingTopic(this.value);

  factory TarotReadingTopic.fromString(String value) =>
      TarotReadingTopic.values.firstWhere((e) => e.value == value);

  final String value;

  bool get isCareer => this == TarotReadingTopic.career;
  bool get isLove => this == TarotReadingTopic.love;
  bool get isHealth => this == TarotReadingTopic.health;
}
