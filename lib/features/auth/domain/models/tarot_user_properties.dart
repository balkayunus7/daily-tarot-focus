import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_career_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/user.dart';
import 'package:mobile_boilerplate/domain/auth/user_properties.dart';

class TarotUserProperties extends UserProperties with EquatableMixin {
  const TarotUserProperties({
    required this.relationshipStatus,
    required this.careerStatus,
    required this.name,
    required this.birthDate,
    required this.location,
    this.zodiac,
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
      relationshipStatus: RelationshipStatus.fromString(map['relationship_status'] as String),
      careerStatus: CareerStatus.fromString(map['career_status'] as String),
      name: map['name'] as String? ?? '',
      birthDate:
          map['birth_date'] != null
              ? DateTime.tryParse(map['birth_date'] as String) ?? DateTime.now()
              : DateTime.now(),
      location: map['location'] as String? ?? '',
      zodiac: tryParseSign(map['zodiac_sign']),
      moonSign: tryParseSign(map['moon_sign']),
      risingSign: tryParseSign(map['rising_sign']),
    );
  }

  final RelationshipStatus relationshipStatus;
  final CareerStatus careerStatus;
  final String name;
  final DateTime birthDate;
  final String location;
  final ZodiacSign? zodiac;
  final ZodiacSign? moonSign;
  final ZodiacSign? risingSign;

  Map<String, dynamic> toMap() {
    return {
      'relationship_status': relationshipStatus.value,
      'career_status': careerStatus.value,
      'name': name,
      'birth_date': birthDate.toIso8601String(),
      'location': location,
      if (zodiac != null) 'zodiac_sign': zodiac!.value,
      if (moonSign != null) 'moon_sign': moonSign!.value,
      if (risingSign != null) 'rising_sign': risingSign!.value,
    };
  }

  TarotUserProperties copyWith({
    RelationshipStatus? relationshipStatus,
    CareerStatus? careerStatus,
    String? name,
    DateTime? birthDate,
    String? location,
    ZodiacSign? zodiac,
    ZodiacSign? moonSign,
    ZodiacSign? risingSign,
  }) {
    return TarotUserProperties(
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      careerStatus: careerStatus ?? this.careerStatus,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      location: location ?? this.location,
      zodiac: zodiac ?? this.zodiac,
      moonSign: moonSign ?? this.moonSign,
      risingSign: risingSign ?? this.risingSign,
    );
  }

  @override
  User applyTo(User user) {
    return (user as TarotUser).copyWith(
      relationshipStatus: relationshipStatus,
      careerStatus: careerStatus,
      name: name,
      birthDate: birthDate,
      location: location,
      zodiac: zodiac,
      moonSign: moonSign,
      risingSign: risingSign,
    );
  }

  @override
  List<Object?> get props => [
    relationshipStatus,
    careerStatus,
    name,
    birthDate,
    location,
    zodiac,
    moonSign,
    risingSign,
  ];
}
