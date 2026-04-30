import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_category_enum.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_flow_type.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reading_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/extensions.dart';

class TarotState extends Equatable {
  const TarotState({
    required this.fetchFailureOrDailyCards,
    required this.recordDailyCardFailureOrUnit,
    required this.fetchAllCardsFailureOrCards,
    required this.fetchSpreadsFailureOrSpreads,
    required this.fetchReadersFailureOrReaders,
    required this.isFetchingAllCards,
    required this.isFetchingDailyCards,
    required this.isRecordDailyCard,
    required this.isFetchingSpreads,
    required this.isFetchingReaders,
    required this.selectedSpreadCategory,
    required this.selectedSpread,
    required this.selectedReader,
    required this.selectedQuestion,
    required this.isSettingUpAccount,
    required this.hasAccountSetupCompleted,
    required this.selectedReadingCards,
    required this.isGeneratingReading,
    required this.fetchFailureOrGenerateReading,
    required this.clearCacheFailureOrUnit,
    required this.flowType,
  });

  factory TarotState.initial() {
    return TarotState(
      fetchFailureOrDailyCards: none(),
      recordDailyCardFailureOrUnit: none(),
      fetchAllCardsFailureOrCards: none(),
      fetchSpreadsFailureOrSpreads: none(),
      fetchReadersFailureOrReaders: none(),
      isFetchingDailyCards: false,
      isRecordDailyCard: false,
      isFetchingAllCards: false,
      isFetchingSpreads: false,
      isFetchingReaders: false,
      selectedSpreadCategory: null,
      selectedSpread: null,
      selectedReader: null,
      selectedQuestion: null,
      isSettingUpAccount: false,
      hasAccountSetupCompleted: false,
      selectedReadingCards: const [],
      isGeneratingReading: false,
      fetchFailureOrGenerateReading: none(),
      clearCacheFailureOrUnit: none(),
      flowType: TarotFlowType.threeCard,
    );
  }

  final Option<FailureOr<KtList<TarotCardModel>>> fetchFailureOrDailyCards;
  final Option<FailureOr<Unit>> recordDailyCardFailureOrUnit;
  final Option<FailureOr<KtList<TarotCardModel>>> fetchAllCardsFailureOrCards;
  final Option<FailureOr<KtList<TarotSpreadCategoryModel>>> fetchSpreadsFailureOrSpreads;
  final Option<FailureOr<KtList<TarotReaderModel>>> fetchReadersFailureOrReaders;
  final bool isFetchingDailyCards;
  final bool isRecordDailyCard;
  final bool isFetchingAllCards;
  final bool isFetchingSpreads;
  final bool isFetchingReaders;
  final bool isSettingUpAccount;
  final bool hasAccountSetupCompleted;
  final TarotSpreadCategoryModel? selectedSpreadCategory;
  final TarotSpreadModel? selectedSpread;
  final TarotReaderModel? selectedReader;
  final String? selectedQuestion;
  final List<TarotSelectedReadingCard> selectedReadingCards;
  final Option<FailureOr<GenerateReadingResponse>> fetchFailureOrGenerateReading;
  final bool isGeneratingReading;
  final Option<FailureOr<Unit>> clearCacheFailureOrUnit;
  final TarotFlowType flowType;

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

  // FETCH DAILY CARDS
  bool get hasFetchedDailyCardsSucceeded =>
      fetchFailureOrDailyCards.getOrNull()?.getRightOrNull() != null;

  bool get hasFetchedDailyCardsFailed =>
      fetchFailureOrDailyCards.getOrNull()?.getLeftOrNull() != null;

  KtList<TarotCardModel> get dailyCardsOrEmpty =>
      fetchFailureOrDailyCards.getOrNull()?.getRightOrNull() ?? const KtList.empty();

  // FETCH SPREADS
  bool get hasFetchedSpreadsSucceeded =>
      fetchSpreadsFailureOrSpreads.getOrNull()?.getRightOrNull() != null;

  bool get hasFetchedSpreadsFailed =>
      fetchSpreadsFailureOrSpreads.getOrNull()?.getLeftOrNull() != null;

  KtList<TarotSpreadCategoryModel> get spreadsOrEmpty =>
      fetchSpreadsFailureOrSpreads.getOrNull()?.getRightOrNull() ?? const KtList.empty();

  // FETCH READERS
  bool get hasFetchedReadersSucceeded =>
      fetchReadersFailureOrReaders.getOrNull()?.getRightOrNull() != null;

  bool get hasFetchedReadersFailed =>
      fetchReadersFailureOrReaders.getOrNull()?.getLeftOrNull() != null;

  KtList<TarotReaderModel> get readersOrEmpty =>
      fetchReadersFailureOrReaders.getOrNull()?.getRightOrNull() ?? const KtList.empty();

  // GENERATE READING
  bool get hasGeneratedReadingSucceeded =>
      fetchFailureOrGenerateReading.getOrNull()?.getRightOrNull() != null;

