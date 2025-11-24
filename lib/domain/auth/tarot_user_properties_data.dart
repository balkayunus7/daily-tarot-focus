import 'package:daily_tarot_focus/domain/auth/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user_zodiac_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tarot_user_properties_data.freezed.dart';

@freezed
class TarotUserPropertiesData with _$TarotUserPropertiesData {
  const factory TarotUserPropertiesData({
    required ZodiacSign zodiac,
    required RelationshipStatus relationshipStatus,
    required DateTime birthDate,
  }) = _TarotUserPropertiesData;

  factory TarotUserPropertiesData.fromMap(Map<String, dynamic> map) {
    return TarotUserPropertiesData(
      zodiac: map['zodiac'],
      relationshipStatus: map['relationship_status'],
      birthDate: map['birth_date'],
    );
  }

  const TarotUserPropertiesData._();

  Map<String, dynamic> toMap() {
    return {
      'birth_date': birthDate,
      'relationship_status': relationshipStatus,
      'zodiac_sign': zodiac,
    };
  }
}
