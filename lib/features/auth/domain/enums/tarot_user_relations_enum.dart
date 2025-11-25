enum RelationshipStatus {
  single('Single'),
  inARelationship('In a relationship'),
  engaged('Engaged'),
  married('Married'),
  itsComplicated('Its complicated'),
  preferNotToSay('Prefer not to say');

  final String value;
  const RelationshipStatus(this.value);

  factory RelationshipStatus.fromString(String value) =>
      RelationshipStatus.values.firstWhere((e) => e.value == value);
}
