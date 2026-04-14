import 'package:daily_tarot_focus/features/tarot/bloc/tarot_spread/tarot_spread_state.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/tarot_spread_repository.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotSpreadCubit extends Cubit<TarotSpreadState> {
  TarotSpreadCubit(this._repository) : super(TarotSpreadState.initial());

  final TarotSpreadRepository _repository;

  Future<void> loadSpreads() async {
    emit(state.copyWith(status: TarotSpreadStatus.loading));
    try {
      final categories = await _repository.getSpreadCategories();
      emit(
        state.copyWith(
          status: TarotSpreadStatus.success,
          categories: categories,
        ),
      );
    } on Exception catch (_) {
      emit(
        state.copyWith(
          status: TarotSpreadStatus.error,
          errorMessage: 'Failed to load tarot spreads',
        ),
      );
    }
  }
}
