part of 'tarot_card_cubit.dart';

/// Status of tarot card loading
enum TarotCardStatus {
  initial,
  loading,
  loaded,
  error,
}

/// State for TarotCardCubit
class TarotCardState extends Equatable {
  const TarotCardState({
    required this.status,
    required this.allCards,
    required this.filteredCards,
    this.selectedCategory,
    this.selectedCard,
    this.errorMessage,
  });

  factory TarotCardState.initial() {
    return const TarotCardState(
      status: TarotCardStatus.initial,
      allCards: [],
      filteredCards: [],
    );
  }

  final TarotCardStatus status;
  final List<TarotData> allCards;
  final List<TarotData> filteredCards;
  final TarotCategory? selectedCategory;
  final TarotData? selectedCard;
  final String? errorMessage;

  bool get isLoading => status == TarotCardStatus.loading;
  bool get isLoaded => status == TarotCardStatus.loaded;
  bool get hasError => status == TarotCardStatus.error;
  bool get hasCards => allCards.isNotEmpty;

  TarotCardState copyWith({
    TarotCardStatus? status,
    List<TarotData>? allCards,
    List<TarotData>? filteredCards,
    TarotCategory? selectedCategory,
    TarotData? selectedCard,
    String? errorMessage,
  }) {
    return TarotCardState(
      status: status ?? this.status,
      allCards: allCards ?? this.allCards,
      filteredCards: filteredCards ?? this.filteredCards,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCard: selectedCard ?? this.selectedCard,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Special copyWith to set selectedCard to null
  TarotCardState copyWithNullSelectedCard() {
    return TarotCardState(
      status: status,
      allCards: allCards,
      filteredCards: filteredCards,
      selectedCategory: selectedCategory,
      errorMessage: errorMessage,
    );
  }

  /// Clear category filter and show all cards
  TarotCardState copyWithClearedCategory() {
    return TarotCardState(
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
