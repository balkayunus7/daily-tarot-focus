import 'package:daily_tarot_focus/features/auth/domain/entities/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/enums/tarot_user_zodiac_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/purchaser.dart';
import 'package:mobile_boilerplate/domain/purchases/subscription.dart';
import 'package:mobile_boilerplate/domain/purchases/subscription_plan.dart';

class TarotUserModel {
  const TarotUserModel({
    required this.userId,
    this.revenuecatId,
    this.premiumInfo,
    this.zodiacSign,
    this.relationshipStatus,
    this.birthDate,
  });
  factory TarotUserModel.fromEntity(TarotUser entity) {
    return TarotUserModel(
      userId: entity.userId,
      revenuecatId: entity.purchaser.id,
      premiumInfo: entity.subscription?.toMap(),
      zodiacSign: entity.zodiac?.value,
      relationshipStatus: entity.relationshipStatus?.value,
      birthDate: entity.birthDate?.toIso8601String(),
    );
  }

  factory TarotUserModel.fromMap(Map<String, dynamic> map) {
    return TarotUserModel(
      userId: map['user_id'] as String,
      revenuecatId: map['revenuecat_id'] as String?,
      premiumInfo: map['premium_info'] as Map<String, dynamic>?,
      zodiacSign: map['zodiac_sign'] as String?,
      relationshipStatus: map['relationship_status'] as String?,
      birthDate: map['birth_date'] as String?,
    );
  }
  final String userId;
  final String? revenuecatId;
  final Map<String, dynamic>? premiumInfo;
  final String? zodiacSign;
  final String? relationshipStatus;
  final String? birthDate;

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'revenuecat_id': revenuecatId,
      'premium_info': premiumInfo,
      'zodiac_sign': zodiacSign,
      'relationship_status': relationshipStatus,
      'birth_date': birthDate,
    };
  }

  TarotUser toEntity() {
    return TarotUser(
      userId: userId,
      subscription:
          premiumInfo == null ? null : Subscription.fromMap(premiumInfo!),
      purchaser: Purchaser(
        id: revenuecatId ?? 'unknown',
        offerings: PurchaseOfferings(
          subscriptionOfferingIds: KtMap.from({
            SubscriptionPlan.premium: 'premium',
          }),
        ),
      ),
      zodiac: zodiacSign != null ? ZodiacSign.fromString(zodiacSign!) : null,
      relationshipStatus:
          relationshipStatus != null
              ? RelationshipStatus.fromString(relationshipStatus!)
              : null,
      birthDate: birthDate != null ? DateTime.parse(birthDate!) : null,
    );
  }
}
