enum RelationshipStatus {
  single('Single'),
  inARelationship('In a relationship'),
  engaged('Engaged'),
  married('Married'),
  itsComplicated('Its complicated'),
  preferNotToSay('Prefer not to say');

  const RelationshipStatus(this.value);

  factory RelationshipStatus.fromString(String value) =>
      RelationshipStatus.values.firstWhere((e) => e.value == value);

  final String value;

  bool get isSingle => this == RelationshipStatus.single;
  bool get isInARelationship => this == RelationshipStatus.inARelationship;
  bool get isEngaged => this == RelationshipStatus.engaged;
  bool get isMarried => this == RelationshipStatus.married;
  bool get isItsComplicated => this == RelationshipStatus.itsComplicated;
  bool get isPreferNotToSay => this == RelationshipStatus.preferNotToSay;

  String get emoji => switch (this) {
    RelationshipStatus.single => '💫',
    RelationshipStatus.inARelationship => '💑',
    RelationshipStatus.engaged => '💍',
    RelationshipStatus.married => '💒',
    RelationshipStatus.itsComplicated => '🤔',
    RelationshipStatus.preferNotToSay => '🤐',
  };
}
