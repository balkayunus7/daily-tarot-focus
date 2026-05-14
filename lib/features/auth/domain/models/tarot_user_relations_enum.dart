import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconify_flutter/icons/mdi.dart';

enum RelationshipStatus {
  single('Single'),
  inARelationship('In a relationship'),
  engaged('Engaged'),
  married('Married'),
  itsComplicated('Its complicated'),
  dating('Dating'),
  openRelationship('Open relationship'),
  separated('Separated'),
  divorced('Divorced'),
  healing('Healing'),
  manifesting('Manifesting love'),
  preferNotToSay('Prefer not to say');

  const RelationshipStatus(this.value);

  factory RelationshipStatus.fromString(String value) => RelationshipStatus.values.firstWhere(
    (e) => e.value == value,
    orElse: () => RelationshipStatus.preferNotToSay,
  );

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
      case RelationshipStatus.dating:
        return LocaleKeys.relationship_status_dating.tr();
      case RelationshipStatus.openRelationship:
        return LocaleKeys.relationship_status_open_relationship.tr();
      case RelationshipStatus.separated:
        return LocaleKeys.relationship_status_separated.tr();
      case RelationshipStatus.divorced:
        return LocaleKeys.relationship_status_divorced.tr();
      case RelationshipStatus.healing:
        return LocaleKeys.relationship_status_healing.tr();
      case RelationshipStatus.manifesting:
        return LocaleKeys.relationship_status_manifesting.tr();
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
    RelationshipStatus.dating => '☕', // Veya 🦋
    RelationshipStatus.openRelationship => '♾️',
    RelationshipStatus.separated => '🥀',
    RelationshipStatus.divorced => '🕊️', // Özgürlük / Yeni başlangıç
    RelationshipStatus.healing => '❤️‍🩹',
    RelationshipStatus.manifesting => '✨',
    RelationshipStatus.preferNotToSay => '🤐',
  };

  String get icon => switch (this) {
    RelationshipStatus.single => Mdi.account,
    RelationshipStatus.inARelationship => Mdi.heart,
    RelationshipStatus.engaged => Mdi.ring,
    RelationshipStatus.married => Mdi.account_multiple,
    RelationshipStatus.itsComplicated => Mdi.help_circle_outline,
    RelationshipStatus.dating => Mdi.coffee_outline,
    RelationshipStatus.openRelationship => Mdi.infinity,
    RelationshipStatus.separated => Mdi.call_split,
    RelationshipStatus.divorced => Mdi.leaf_maple,
    RelationshipStatus.healing => Mdi.bandage,
    RelationshipStatus.manifesting => Mdi.auto_fix,
    RelationshipStatus.preferNotToSay => Mdi.eye_off_outline,
  };
}
