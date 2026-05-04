import 'dart:convert';

import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class ImplTarotCacheService {
  static const _cardsKey = 'tarot_cards_cache';
  static const _spreadsKey = 'tarot_spreads_cache';
  static const _readersKey = 'tarot_readers_cache';

  // CARDS
  Future<List<TarotCardModel>?> getCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_cardsKey);
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
      await prefs.setString(_cardsKey, jsonEncode(cards.map((e) => e.toMap()).toList()));
    } on Exception catch (_) {}
  }

  // SPREADS
  Future<List<TarotSpreadCategoryModel>?> getSpreads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_spreadsKey);
      if (json == null) return null;
      final list = jsonDecode(json) as List;
      return list.map((e) => TarotSpreadCategoryModel.fromMap(e as Map<String, dynamic>)).toList();
    } on Exception catch (_) {
      return null;
    }
  }

  Future<void> saveSpreads(List<TarotSpreadCategoryModel> spreads) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_spreadsKey, jsonEncode(spreads.map((e) => e.toMap()).toList()));
    } on Exception catch (_) {}
  }

  // READERS
  Future<List<TarotReaderModel>?> getReaders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_readersKey);
      if (json == null) return null;
      final list = jsonDecode(json) as List;
      return list.map((e) => TarotReaderModel.fromMap(e as Map<String, dynamic>)).toList();
    } on Exception catch (_) {
      return null;
    }
  }

  Future<void> saveReaders(List<TarotReaderModel> readers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_readersKey, jsonEncode(readers.map((e) => e.toMap()).toList()));
    } on Exception catch (_) {}
  }

  // CLEAR
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.remove(_cardsKey),
        prefs.remove(_spreadsKey),
        prefs.remove(_readersKey),
      ]);
    } on Exception catch (_) {}
  }

  Future<bool> hasCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_cardsKey) &&
          prefs.containsKey(_spreadsKey) &&
          prefs.containsKey(_readersKey);
    } on Exception catch (_) {
      return false;
    }
  }
}
