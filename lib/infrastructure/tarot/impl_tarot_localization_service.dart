import 'dart:convert';
import 'package:daily_tarot_focus/domain/tarot/i_tarot_localization_service.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class ImplTarotLocalizationService implements ITarotLocalizationService {
  static const _baseCardsPath = 'assets/data/tarot_cards.json';
  static const _translationsPath = 'assets/data';

  List<TarotData>? _cachedCards;
  String? _cachedLocale;

  @override
  Future<List<TarotData>> getCards(BuildContext context) async {
    final currentLocale = context.locale.languageCode;

    if (_isLocaleCached(currentLocale)) return _cachedCards!;

    final cards = await _loadCardsWithTranslations(currentLocale);
    _cacheCardsForLocale(cards, currentLocale);

    return cards;
  }

  @override
  Future<TarotData> drawRandomCard(BuildContext context) async {
    final cards = await getCards(context);
    cards.shuffle();
    return cards.first;
  }

  @override
  Future<TarotData?> findCardByTitle(BuildContext context, String title) async {
    final cards = await getCards(context);
    final normalizedTitle = title.toLowerCase();

    return cards.where((card) => card.title.toLowerCase() == normalizedTitle).firstOrNull;
  }

  @override
  Future<List<TarotData>> getCardsByCategory(BuildContext context, TarotCategory category) async {
    final cards = await getCards(context);
    return cards.where((card) => card.category == category).toList();
  }

  @override
  void clearCache() {
    _cachedCards = null;
    _cachedLocale = null;
  }

  // Private helper methods
  Future<List<TarotData>> _loadCardsWithTranslations(String locale) async {
    final baseCards = await _loadCardStructures();
    final translations = await _loadLocaleTranslations(locale);
    final translationMap = _indexTranslationsById(translations);

    return _buildTranslatedCards(baseCards, translationMap);
  }

  Future<List<dynamic>> _loadCardStructures() async {
    final jsonString = await rootBundle.loadString(_baseCardsPath);
    return json.decode(jsonString) as List;
  }

  Future<List<dynamic>> _loadLocaleTranslations(String locale) async {
    final fileName = _resolveTranslationFileName(locale);
    final jsonString = await rootBundle.loadString('$_translationsPath/$fileName');
    return json.decode(jsonString) as List;
  }

  Map<String, Map<String, dynamic>> _indexTranslationsById(List<dynamic> translations) {
    return {
      for (final translation in translations)
        (translation as Map<String, dynamic>)['id'] as String: translation,
    };
  }

  List<TarotData> _buildTranslatedCards(
    List<dynamic> baseCards,
    Map<String, Map<String, dynamic>> translationMap,
  ) {
    return baseCards
        .cast<Map<String, dynamic>>()
        .map((base) => _createCardWithTranslation(base, translationMap))
        .whereType<TarotData>()
        .toList();
  }

  TarotData? _createCardWithTranslation(
    Map<String, dynamic> base,
    Map<String, Map<String, dynamic>> translationMap,
  ) {
    final id = base['id'] as String;
    final translation = translationMap[id];

    if (translation == null) return null;

    return TarotData(
      title: translation['title'] as String,
      description: translation['description'] as String,
      imagePath: base['imagePath'] as String,
      category: TarotCategory.fromString(base['category'] as String),
      meanings: List<String>.from(translation['meanings'] as List),
      uprightMeanings: List<String>.from(
        translation['uprightMeanings'] as List,
      ),
      reversedMeanings: List<String>.from(
        translation['reversedMeanings'] as List,
      ),
      advices: List<String>.from(translation['advices'] as List),
      warnings: List<String>.from(translation['warnings'] as List),
    );
  }

  String _resolveTranslationFileName(String languageCode) {
    return switch (languageCode) {
      'tr' => 'tarot_cards_tr.json',
      'en' || _ => 'tarot_cards_en.json',
    };
  }

  bool _isLocaleCached(String currentLocale) {
    return _cachedCards != null && _cachedLocale == currentLocale;
  }

  void _cacheCardsForLocale(List<TarotData> cards, String locale) {
    _cachedCards = cards;
    _cachedLocale = locale;
  }
}
