import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/purchaser.dart';
import 'package:mobile_boilerplate/domain/auth/user.dart';
import 'package:mobile_boilerplate/domain/purchases/subscription.dart';
import 'package:mobile_boilerplate/domain/purchases/subscription_plan.dart';

class TarotUser extends User {
  const TarotUser({
    required super.purchaser,
    required super.userId,
    required super.subscription,
    this.zodiac,
    this.relationshipStatus,
    this.birthDate,
  });

  factory TarotUser.fromMap(Map<String, dynamic> map) {
    return TarotUser(
      userId: map['user_id'] as String,
      subscription:
          map['premium_info'] != null
              ? Subscription.fromMap(
                map['premium_info'] as Map<String, dynamic>,
              )
              : null,
      purchaser: Purchaser(
        id: (map['revenuecat_id'] as String?) ?? map['user_id'] as String,
        offerings: PurchaseOfferings(
          subscriptionOfferingIds: KtMap.from({SubscriptionPlan.premium: 'premium'}),
        ),
      ),
      zodiac:
          map['zodiac_sign'] != null ? ZodiacSign.fromString(map['zodiac_sign'] as String) : null,
      relationshipStatus:
          map['relationship_status'] != null
              ? RelationshipStatus.fromString(
                map['relationship_status'] as String,
              )
              : null,
      birthDate: map['birth_date'] != null ? DateTime.parse(map['birth_date'] as String) : null,
    );
  }
  final ZodiacSign? zodiac;
  final RelationshipStatus? relationshipStatus;
  final DateTime? birthDate;

  bool get isProfileComplete => zodiac != null && relationshipStatus != null && birthDate != null;

  int? get age {
    if (birthDate == null) return null;
    final today = DateTime.now();
    var age = today.year - birthDate!.year;
    if (today.month < birthDate!.month ||
        (today.month == birthDate!.month && today.day < birthDate!.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'revenuecat_id': purchaser.id,
      'premium_info': subscription?.toMap(),
      'zodiac_sign': zodiac?.value,
      'relationship_status': relationshipStatus?.value,
      'birth_date': birthDate?.toIso8601String(),
    };
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
  List<Object?> get props => [
    userId,
    purchaser,
    subscription,
    zodiac,
    relationshipStatus,
    birthDate,
  ];
}
