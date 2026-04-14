import 'dart:convert';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_spread_model.dart';
import 'package:flutter/services.dart';

class TarotSpreadRepository {
  Future<List<TarotSpreadCategoryModel>> getSpreadCategories() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/tarot_spread.json');
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((e) => TarotSpreadCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Exception catch (_) {
      return [];
    }
  }
}
