import 'package:daily_tarot_focus/features/auth/domain/entities/tarot_user_properties.dart';
import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_zodiac_enum.dart';

class TarotUserPropertiesModel {
  final String zodiacSign;
  final String relationshipStatus;
  final String birthDate;

  const TarotUserPropertiesModel({
    required this.zodiacSign,
    required this.relationshipStatus,
    required this.birthDate,
  });

  factory TarotUserPropertiesModel.fromMap(Map<String, dynamic> map) {
    return TarotUserPropertiesModel(
      zodiacSign: map['zodiac_sign'] as String,
      relationshipStatus: map['relationship_status'] as String,
      birthDate: map['birth_date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'zodiac_sign': zodiacSign,
      'relationship_status': relationshipStatus,
      'birth_date': birthDate,
    };
  }

  TarotUserProperties toEntity() {
    return TarotUserProperties(
      zodiac: ZodiacSign.fromString(zodiacSign),
      relationshipStatus: RelationshipStatus.fromString(relationshipStatus),
      birthDate: DateTime.parse(birthDate),
    );
  }

  factory TarotUserPropertiesModel.fromEntity(TarotUserProperties entity) {
    return TarotUserPropertiesModel(
      zodiacSign: entity.zodiac.value,
      relationshipStatus: entity.relationshipStatus.value,
      birthDate: entity.birthDate.toIso8601String(),
    );
  }
}