  bool get hasGeneratedReadingFailed =>
      fetchFailureOrGenerateReading.getOrNull()?.getLeftOrNull() != null;

  GenerateReadingResponse? get generateReadingResponseOrNull =>
      fetchFailureOrGenerateReading.getOrNull()?.getRightOrNull();

  // SELECTED
  bool get hasSelectedSpreadCategory => selectedSpreadCategory != null;
  bool get hasSelectedSpread => selectedSpread != null;
  bool get hasSelectedReader => selectedReader != null;
  bool get hasSelectedQuestion => selectedQuestion != null;
  bool get hasReadingCards => selectedReadingCards.isNotEmpty;

  TarotState copyWith({
    Option<FailureOr<KtList<TarotCardModel>>>? fetchFailureOrDailyCards,
    bool? isFetchingDailyCards,
    Option<FailureOr<Unit>>? recordDailyCardFailureOrUnit,
    bool? isRecordDailyCard,
    Option<FailureOr<KtList<TarotCardModel>>>? fetchAllCardsFailureOrCards,
    bool? isFetchingAllCards,
    Option<FailureOr<KtList<TarotSpreadCategoryModel>>>? fetchSpreadsFailureOrSpreads,
    bool? isFetchingSpreads,
    Option<FailureOr<KtList<TarotReaderModel>>>? fetchReadersFailureOrReaders,
    bool? isFetchingReaders,
    TarotSpreadCategoryModel? selectedSpreadCategory,
    TarotSpreadModel? selectedSpread,
    TarotReaderModel? selectedReader,
    String? selectedQuestion,
    bool? isSettingUpAccount,
    bool? hasAccountSetupCompleted,
    List<TarotSelectedReadingCard>? selectedReadingCards,
    bool? isGeneratingReading,
    Option<FailureOr<GenerateReadingResponse>>? fetchFailureOrGenerateReading,
    Option<FailureOr<Unit>>? clearCacheFailureOrUnit,
    TarotFlowType? flowType,
  }) {
    return TarotState(
      fetchFailureOrDailyCards: fetchFailureOrDailyCards ?? this.fetchFailureOrDailyCards,
      isFetchingDailyCards: isFetchingDailyCards ?? this.isFetchingDailyCards,
      recordDailyCardFailureOrUnit:
          recordDailyCardFailureOrUnit ?? this.recordDailyCardFailureOrUnit,
      isRecordDailyCard: isRecordDailyCard ?? this.isRecordDailyCard,
      fetchAllCardsFailureOrCards: fetchAllCardsFailureOrCards ?? this.fetchAllCardsFailureOrCards,
      isFetchingAllCards: isFetchingAllCards ?? this.isFetchingAllCards,
      fetchSpreadsFailureOrSpreads:
          fetchSpreadsFailureOrSpreads ?? this.fetchSpreadsFailureOrSpreads,
      isFetchingSpreads: isFetchingSpreads ?? this.isFetchingSpreads,
      fetchReadersFailureOrReaders:
          fetchReadersFailureOrReaders ?? this.fetchReadersFailureOrReaders,
      isFetchingReaders: isFetchingReaders ?? this.isFetchingReaders,
      selectedSpreadCategory: selectedSpreadCategory ?? this.selectedSpreadCategory,
      selectedSpread: selectedSpread ?? this.selectedSpread,
      selectedReader: selectedReader ?? this.selectedReader,
      selectedQuestion: selectedQuestion ?? this.selectedQuestion,
      isSettingUpAccount: isSettingUpAccount ?? this.isSettingUpAccount,
      hasAccountSetupCompleted: hasAccountSetupCompleted ?? this.hasAccountSetupCompleted,
      selectedReadingCards: selectedReadingCards ?? this.selectedReadingCards,
      isGeneratingReading: isGeneratingReading ?? this.isGeneratingReading,
      fetchFailureOrGenerateReading:
          fetchFailureOrGenerateReading ?? this.fetchFailureOrGenerateReading,
      clearCacheFailureOrUnit: clearCacheFailureOrUnit ?? this.clearCacheFailureOrUnit,
      flowType: flowType ?? this.flowType,
    );
  }

  @override
  List<Object?> get props => [
    fetchFailureOrDailyCards,
    isFetchingDailyCards,
    recordDailyCardFailureOrUnit,
    isRecordDailyCard,
    fetchAllCardsFailureOrCards,
    isFetchingAllCards,
    fetchSpreadsFailureOrSpreads,
    isFetchingSpreads,
    fetchReadersFailureOrReaders,
    isFetchingReaders,
    selectedSpreadCategory,
    selectedSpread,
    selectedReader,
    selectedQuestion,
    isSettingUpAccount,
    hasAccountSetupCompleted,
    selectedReadingCards,
    isGeneratingReading,
    fetchFailureOrGenerateReading,
    clearCacheFailureOrUnit,
    flowType,
  ];
}
