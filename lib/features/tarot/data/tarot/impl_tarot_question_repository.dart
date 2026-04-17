import 'dart:convert';
import 'package:daily_tarot_focus/features/tarot/data/tarot/i_tarot_question_repository.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reader_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_spread_category_model.dart';
import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

class ImplTarotQuestionRepository extends ITarotQuestionRepository {
  @override
  Future<FailureOr<KtList<TarotSpreadCategoryModel>>> getSpreadCategories() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/tarot_spread.json');
      final jsonList = jsonDecode(jsonString) as List;
      final categories = KtList.from(
        jsonList.map((e) => TarotSpreadCategoryModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
      return right(categories);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<KtList<TarotReaderModel>>> getReaders() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/tarot_reader.json');
      final jsonList = jsonDecode(jsonString) as List;
      final readers = KtList.from(
        jsonList.map((e) => TarotReaderModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
      return right(readers);
    } on Exception {
      return left(const UnknownFailure());
    }
  }
}
