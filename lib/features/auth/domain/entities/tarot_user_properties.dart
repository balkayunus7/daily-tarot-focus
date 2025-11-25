import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_zodiac_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/user_properties.dart';

class TarotUserProperties extends UserProperties with EquatableMixin {
  final ZodiacSign zodiac;
  final RelationshipStatus relationshipStatus;
  final DateTime birthDate;

  const TarotUserProperties({
    required this.zodiac,
    required this.relationshipStatus,
    required this.birthDate,
  });

  factory TarotUserProperties.fromMap(Map<String, dynamic> map) {
    return TarotUserProperties(
      zodiac: ZodiacSign.fromString(map['zodiac_sign'] as String),
      relationshipStatus: RelationshipStatus.fromString(
        map['relationship_status'] as String,
      ),
      birthDate: DateTime.parse(map['birth_date'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'zodiac_sign': zodiac.value,
      'relationship_status': relationshipStatus.value,
      'birth_date': birthDate.toIso8601String(),
    };
  }

  TarotUserProperties copyWith({
    ZodiacSign? zodiac,
    RelationshipStatus? relationshipStatus,
    DateTime? birthDate,
  }) {
    return TarotUserProperties(
      zodiac: zodiac ?? this.zodiac,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  @override
  List<Object?> get props => [zodiac, relationshipStatus, birthDate];
}
