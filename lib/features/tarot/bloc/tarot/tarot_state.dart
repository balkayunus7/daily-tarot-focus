import 'package:daily_tarot_focus/features/tarot/domain/models/reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/extensions.dart';

class TarotState extends Equatable {
  const TarotState({
    required this.fetchFailureOrDailyCards,
    required this.recordDailyCardFailureOrUnit,
    required this.readingFailureOrResponse,
    required this.isFetchingDailyCards,
    required this.isSavingDailyCard,
    required this.isAskingQuestion,
  });

  factory TarotState.initial() {
    return TarotState(
      fetchFailureOrDailyCards: none(),
      recordDailyCardFailureOrUnit: none(),
      readingFailureOrResponse: none(),
      isFetchingDailyCards: false,
      isSavingDailyCard: false,
      isAskingQuestion: false,
    );
  }

  final Option<FailureOr<KtList<TarotCardModel>>> fetchFailureOrDailyCards;
  final Option<FailureOr<Unit>> recordDailyCardFailureOrUnit;
  final Option<FailureOr<ReadingResponse>> readingFailureOrResponse;
  final bool isFetchingDailyCards;
  final bool isSavingDailyCard;
  final bool isAskingQuestion;

  // RECORD DAILY CARD
  bool get hasRecordDailyCard {
    return recordDailyCardFailureOrUnit.getOrNull() != null;
  }

  bool get hasRecordDailyCardSucceeded {
    return recordDailyCardFailureOrUnit.getOrNull()?.isRight() != null;
  }

  bool get hasRecordDailyCardFailed {
    return recordDailyCardFailureOrUnit.getOrNull()?.getLeftOrNull() != null;
  }

  // FETCH DAILY CARDS
  bool get hasFetchedDailyCards {
    return fetchFailureOrDailyCards.getOrNull() != null;
  }

  bool get hasFetchedDailyCardsFailed {
    return fetchFailureOrDailyCards.getOrNull()?.getLeftOrNull() != null;
  }

  bool get hasFetchedDailyCardsSucceeded {
    return _dailyCardsOrNull != null;
  }

  KtList<TarotCardModel>? get _dailyCardsOrNull {
    return fetchFailureOrDailyCards.getOrNull()?.getRightOrNull();
  }

  KtList<TarotCardModel> get dailyCardsOrEmpty {
    return _dailyCardsOrNull ?? const KtList<TarotCardModel>.empty();
  }

  // ASK QUESTION
  bool get hasReadingQuestion {
    return readingFailureOrResponse.getOrNull() != null;
  }

  bool get hasReadingQuestionSucceeded {
    return readingFailureOrResponse.getOrNull()?.isRight() != null;
  }

  bool get hasReadingQuestionFailed {
    return readingFailureOrResponse.getOrNull()?.getLeftOrNull() != null;
  }

  ReadingResponse? get readingResponseOrNull {
    return readingFailureOrResponse.getOrNull()?.getRightOrNull();
  }

  TarotState copyWith({
    Option<FailureOr<KtList<TarotCardModel>>>? fetchFailureOrDailyCards,
    bool? isFetchingDailyCards,
    Option<FailureOr<Unit>>? saveDailyCardFailureOrUnit,
    bool? isSavingDailyCard,
    Option<FailureOr<ReadingResponse>>? askQuestionFailureOrResponse,
    bool? isAskingQuestion,
  }) {
    return TarotState(
      fetchFailureOrDailyCards: fetchFailureOrDailyCards ?? this.fetchFailureOrDailyCards,
      isFetchingDailyCards: isFetchingDailyCards ?? this.isFetchingDailyCards,
      recordDailyCardFailureOrUnit: saveDailyCardFailureOrUnit ?? recordDailyCardFailureOrUnit,
      isSavingDailyCard: isSavingDailyCard ?? this.isSavingDailyCard,
      readingFailureOrResponse: askQuestionFailureOrResponse ?? readingFailureOrResponse,
      isAskingQuestion: isAskingQuestion ?? this.isAskingQuestion,
    );
  }

  @override
  List<Object?> get props => [
    fetchFailureOrDailyCards,
    isFetchingDailyCards,
    recordDailyCardFailureOrUnit,
    isSavingDailyCard,
    readingFailureOrResponse,
    isAskingQuestion,
  ];
}
