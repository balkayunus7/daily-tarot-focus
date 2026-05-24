import 'package:flutter/foundation.dart';
import 'package:mobile_boilerplate/domain/auth/user.dart';

class PremiumOverrideService {
  PremiumOverrideService._();

  static final ValueNotifier<bool> forcePremium = ValueNotifier(false);

  static bool isPremium({
    required User user,
    required DateTime networkTime,
  }) {
    return forcePremium.value || user.isSubscribed(networkTime: networkTime);
  }

  static bool get isForcePremium => forcePremium.value;

  static set isForcePremium(bool value) {
    forcePremium.value = value;
  }
}
