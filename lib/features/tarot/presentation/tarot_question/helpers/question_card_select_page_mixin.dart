import 'dart:math' as math;

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/pages/tarot_question_card_select_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin QuestionCardSelectPageStateMixin on State<TarotQuestionCardSelectPage> {
  final math.Random random = math.Random();
  List<QuestionDeckCardItem> deckCards = const [];
  final List<int> selectedDeckIndices = [];

  TarotQuestionData? _tarotQuestionData;
  TarotQuestionData? get tarotQuestionData => _tarotQuestionData;

  int get requiredCardCount => widget.draftData.cardCount;
  int get selectedCardCount => selectedDeckIndices.length;
  bool get hasEnoughSelection => selectedCardCount == requiredCardCount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (deckCards.isEmpty) {
      prepareDeckCards();
    }
  }

  void prepareDeckCards() {
    final lclCubit = context.read<TarotLocalizationCubit>();
    final allCards = List<TarotCardModel>.from(lclCubit.state.allCards)..shuffle();
    final selectedCount = allCards.length < 9 ? allCards.length : 9;

    setState(() {
      selectedDeckIndices.clear();
      deckCards =
          allCards.take(selectedCount).map((card) => QuestionDeckCardItem(card: card)).toList();
    });
  }

  void onDeckCardTap(int index) {
    if (index < 0 || index >= deckCards.length) return;

    final tappedCard = deckCards[index];
    if (tappedCard.isSelected || selectedDeckIndices.length >= requiredCardCount) {
      return;
    }

    setState(() {
      tappedCard
        ..isSelected = true
        ..isFlipped = true
        ..isReversed = random.nextBool();
      selectedDeckIndices.add(index);
    });
  }

  void submitQuestion() {
    final tarotBloc = context.read<TarotBloc>();
    final authState = context.read<AuthCubit>().state;
    final session = authState.sessionOrCrash;

    _tarotQuestionData = TarotQuestionData(
      user: authState.userOrCrash as TarotUser,
      topic: widget.draftData.topic,
      question: widget.draftData.question,
      drawnCards: selectedDeckIndices.map((index) => deckCards[index].card).toList(),
      drawnCardReversedStates:
          selectedDeckIndices.map((index) => deckCards[index].isReversed).toList(),
      language: context.locale.languageCode,
    );

    tarotBloc.addReadingRequested(
      request: ReadingRequest(session: session, data: _tarotQuestionData!),
    );

    context.replace(AppRoutes.tarotReading, extra: tarotQuestionData);
  }
}

class QuestionDeckCardItem {
  QuestionDeckCardItem({required this.card});

  final TarotCardModel card;
  bool isSelected = false;
  bool isFlipped = false;
  bool isReversed = false;
}
