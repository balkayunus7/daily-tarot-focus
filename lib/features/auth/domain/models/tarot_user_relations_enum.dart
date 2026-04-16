import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconify_flutter/icons/mdi.dart';

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

  String get localizedName {
    switch (this) {
      case RelationshipStatus.single:
        return LocaleKeys.relationship_status_single.tr();
      case RelationshipStatus.inARelationship:
        return LocaleKeys.relationship_status_in_a_relationship.tr();
      case RelationshipStatus.engaged:
        return LocaleKeys.relationship_status_engaged.tr();
      case RelationshipStatus.married:
        return LocaleKeys.relationship_status_married.tr();
      case RelationshipStatus.itsComplicated:
        return LocaleKeys.relationship_status_its_complicated.tr();
      case RelationshipStatus.preferNotToSay:
        return LocaleKeys.relationship_status_prefer_not_to_say.tr();
    }
  }

  String get emoji => switch (this) {
    RelationshipStatus.single => '💫',
    RelationshipStatus.inARelationship => '💑',
    RelationshipStatus.engaged => '💍',
    RelationshipStatus.married => '💒',
    RelationshipStatus.itsComplicated => '🤔',
    RelationshipStatus.preferNotToSay => '🤐',
  };

  String get icon => switch (this) {
    RelationshipStatus.single => Mdi.account,
    RelationshipStatus.inARelationship => Mdi.heart,
    RelationshipStatus.engaged => Mdi.ring,
    RelationshipStatus.married => Mdi.account_multiple,
    RelationshipStatus.itsComplicated => Mdi.help_circle,
    RelationshipStatus.preferNotToSay => Mdi.eye_off,
  };
}
