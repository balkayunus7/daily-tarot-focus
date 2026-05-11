import 'dart:convert';

import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac/zodiac_state.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_response_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class ImplZodiacCacheService {
  static const _horoscopeKey = 'zodiac_horoscope_cache';
  static const _compatibilityKey = 'zodiac_compatibility_cache';

  Future<Map<String, CachedHoroscope>?> getHoroscopeCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_horoscopeKey);
      if (json == null) {
        return null;
      }
      final map = jsonDecode(json) as Map<String, dynamic>;
      final result = <String, CachedHoroscope>{};
      for (final entry in map.entries) {
        final cached = CachedHoroscope.fromMap(entry.value as Map<String, dynamic>);
        if (!cached.isExpired) {
          result[entry.key] = cached;
        }
      }
      return result;
    } on Exception {
      return null;
    }
  }

  Future<void> saveHoroscopeCache(Map<String, CachedHoroscope> cache) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mapToSave = <String, dynamic>{};
      for (final entry in cache.entries) {
        if (!entry.value.isExpired) {
          mapToSave[entry.key] = entry.value.toMap();
        }
      }
      await prefs.setString(_horoscopeKey, jsonEncode(mapToSave));
    } on Exception {
      return;
    }
  }

  Future<Map<String, GenerateCompatibilityResponse>?> getCompatibilityCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_compatibilityKey);
      if (json == null) {
        return null;
      }
      final map = jsonDecode(json) as Map<String, dynamic>;
      final result = {
        for (final e in map.entries)
          e.key: GenerateCompatibilityResponseModel.fromMap(e.value as Map<String, dynamic>),
      };
      return result;
    } on Exception {
      return null;
    }
  }

  Future<void> saveCompatibilityCache(Map<String, GenerateCompatibilityResponse> cache) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _compatibilityKey,
        jsonEncode({for (final e in cache.entries) e.key: e.value.toMap()}),
      );
    } on Exception {
      return;
    }
  }
}
