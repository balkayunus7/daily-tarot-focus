import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_career_enum.dart';
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
    this.relationshipStatus,
    this.careerStatus,
    this.name,
    this.birthDate,
    this.location,
    this.zodiac,
    this.moonSign,
    this.risingSign,
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
      relationshipStatus:
          map['relationship_status'] != null
              ? RelationshipStatus.fromString(
                map['relationship_status'] as String,
              )
              : null,
      careerStatus:
          map['career_status'] != null
              ? CareerStatus.fromString(map['career_status'] as String)
              : null,
      name: map['name'] as String?,
      birthDate: map['birth_date'] != null
          ? DateTime.tryParse(map['birth_date'] as String)
          : null,
      location: map['location'] as String?,
      zodiac:
          map['zodiac_sign'] != null
              ? ZodiacSign.fromString(map['zodiac_sign'] as String)
              : null,
      moonSign:
          map['moon_sign'] != null
              ? ZodiacSign.fromString(map['moon_sign'] as String)
              : null,
      risingSign:
          map['rising_sign'] != null
              ? ZodiacSign.fromString(map['rising_sign'] as String)
              : null,
    );
  }

  final RelationshipStatus? relationshipStatus;
  final CareerStatus? careerStatus;
  final String? name;
  final DateTime? birthDate;
  final String? location;
  final ZodiacSign? zodiac;
  final ZodiacSign? moonSign;
  final ZodiacSign? risingSign;

  bool get isProfileComplete =>
      relationshipStatus != null &&
      careerStatus != null &&
      name != null &&
      name!.isNotEmpty &&
      birthDate != null &&
      location != null &&
      location!.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'revenuecat_id': purchaser.id,
      'premium_info': subscription?.toMap(),
      'relationship_status': relationshipStatus?.value,
      'career_status': careerStatus?.value,
      if (name != null) 'name': name,
      if (birthDate != null) 'birth_date': birthDate!.toIso8601String(),
      if (location != null) 'location': location,
      if (zodiac != null) 'zodiac_sign': zodiac!.value,
      if (moonSign != null) 'moon_sign': moonSign!.value,
      if (risingSign != null) 'rising_sign': risingSign!.value,
    };
  }

  TarotUser copyWith({
    Purchaser? purchaser,
    RelationshipStatus? relationshipStatus,
    CareerStatus? careerStatus,
    String? name,
    DateTime? birthDate,
    String? location,
    ZodiacSign? zodiac,
    ZodiacSign? moonSign,
    ZodiacSign? risingSign,
  }) {
    return TarotUser(
      userId: userId,
      purchaser: purchaser ?? this.purchaser,
      subscription: subscription,
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
  List<Object?> get props => [
    userId,
    purchaser,
    subscription,
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
