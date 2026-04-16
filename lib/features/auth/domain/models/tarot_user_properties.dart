import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_career_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/user_properties.dart';

class TarotUserProperties extends UserProperties with EquatableMixin {
  const TarotUserProperties({
    required this.zodiac,
    required this.relationshipStatus,
    required this.careerStatus,
  });

  factory TarotUserProperties.fromMap(Map<String, dynamic> map) {
    return TarotUserProperties(
      zodiac: ZodiacSign.fromString(map['zodiac_sign'] as String),
      relationshipStatus: RelationshipStatus.fromString(map['relationship_status'] as String),
      careerStatus: CareerStatus.fromString(map['career_status'] as String),
    );
  }

  final ZodiacSign zodiac;
  final RelationshipStatus relationshipStatus;
  final CareerStatus careerStatus;

  Map<String, dynamic> toMap() {
    return {
      'zodiac_sign': zodiac.value,
      'relationship_status': relationshipStatus.value,
      'career_status': careerStatus.value,
    };
  }

  TarotUserProperties copyWith({
    ZodiacSign? zodiac,
    RelationshipStatus? relationshipStatus,
    CareerStatus? careerStatus,
  }) {
    return TarotUserProperties(
      zodiac: zodiac ?? this.zodiac,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      careerStatus: careerStatus ?? this.careerStatus,
    );
  }

  @override
  List<Object?> get props => [zodiac, relationshipStatus, careerStatus];
}
