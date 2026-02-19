import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:flutter/widgets.dart';

abstract class ITarotLocalizationService {
  Future<List<TarotCard>> getCards(BuildContext context);
  Future<TarotCard> drawRandomCard(BuildContext context);
  Future<TarotCard?> findCardByTitle(BuildContext context, String title);
  Future<List<TarotCard>> getCardsByCategory(BuildContext context, TarotCategory category);
  void clearCache();
}
