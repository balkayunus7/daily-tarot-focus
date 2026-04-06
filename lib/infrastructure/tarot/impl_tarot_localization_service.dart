import 'dart:convert';
import 'package:daily_tarot_focus/domain/tarot/i_tarot_localization_service.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:flutter/services.dart';

class ImplTarotLocalizationService implements ITarotLocalizationService {
  static const _baseCardsPath = 'assets/data/tarot_cards.json';
  static const _translationsPath = 'assets/data';

  List<TarotCard>? _cachedCards;
  String? _cachedLocale;

  @override
  Future<List<TarotCard>> getCards(String languageCode) async {
    if (_isLocaleCached(languageCode)) return _cachedCards!;

    final cards = await _loadCardsWithTranslations(languageCode);
    _cacheCardsForLocale(cards, languageCode);

    return cards;
  }

  @override
  Future<TarotCard> drawRandomCard(String languageCode) async {
    final cards = await getCards(languageCode);
    cards.shuffle();
    return cards.first;
  }

  @override
  Future<TarotCard?> findCardByTitle(String languageCode, String title) async {
    final cards = await getCards(languageCode);
    final normalizedTitle = title.toLowerCase();

    return cards.where((card) => card.title.toLowerCase() == normalizedTitle).firstOrNull;
  }

  @override
  Future<List<TarotCard>> getCardsByCategory(String languageCode, TarotCategory category) async {
    final cards = await getCards(languageCode);
    return cards.where((card) => card.category == category).toList();
  }

  @override
  void clearCache() {
    _cachedCards = null;
    _cachedLocale = null;
  }

  @override
  Future<TarotCard?> findCardById(String languageCode, String id) async {
    final cards = await getCards(languageCode);
    return cards.where((card) => card.id == id).firstOrNull;
  }

  // Private helper methods
  Future<List<TarotCard>> _loadCardsWithTranslations(String locale) async {
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

  List<TarotCard> _buildTranslatedCards(
    List<dynamic> baseCards,
    Map<String, Map<String, dynamic>> translationMap,
  ) {
    return baseCards
        .cast<Map<String, dynamic>>()
        .map((base) => _createCardWithTranslation(base, translationMap))
        .whereType<TarotCard>()
        .toList();
  }

  TarotCard? _createCardWithTranslation(
    Map<String, dynamic> base,
    Map<String, Map<String, dynamic>> translationMap,
  ) {
    final id = base['id'] as String;
    final translation = translationMap[id];

    if (translation == null) return null;

    return TarotCard(
      id: id,
      title: translation['title'] as String,
      motto: translation['motto'] as String? ?? '',
      imagePath: base['imagePath'] as String,
      category: TarotCategory.fromString(base['category'] as String),
      contextualMeanings: ContextualMeanings.fromMap(
        translation['contextual_meanings'] as Map<String, dynamic>? ?? {},
      ),
      advice: translation['advice'] as String? ?? '',
      affirmation: translation['affirmation'] as String? ?? '',
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

  void _cacheCardsForLocale(List<TarotCard> cards, String locale) {
    _cachedCards = cards;
    _cachedLocale = locale;
  }
}
