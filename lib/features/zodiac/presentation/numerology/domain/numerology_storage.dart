import 'package:shared_preferences/shared_preferences.dart';

abstract final class NumerologyStorage {
  static const _birthDateKey = 'numerology_birth_date';
  static const _fullNameKey = 'numerology_full_name';

  static Future<(DateTime, String)?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_birthDateKey);
    final name = prefs.getString(_fullNameKey);
    if (dateStr == null || name == null || name.isEmpty) return null;
    return (DateTime.parse(dateStr), name);
  }

  static Future<void> save(DateTime birthDate, String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_birthDateKey, birthDate.toIso8601String());
    await prefs.setString(_fullNameKey, fullName);
  }
}
