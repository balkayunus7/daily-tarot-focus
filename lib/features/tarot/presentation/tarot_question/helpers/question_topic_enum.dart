enum QuestionTopic {
  career('Career'),
  love('Love'),
  health('Health');

  const QuestionTopic(this.value);

  factory QuestionTopic.fromString(String value) =>
      QuestionTopic.values.firstWhere((e) => e.value == value);

  final String value;

  bool get isCareer => this == QuestionTopic.career;
  bool get isLove => this == QuestionTopic.love;
  bool get isHealth => this == QuestionTopic.health;
}
