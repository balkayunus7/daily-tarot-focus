import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_spread_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

enum TarotSpreadStatus {
  initial,
  loading,
  success,
  error,
}

class TarotSpreadState extends Equatable {
  const TarotSpreadState({
    required this.status,
    required this.categories,
    this.errorMessage,
  });

  factory TarotSpreadState.initial() {
    return const TarotSpreadState(
      status: TarotSpreadStatus.initial,
      categories: [],
    );
  }

  final TarotSpreadStatus status;
  final List<TarotSpreadCategoryModel> categories;
  final String? errorMessage;

  bool get isLoading => status == TarotSpreadStatus.loading;
  bool get isSuccess => status == TarotSpreadStatus.success;
  bool get isError => status == TarotSpreadStatus.error;

  TarotSpreadState copyWith({
    TarotSpreadStatus? status,
    List<TarotSpreadCategoryModel>? categories,
    String? errorMessage,
  }) {
    return TarotSpreadState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, categories, errorMessage];
}
