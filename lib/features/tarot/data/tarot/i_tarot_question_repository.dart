import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reader_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_spread_category_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

abstract class ITarotQuestionRepository {
  Future<FailureOr<KtList<TarotSpreadCategoryModel>>> getSpreadCategories();
  Future<FailureOr<KtList<TarotReaderModel>>> getReaders();
}
