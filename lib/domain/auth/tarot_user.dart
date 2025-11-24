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
  });

  factory TarotUser.fromMap(Map<String, dynamic> map) {
    return TarotUser(
      userId: map['user_id'] as String,
      subscription:
          map['premium_info'] == null
              ? null
              : Subscription.fromMap(
                map['premium_info'] as Map<String, dynamic>,
              ),
      purchaser: Purchaser(
        id: map['revenuecat_id'] as String? ?? 'unknown',
        offerings: PurchaseOfferings(
          subscriptionOfferingIds: KtMap.from({
            SubscriptionPlan.premium: 'premium',
          }),
        ),
      ),
    );
  }

  TarotUser copyWith({Purchaser? purchaser}) {
    return TarotUser(
      userId: userId,
      purchaser: purchaser ?? this.purchaser,
      subscription: subscription,
    );
  }

  @override
  List<Object?> get props => [userId, purchaser, subscription];
}
