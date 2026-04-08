import 'package:daily_tarot_focus/features/tarot/domain/models/reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/extensions.dart';

class TarotState extends Equatable {
  const TarotState({
    required this.fetchFailureOrDailyCards,
    required this.saveDailyCardFailureOrUnit,
    required this.askQuestionFailureOrResponse,
    required this.isFetchingDailyCards,
    required this.isSavingDailyCard,
    required this.isAskingQuestion,
  });

  factory TarotState.initial() {
    return TarotState(
      fetchFailureOrDailyCards: none(),
      saveDailyCardFailureOrUnit: none(),
      askQuestionFailureOrResponse: none(),
      isFetchingDailyCards: false,
      isSavingDailyCard: false,
      isAskingQuestion: false,
    );
  }

  final Option<FailureOr<KtList<TarotCardModel>>> fetchFailureOrDailyCards;
  final Option<FailureOr<Unit>> saveDailyCardFailureOrUnit;
  final Option<FailureOr<ReadingResponse>> askQuestionFailureOrResponse;
  final bool isFetchingDailyCards;
  final bool isSavingDailyCard;
  final bool isAskingQuestion;

  // SAVE DAILY CARD
  bool get hasSavedDailyCard {
    return saveDailyCardFailureOrUnit.getOrNull() != null;
  }

  bool get hasSavedDailyCardSucceeded {
    return saveDailyCardFailureOrUnit.getOrNull()?.isRight() != null;
  }

  bool get hasSavedDailyCardFailed {
    return saveDailyCardFailureOrUnit.getOrNull()?.getLeftOrNull() != null;
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
  bool get hasAskedQuestion {
    return askQuestionFailureOrResponse.getOrNull() != null;
  }

  bool get hasAskedQuestionSucceeded {
    return askQuestionFailureOrResponse.getOrNull()?.isRight() != null;
  }

  bool get hasAskedQuestionFailed {
    return askQuestionFailureOrResponse.getOrNull()?.getLeftOrNull() != null;
  }

  ReadingResponse? get askedQuestionResponseOrNull {
    return askQuestionFailureOrResponse.getOrNull()?.getRightOrNull();
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
      saveDailyCardFailureOrUnit: saveDailyCardFailureOrUnit ?? this.saveDailyCardFailureOrUnit,
      isSavingDailyCard: isSavingDailyCard ?? this.isSavingDailyCard,
      askQuestionFailureOrResponse:
          askQuestionFailureOrResponse ?? this.askQuestionFailureOrResponse,
      isAskingQuestion: isAskingQuestion ?? this.isAskingQuestion,
    );
  }

  @override
  List<Object?> get props => [
    fetchFailureOrDailyCards,
    isFetchingDailyCards,
    saveDailyCardFailureOrUnit,
    isSavingDailyCard,
    askQuestionFailureOrResponse,
    isAskingQuestion,
  ];
}
