import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reader_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_spread_category_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/extensions.dart';

class TarotQuestionState extends Equatable {
  const TarotQuestionState({
    required this.fetchFailureOrCategories,
    required this.fetchFailureOrReaders,
    required this.selectedCategory,
    required this.selectedSpread,
    required this.selectedReader,
  });

  factory TarotQuestionState.initial() {
    return TarotQuestionState(
      fetchFailureOrCategories: none(),
      fetchFailureOrReaders: none(),
      selectedCategory: null,
      selectedSpread: null,
      selectedReader: null,
    );
  }

  final Option<FailureOr<KtList<TarotSpreadCategoryModel>>> fetchFailureOrCategories;
  final Option<FailureOr<KtList<TarotReaderModel>>> fetchFailureOrReaders;
  final TarotSpreadCategoryModel? selectedCategory;
  final TarotSpreadModel? selectedSpread;
  final TarotReaderModel? selectedReader;

  TarotQuestionState copyWith({
    Option<FailureOr<KtList<TarotSpreadCategoryModel>>>? fetchFailureOrCategories,
    Option<FailureOr<KtList<TarotReaderModel>>>? fetchFailureOrReaders,
    TarotSpreadCategoryModel? selectedCategory,
    TarotSpreadModel? selectedSpread,
    TarotReaderModel? selectedReader,
  }) {
    return TarotQuestionState(
      fetchFailureOrCategories: fetchFailureOrCategories ?? this.fetchFailureOrCategories,
      fetchFailureOrReaders: fetchFailureOrReaders ?? this.fetchFailureOrReaders,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSpread: selectedSpread ?? this.selectedSpread,
      selectedReader: selectedReader ?? this.selectedReader,
    );
  }

  // FETCH CATEGORIES
  bool get hasFetchedCategories {
    return fetchFailureOrCategories.getOrNull() != null;
  }

  bool get hasFetchedCategoriesSucceeded {
    return fetchFailureOrCategories.getOrNull()?.getRightOrNull() != null;
  }

  bool get hasFetchedCategoriesFailed {
    return fetchFailureOrCategories.getOrNull()?.getLeftOrNull() != null;
  }

  // FETCH READERS
  bool get hasFetchedReaders {
    return fetchFailureOrReaders.getOrNull() != null;
  }

  bool get hasFetchedReadersFailed {
    return fetchFailureOrReaders.getOrNull()?.getLeftOrNull() != null;
  }

  bool get hasFetchedReadersSucceeded {
    return fetchFailureOrReaders.getOrNull()?.getRightOrNull() != null;
  }

  KtList<TarotSpreadCategoryModel> get categoriesOrCrash {
    return fetchFailureOrCategories.getOrNull()!.getRightOrCrash();
  }

  KtList<TarotReaderModel> get readersOrCrash {
    return fetchFailureOrReaders.getOrNull()!.getRightOrCrash();
  }

  @override
  List<Object?> get props => [
    fetchFailureOrCategories,
    fetchFailureOrReaders,
    selectedCategory,
    selectedSpread,
    selectedReader,
  ];
}
