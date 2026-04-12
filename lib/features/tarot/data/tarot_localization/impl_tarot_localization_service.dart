import 'dart:convert';

import 'package:daily_tarot_focus/features/tarot/data/tarot_localization/i_tarot_localization_service.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_category_enum.dart';
import 'package:flutter/services.dart';

class ImplTarotLocalizationService implements ITarotLocalizationService {
  static const _imageCardsPath = 'assets/data/tarot_cards.json';
  static const _tarotDataPath = 'assets/data/tarot_data.json';

  List<TarotCardModel>? _cachedCards;
  String? _cachedLocale;

  @override
  Future<List<TarotCardModel>> getCards(String languageCode) async {
    if (_isLocaleCached(languageCode)) return _cachedCards!;

    final cards = await _loadCards();
    _cacheCardsForLocale(cards, languageCode);

    return cards;
  }

  @override
  Future<TarotCardModel> drawRandomCard(String languageCode) async {
    final cards = await getCards(languageCode);
    cards.shuffle();
    return cards.first;
  }

  @override
  Future<TarotCardModel?> findCardByTitle(String languageCode, String title) async {
    final cards = await getCards(languageCode);
    final normalizedTitle = title.toLowerCase();

    return cards.where((card) => card.name.toLowerCase() == normalizedTitle).firstOrNull;
  }

  @override
  Future<List<TarotCardModel>> getCardsByCategory(
    String languageCode,
    TarotCategory category,
  ) async {
    final cards = await getCards(languageCode);
    return cards.where((card) => card.category == category).toList();
  }

  @override
  void clearCache() {
    _cachedCards = null;
    _cachedLocale = null;
  }

  @override
  Future<TarotCardModel?> findCardById(String languageCode, String id) async {
    final cards = await getCards(languageCode);
    return cards.where((card) => card.id == id).firstOrNull;
  }

  // Private helper methods

  /// Loads all cards by combining tarot_data.json (content) with tarot_cards.json (image paths).
  Future<List<TarotCardModel>> _loadCards() async {
    final tarotData = await _loadTarotData();
    final imageMap = await _loadImagePathMap();

    return tarotData
        .cast<Map<String, dynamic>>()
        .map((data) => _createCard(data, imageMap))
        .toList();
  }

  Future<List<dynamic>> _loadTarotData() async {
    final jsonString = await rootBundle.loadString(_tarotDataPath);
    return json.decode(jsonString) as List;
  }

  /// Loads tarot_cards.json and returns a map of id → imagePath.
  Future<Map<String, String>> _loadImagePathMap() async {
    final jsonString = await rootBundle.loadString(_imageCardsPath);
    final cards = json.decode(jsonString) as List;
    return {
      for (final card in cards)
        (card as Map<String, dynamic>)['id'] as String:
            card['imagePath'] as String,
    };
  }

  TarotCardModel _createCard(
    Map<String, dynamic> data,
    Map<String, String> imageMap,
  ) {
    final id = data['id'] as String;
    final imagePath = imageMap[id] ?? 'assets/jpg/${id.replaceAll('-', '_')}.jpg';

    return TarotCardModel(
      id: id,
      name: data['name'] as String? ?? '',
      imagePath: imagePath,
      category: TarotCategory.fromString(data['category'] as String? ?? ''),
      description: data['description'] as String? ?? '',
      correspondences: CorrespondencesModel.fromMap(
        data['correspondences'] as Map<String, dynamic>? ?? {},
      ),
      symbols: (data['symbols'] as List<dynamic>?)
              ?.map((s) => SymbolModel.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
      uprightKeywords: (data['upright_keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      reversedKeywords: (data['reversed_keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      upright: ReadingMeaningsModel.fromMap(
        data['upright'] as Map<String, dynamic>? ?? {},
      ),
      reversed: ReadingMeaningsModel.fromMap(
        data['reversed'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  bool _isLocaleCached(String currentLocale) {
    return _cachedCards != null && _cachedLocale == currentLocale;
  }

  void _cacheCardsForLocale(List<TarotCardModel> cards, String locale) {
    _cachedCards = cards;
    _cachedLocale = locale;
  }
}
