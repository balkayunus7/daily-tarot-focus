import 'package:daily_tarot_focus/features/tarot/domain/models/reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_category_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/extensions.dart';

class TarotState extends Equatable {
  const TarotState({
    required this.fetchFailureOrDailyCards,
    required this.recordDailyCardFailureOrUnit,
    required this.readingFailureOrResponse,
    required this.fetchAllCardsFailureOrCards,
    required this.isFetchingAllCards,
    required this.isFetchingDailyCards,
    required this.isRecordDailyCard,
    required this.isReading,
  });

  factory TarotState.initial() {
    return TarotState(
      fetchFailureOrDailyCards: none(),
      recordDailyCardFailureOrUnit: none(),
      readingFailureOrResponse: none(),
      fetchAllCardsFailureOrCards: none(),
      isFetchingDailyCards: false,
      isRecordDailyCard: false,
      isReading: false,
      isFetchingAllCards: false,
    );
  }

  final Option<FailureOr<KtList<TarotCardModel>>> fetchFailureOrDailyCards;
  final Option<FailureOr<Unit>> recordDailyCardFailureOrUnit;
  final Option<FailureOr<ReadingResponse>> readingFailureOrResponse;
  final Option<FailureOr<KtList<TarotCardModel>>> fetchAllCardsFailureOrCards;
  final bool isFetchingDailyCards;
  final bool isRecordDailyCard;
  final bool isReading;
  final bool isFetchingAllCards;

  // ALL CARDS GETTERS
  KtList<TarotCardModel> get allCardsOrEmpty =>
      fetchAllCardsFailureOrCards.getOrNull()?.getRightOrNull() ?? const KtList.empty();

  bool get hasAllCards => allCardsOrEmpty.isNotEmpty();

  bool get hasFetchAllCardsFailed =>
      fetchAllCardsFailureOrCards.getOrNull()?.getLeftOrNull() != null;

  bool get hasFetchAllCardsSucceeded =>
      fetchAllCardsFailureOrCards.getOrNull()?.getRightOrNull() != null;

  TarotCardModel? getById(String id) =>
      allCardsOrEmpty.asList().where((c) => c.id == id).firstOrNull;

  TarotCardModel? getByTitle(String title) =>
      allCardsOrEmpty
          .asList()
          .where((c) => c.name.toLowerCase() == title.toLowerCase())
          .firstOrNull;

  TarotCardModel? get randomCard {
    if (allCardsOrEmpty.isEmpty()) return null;
    final shuffled = List<TarotCardModel>.from(allCardsOrEmpty.asList())..shuffle();
    return shuffled.first;
  }

  List<TarotCardModel> randomCards(int count) {
    if (allCardsOrEmpty.isEmpty()) return [];
    final shuffled = List<TarotCardModel>.from(allCardsOrEmpty.asList())..shuffle();
    return shuffled.take(count).toList();
  }

  List<TarotCardModel> byCategory(TarotCategory? category) {
    if (category == null) return allCardsOrEmpty.asList();
    return allCardsOrEmpty.asList().where((c) => c.category == category).toList();
  }

  // RECORD DAILY CARD
  bool get hasRecordDailyCardSucceeded =>
      recordDailyCardFailureOrUnit.getOrNull()?.getRightOrNull() != null;

  bool get hasRecordDailyCardFailed =>
      recordDailyCardFailureOrUnit.getOrNull()?.getLeftOrNull() != null;

  bool get hasRecordDailyCard => recordDailyCardFailureOrUnit.getOrNull()?.getRightOrNull() != null;

  // FETCH DAILY CARDS
  bool get hasFetchedDailyCardsSucceeded =>
      fetchFailureOrDailyCards.getOrNull()?.getRightOrNull() != null;

  bool get hasFetchedDailyCardsFailed =>
      fetchFailureOrDailyCards.getOrNull()?.getLeftOrNull() != null;

  KtList<TarotCardModel> get dailyCardsOrEmpty =>
      fetchFailureOrDailyCards.getOrNull()?.getRightOrNull() ?? const KtList.empty();

  // READING
  bool get hasReadingSucceeded => readingFailureOrResponse.getOrNull()?.isRight() != null;

  bool get hasReadingFailed => readingFailureOrResponse.getOrNull()?.getLeftOrNull() != null;

  ReadingResponse? get readingResponseOrNull =>
      readingFailureOrResponse.getOrNull()?.getRightOrNull();

  TarotState copyWith({
    List<TarotCardModel>? allCards,
    bool? isLoadingCards,
    Option<FailureOr<KtList<TarotCardModel>>>? fetchFailureOrDailyCards,
    bool? isFetchingDailyCards,
    Option<FailureOr<Unit>>? recordDailyCardFailureOrUnit,
    bool? isRecordDailyCard,
    Option<FailureOr<ReadingResponse>>? readingFailureOrResponse,
    bool? isReading,
    Option<FailureOr<KtList<TarotCardModel>>>? fetchAllCardsFailureOrCards,
    bool? isFetchingAllCards,
  }) {
    return TarotState(
      fetchFailureOrDailyCards: fetchFailureOrDailyCards ?? this.fetchFailureOrDailyCards,
      isFetchingDailyCards: isFetchingDailyCards ?? this.isFetchingDailyCards,
      recordDailyCardFailureOrUnit:
          recordDailyCardFailureOrUnit ?? this.recordDailyCardFailureOrUnit,
      isRecordDailyCard: isRecordDailyCard ?? this.isRecordDailyCard,
      readingFailureOrResponse: readingFailureOrResponse ?? this.readingFailureOrResponse,
      isReading: isReading ?? this.isReading,
      fetchAllCardsFailureOrCards: fetchAllCardsFailureOrCards ?? this.fetchAllCardsFailureOrCards,
      isFetchingAllCards: isFetchingAllCards ?? this.isFetchingAllCards,
    );
  }

  @override
  List<Object?> get props => [
    fetchFailureOrDailyCards,
    isFetchingDailyCards,
    recordDailyCardFailureOrUnit,
    isRecordDailyCard,
    readingFailureOrResponse,
    isReading,
    fetchAllCardsFailureOrCards,
    isFetchingAllCards,
  ];
}
