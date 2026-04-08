import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_category_enum.dart';

abstract class ITarotLocalizationService {
  Future<List<TarotCardModel>> getCards(String languageCode);
  Future<TarotCardModel> drawRandomCard(String languageCode);
  Future<TarotCardModel?> findCardByTitle(String languageCode, String title);
  Future<TarotCardModel?> findCardById(String languageCode, String id);
  Future<List<TarotCardModel>> getCardsByCategory(String languageCode, TarotCategory category);
  void clearCache();
}
