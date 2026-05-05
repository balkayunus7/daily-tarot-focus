import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_career_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/user.dart';
import 'package:mobile_boilerplate/domain/auth/user_properties.dart';

class TarotUserProperties extends UserProperties with EquatableMixin {
  const TarotUserProperties({
    required this.zodiac,
    required this.relationshipStatus,
    required this.careerStatus,
    this.moonSign,
    this.risingSign,
  });

  factory TarotUserProperties.fromMap(Map<String, dynamic> map) {
    ZodiacSign? tryParseSign(dynamic v) {
      if (v == null) return null;
      try {
        return ZodiacSign.fromString(v as String);
      } on Exception {
        return null;
      }
    }

    return TarotUserProperties(
      zodiac: ZodiacSign.fromString(map['zodiac_sign'] as String),
      relationshipStatus: RelationshipStatus.fromString(map['relationship_status'] as String),
      careerStatus: CareerStatus.fromString(map['career_status'] as String),
      moonSign: tryParseSign(map['moon_sign']),
      risingSign: tryParseSign(map['rising_sign']),
    );
  }

  final ZodiacSign zodiac;
  final RelationshipStatus relationshipStatus;
  final CareerStatus careerStatus;
  final ZodiacSign? moonSign;
  final ZodiacSign? risingSign;

  Map<String, dynamic> toMap() {
    return {
      'zodiac_sign': zodiac.value,
      'relationship_status': relationshipStatus.value,
      'career_status': careerStatus.value,
      if (moonSign != null) 'moon_sign': moonSign!.value,
      if (risingSign != null) 'rising_sign': risingSign!.value,
    };
  }

  TarotUserProperties copyWith({
    ZodiacSign? zodiac,
    RelationshipStatus? relationshipStatus,
    CareerStatus? careerStatus,
    ZodiacSign? moonSign,
    ZodiacSign? risingSign,
  }) {
    return TarotUserProperties(
      zodiac: zodiac ?? this.zodiac,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      careerStatus: careerStatus ?? this.careerStatus,
      moonSign: moonSign ?? this.moonSign,
      risingSign: risingSign ?? this.risingSign,
    );
  }

  @override
  User applyTo(User user) {
    return (user as TarotUser).copyWith(
      zodiac: zodiac,
      relationshipStatus: relationshipStatus,
      careerStatus: careerStatus,
      moonSign: moonSign,
      risingSign: risingSign,
    );
  }

  @override
  List<Object?> get props => [zodiac, relationshipStatus, careerStatus, moonSign, risingSign];
}
