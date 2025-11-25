import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_zodiac_enum.dart';
import 'package:mobile_boilerplate/domain/auth/purchaser.dart';
import 'package:mobile_boilerplate/domain/auth/user.dart';

class TarotUser extends User {
  final ZodiacSign? zodiac;
  final RelationshipStatus? relationshipStatus;
  final DateTime? birthDate;

  const TarotUser({
    required super.purchaser,
    required super.userId,
    required super.subscription,
    this.zodiac,
    this.relationshipStatus,
    this.birthDate,
  });

  bool get isProfileComplete =>
      zodiac != null && relationshipStatus != null && birthDate != null;

  int? get age {
    if (birthDate == null) return null;
    final today = DateTime.now();
    int age = today.year - birthDate!.year;
    if (today.month < birthDate!.month ||
        (today.month == birthDate!.month && today.day < birthDate!.day)) {
      age--;
    }
    return age;
  }

  TarotUser copyWith({
    Purchaser? purchaser,
    ZodiacSign? zodiac,
    RelationshipStatus? relationshipStatus,
    DateTime? birthDate,
  }) {
    return TarotUser(
      userId: userId,
      purchaser: purchaser ?? this.purchaser,
      subscription: subscription,
      zodiac: zodiac ?? this.zodiac,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  @override
  List<Object?> get props =>
      [userId, purchaser, subscription, zodiac, relationshipStatus, birthDate];
}
