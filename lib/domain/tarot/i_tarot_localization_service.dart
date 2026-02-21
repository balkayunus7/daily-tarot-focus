import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';

abstract class ITarotLocalizationService {
  Future<List<TarotCard>> getCards(String languageCode);
  Future<TarotCard> drawRandomCard(String languageCode);
  Future<TarotCard?> findCardByTitle(String languageCode, String title);
  Future<TarotCard?> findCardById(String languageCode, String id);
  Future<List<TarotCard>> getCardsByCategory(String languageCode, TarotCategory category);
  void clearCache();
}
