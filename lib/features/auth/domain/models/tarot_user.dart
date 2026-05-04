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
    this.zodiac,
    this.relationshipStatus,
    this.careerStatus,
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
      zodiac:
          map['zodiac_sign'] != null ? ZodiacSign.fromString(map['zodiac_sign'] as String) : null,
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
      moonSign:
          map['moon_sign'] != null ? ZodiacSign.fromString(map['moon_sign'] as String) : null,
      risingSign:
          map['rising_sign'] != null ? ZodiacSign.fromString(map['rising_sign'] as String) : null,
    );
  }
  final ZodiacSign? zodiac;
  final RelationshipStatus? relationshipStatus;
  final CareerStatus? careerStatus;
  final ZodiacSign? moonSign;
  final ZodiacSign? risingSign;

  bool get isProfileComplete =>
      zodiac != null && relationshipStatus != null && careerStatus != null;

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'revenuecat_id': purchaser.id,
      'premium_info': subscription?.toMap(),
      'zodiac_sign': zodiac?.value,
      'relationship_status': relationshipStatus?.value,
      'career_status': careerStatus?.value,
      if (moonSign != null) 'moon_sign': moonSign!.value,
      if (risingSign != null) 'rising_sign': risingSign!.value,
    };
  }

  TarotUser copyWith({
    Purchaser? purchaser,
    ZodiacSign? zodiac,
    RelationshipStatus? relationshipStatus,
    CareerStatus? careerStatus,
    ZodiacSign? moonSign,
    ZodiacSign? risingSign,
  }) {
    return TarotUser(
      userId: userId,
      purchaser: purchaser ?? this.purchaser,
      subscription: subscription,
      zodiac: zodiac ?? this.zodiac,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      careerStatus: careerStatus ?? this.careerStatus,
      moonSign: moonSign ?? this.moonSign,
      risingSign: risingSign ?? this.risingSign,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    purchaser,
    subscription,
    zodiac,
    relationshipStatus,
    careerStatus,
    moonSign,
    risingSign,
  ];
}
