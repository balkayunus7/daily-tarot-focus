import 'package:daily_tarot_focus/features/tarot/bloc/tarot_question/tarot_question_event.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_question/tarot_question_state.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/i_tarot_question_repository.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reader_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_spread_category_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotQuestionBloc extends Bloc<TarotQuestionEvent, TarotQuestionState> {
  TarotQuestionBloc(this._repository) : super(TarotQuestionState.initial()) {
    on<TarotQuestionEvent>((event, emit) async {
      if (event is TarotQuestionInitRequested) {
        await _onInitRequested(event, emit);
      } else if (event is TarotQuestionCategorySelected) {
        _onCategorySelected(event, emit);
      } else if (event is TarotQuestionSpreadSelected) {
        _onSpreadSelected(event, emit);
      } else if (event is TarotQuestionReaderSelected) {
        _onReaderSelected(event, emit);
      }
    }, transformer: sequential());
  }

  void addInitRequested() {
    add(const TarotQuestionInitRequested());
  }

  void addCategorySelected(TarotSpreadCategoryModel category) {
    add(TarotQuestionCategorySelected(category: category));
  }

  void addSpreadSelected(TarotSpreadModel spread) {
    add(TarotQuestionSpreadSelected(spread: spread));
  }

  void addReaderSelected(TarotReaderModel reader) {
    add(TarotQuestionReaderSelected(reader: reader));
  }

  Future<void> _onInitRequested(
    TarotQuestionInitRequested event,
    Emitter<TarotQuestionState> emit,
  ) async {
    emit(
      state.copyWith(
        fetchFailureOrCategories: none(),
        fetchFailureOrReaders: none(),
      ),
    );

    final failOrCategories = await _repository.getSpreadCategories();
    final failOrReaders = await _repository.getReaders();

    final categoriesState = await failOrCategories.fold(
      (failure) async => state.copyWith(
        fetchFailureOrCategories: some(left(failure)),
      ),
      (categories) async {
        return state.copyWith(
          fetchFailureOrCategories: some(right(categories)),
        );
      },
    );

    final readerState = await failOrReaders.fold(
      (failure) async => state.copyWith(
        fetchFailureOrReaders: some(left(failure)),
      ),
      (readers) async {
        return state.copyWith(
          fetchFailureOrReaders: some(right(readers)),
        );
      },
    );

    emit(
      state.copyWith(
        fetchFailureOrCategories: categoriesState.fetchFailureOrCategories,
        fetchFailureOrReaders: readerState.fetchFailureOrReaders,
      ),
    );
  }

  void _onCategorySelected(
    TarotQuestionCategorySelected event,
    Emitter<TarotQuestionState> emit,
  ) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onSpreadSelected(
    TarotQuestionSpreadSelected event,
    Emitter<TarotQuestionState> emit,
  ) {
    emit(state.copyWith(selectedSpread: event.spread));
  }

  void _onReaderSelected(
    TarotQuestionReaderSelected event,
    Emitter<TarotQuestionState> emit,
  ) {
    emit(state.copyWith(selectedReader: event.reader));
  }

  final ITarotQuestionRepository _repository;
}
