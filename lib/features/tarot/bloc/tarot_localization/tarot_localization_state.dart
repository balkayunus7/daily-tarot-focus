part of 'tarot_localization_cubit.dart';

enum TarotCardStatus {
  initial,
  loading,
  loaded,
  error,
}

class TarotLocalizationState extends Equatable {
  const TarotLocalizationState({
    required this.status,
    required this.allCards,
    required this.filteredCards,
    this.selectedCategory,
    this.selectedCard,
    this.errorMessage,
  });

  factory TarotLocalizationState.initial() {
    return const TarotLocalizationState(
      status: TarotCardStatus.initial,
      allCards: [],
      filteredCards: [],
    );
  }

  final TarotCardStatus status;
  final List<TarotCardModel> allCards;
  final List<TarotCardModel> filteredCards;
  final TarotCategory? selectedCategory;
  final TarotCardModel? selectedCard;
  final String? errorMessage;

  bool get isLoading => status == TarotCardStatus.loading;
  bool get isLoaded => status == TarotCardStatus.loaded;
  bool get hasError => status == TarotCardStatus.error;
  bool get hasCards => allCards.isNotEmpty;

  TarotLocalizationState copyWith({
    TarotCardStatus? status,
    List<TarotCardModel>? allCards,
    List<TarotCardModel>? filteredCards,
    TarotCategory? selectedCategory,
    TarotCardModel? selectedCard,
    String? errorMessage,
  }) {
    return TarotLocalizationState(
      status: status ?? this.status,
      allCards: allCards ?? this.allCards,
      filteredCards: filteredCards ?? this.filteredCards,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCard: selectedCard ?? this.selectedCard,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  TarotLocalizationState copyWithNullSelectedCard() {
    return TarotLocalizationState(
      status: status,
      allCards: allCards,
      filteredCards: filteredCards,
      selectedCategory: selectedCategory,
      errorMessage: errorMessage,
    );
  }

  TarotLocalizationState copyWithClearedCategory() {
    return TarotLocalizationState(
      status: status,
      allCards: allCards,
      filteredCards: allCards,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allCards,
    filteredCards,
    selectedCategory,
    selectedCard,
    errorMessage,
  ];
}
