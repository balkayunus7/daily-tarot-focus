import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reader_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_spread_category_model.dart';

sealed class TarotQuestionEvent {
  const TarotQuestionEvent();
  List<Object?> get props => [];
}

final class TarotQuestionInitRequested extends TarotQuestionEvent {
  const TarotQuestionInitRequested();
}

final class TarotQuestionCategorySelected extends TarotQuestionEvent {
  const TarotQuestionCategorySelected({required this.category});
  final TarotSpreadCategoryModel category;

  @override
  List<Object?> get props => [category];
}

final class TarotQuestionSpreadSelected extends TarotQuestionEvent {
  const TarotQuestionSpreadSelected({required this.spread});
  final TarotSpreadModel spread;

  @override
  List<Object?> get props => [spread];
}

final class TarotQuestionReaderSelected extends TarotQuestionEvent {
  const TarotQuestionReaderSelected({required this.reader});
  final TarotReaderModel reader;

  @override
  List<Object?> get props => [reader];
}
