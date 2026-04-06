import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_reading_response.dart';
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

  final Option<FailureOr<KtList<TarotCard>>> fetchFailureOrDailyCards;
  final Option<FailureOr<Unit>> saveDailyCardFailureOrUnit;
  final Option<FailureOr<TarotReadingResponse>> askQuestionFailureOrResponse;
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

  KtList<TarotCard>? get _dailyCardsOrNull {
    return fetchFailureOrDailyCards.getOrNull()?.getRightOrNull();
  }

  KtList<TarotCard> get dailyCardsOrEmpty {
    return _dailyCardsOrNull ?? const KtList<TarotCard>.empty();
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

  TarotReadingResponse? get askedQuestionResponseOrNull {
    return askQuestionFailureOrResponse.getOrNull()?.getRightOrNull();
  }

  TarotState copyWith({
    Option<FailureOr<KtList<TarotCard>>>? fetchFailureOrDailyCards,
    bool? isFetchingDailyCards,
    Option<FailureOr<Unit>>? saveDailyCardFailureOrUnit,
    bool? isSavingDailyCard,
    Option<FailureOr<TarotReadingResponse>>? askQuestionFailureOrResponse,
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
