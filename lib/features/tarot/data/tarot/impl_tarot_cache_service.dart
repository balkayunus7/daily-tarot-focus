import 'dart:convert';

import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImplTarotCacheService {
  static const _cacheKey = 'tarot_cards_cache';

  Future<List<TarotCardModel>?> getCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_cacheKey);
      if (json == null) return null;

      final list = jsonDecode(json) as List;
      return list.map((e) => TarotCardModel.fromMap(e as Map<String, dynamic>)).toList();
    } on Exception catch (_) {
      return null;
    }
  }

  Future<void> saveCards(List<TarotCardModel> cards) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(cards.map((e) => e.toMap()).toList());
      await prefs.setString(_cacheKey, json);
    } on Exception catch (_) {}
  }

  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
    } on Exception catch (_) {}
  }

  Future<bool> hasCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_cacheKey);
    } on Exception catch (_) {
      return false;
    }
  }
}
