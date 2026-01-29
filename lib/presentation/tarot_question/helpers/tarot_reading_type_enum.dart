part of '../pages/tarot_question_page.dart';

enum TarotReadingType {
  career('Career'),
  love('Love'),
  health('Health');

  const TarotReadingType(this.value);

  factory TarotReadingType.fromString(String value) =>
      TarotReadingType.values.firstWhere((e) => e.value == value);

  final String value;

  bool get isCareer => this == TarotReadingType.career;
  bool get isLove => this == TarotReadingType.love;
  bool get isHealth => this == TarotReadingType.health;
}
