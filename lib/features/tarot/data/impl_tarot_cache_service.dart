import 'dart:convert';

import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class ImplTarotCacheService {
  static String _cardsKey(String locale) => 'tarot_cards_cache_$locale';
  static String _spreadsKey(String locale) => 'tarot_spreads_cache_$locale';
  static String _readersKey(String locale) => 'tarot_readers_cache_$locale';

  // CARDS
  Future<List<TarotCardModel>?> getCards(String locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_cardsKey(locale));
      if (json == null) return null;
      final list = jsonDecode(json) as List;
      final cards = list.map((e) => TarotCardModel.fromMap(e as Map<String, dynamic>)).toList();
      return cards;
    } on Exception {
      return null;
    }
  }

  Future<void> saveCards(List<TarotCardModel> cards, String locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cardsKey(locale), jsonEncode(cards.map((e) => e.toMap()).toList()));
    } on Exception {
      rethrow;
    }
  }

  // SPREADS
  Future<List<TarotSpreadCategoryModel>?> getSpreads(String locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_spreadsKey(locale));
      if (json == null) return null;
      final list = jsonDecode(json) as List;
      final spreads =
          list.map((e) => TarotSpreadCategoryModel.fromMap(e as Map<String, dynamic>)).toList();
      return spreads;
    } on Exception {
      return null;
    }
  }

  Future<void> saveSpreads(List<TarotSpreadCategoryModel> spreads, String locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _spreadsKey(locale),
        jsonEncode(spreads.map((e) => e.toMap()).toList()),
      );
    } on Exception {
      rethrow;
    }
  }

  // READERS
  Future<List<TarotReaderModel>?> getReaders(String locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_readersKey(locale));
      if (json == null) return null;
      final list = jsonDecode(json) as List;
      final readers = list.map((e) => TarotReaderModel.fromMap(e as Map<String, dynamic>)).toList();
      return readers;
    } on Exception {
      return null;
    }
  }

  Future<void> saveReaders(List<TarotReaderModel> readers, String locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _readersKey(locale),
        jsonEncode(readers.map((e) => e.toMap()).toList()),
      );
    } on Exception {
      rethrow;
    }
  }

  // CLEAR
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith('tarot_')).toList();
      await Future.wait(keys.map(prefs.remove));
    } on Exception {
      rethrow;
    }
  }

  Future<bool> hasCache(String locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_cardsKey(locale)) &&
          prefs.containsKey(_spreadsKey(locale)) &&
          prefs.containsKey(_readersKey(locale));
    } on Exception catch (_) {
      return false;
    }
  }
}
