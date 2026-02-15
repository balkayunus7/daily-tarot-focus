import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:flutter/widgets.dart';

abstract class ITarotLocalizationService {
  Future<List<TarotData>> getCards(BuildContext context);
  Future<TarotData> drawRandomCard(BuildContext context);
  Future<TarotData?> findCardByTitle(BuildContext context, String title);
  Future<List<TarotData>> getCardsByCategory(BuildContext context, TarotCategory category);
  void clearCache();
}
