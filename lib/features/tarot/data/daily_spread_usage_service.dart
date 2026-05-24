import 'package:shared_preferences/shared_preferences.dart';

class DailySpreadUsageService {
  const DailySpreadUsageService._();

  static const freeDailyLimit = 1;
  static const premiumDailyLimit = 2;

  static Future<int> getCount({
    required String userId,
    required DateTime date,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key(userId: userId, date: date)) ?? 0;
  }

  static Future<void> increment({
    required String userId,
    required DateTime date,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(userId: userId, date: date);
    final count = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, count + 1);
  }

  static Future<void> reset({
    required String userId,
    required DateTime date,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(userId: userId, date: date));
  }

  static int limitFor({required bool isPremium}) {
    return isPremium ? premiumDailyLimit : freeDailyLimit;
  }

  static String _key({required String userId, required DateTime date}) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return 'daily_spread_usage.$userId.${date.year}-$month-$day';
  }
}
