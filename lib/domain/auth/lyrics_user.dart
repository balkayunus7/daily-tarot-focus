import 'package:mobile_core/common_dependencies.dart';
import 'package:mobile_core/domain/auth/purchaser.dart';
import 'package:mobile_core/domain/auth/user.dart';
import 'package:mobile_core/domain/purchases/subscription.dart';
import 'package:mobile_core/domain/purchases/subscription_plan.dart';

class LyricsUser extends User {
  const LyricsUser({
    required super.purchaser,
    required super.userId,
    required super.subscription,
  });

  factory LyricsUser.fromMap(Map<String, dynamic> map) {
    return LyricsUser(
      userId: map['user_id'] as String,
      subscription:
          map['premium_info'] == null
              ? null
              : Subscription.fromMap(
                map['premium_info'] as Map<String, dynamic>,
              ),
      purchaser: Purchaser(
        id: map['revenuecat_id'] as String,
        offerings: PurchaseOfferings(
          subscriptionOfferingIds: KtMap.from({
            SubscriptionPlan.premium: 'premium',
          }),
        ),
      ),
    );
  }

  LyricsUser copyWith({Purchaser? purchaser}) {
    return LyricsUser(
      userId: userId,
      purchaser: purchaser ?? this.purchaser,
      subscription: subscription,
    );
  }

  @override
  List<Object?> get props => [userId, purchaser, subscription];
}
