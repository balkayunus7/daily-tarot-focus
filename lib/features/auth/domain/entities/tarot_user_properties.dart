import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_zodiac_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/user_properties.dart';

class TarotUserProperties extends UserProperties with EquatableMixin {
  const TarotUserProperties({
    required this.zodiac,
    required this.relationshipStatus,
    required this.birthDate,
  });

  final ZodiacSign zodiac;
  final RelationshipStatus relationshipStatus;
  final DateTime birthDate;

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
