import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/pages/tarot_reveal_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin RevealPageStateMixin on State<TarotRevealPage>, TickerProvider {
  late final ValueNotifier<int> selectedCardIndex;
  int lastHapticCardIndex = -1;
  late final ValueNotifier<TarotCardModel?> selectedTarotCard;
  late final FixedExtentScrollController wheelScrollController;
  late final AnimationController flipAnimController;
  late final AnimationController revealAnimController;

  @override
  void initState() {
    super.initState();

    const initialCardIndex = CardSp.totalCards ~/ 2;
    selectedCardIndex = ValueNotifier(initialCardIndex);
    lastHapticCardIndex = initialCardIndex;
    selectedTarotCard = ValueNotifier(null);

    wheelScrollController = FixedExtentScrollController(initialItem: initialCardIndex);

    flipAnimController = AnimationController(
      vsync: this,
      duration: CardSp.flipAnimation,
    );

    revealAnimController = AnimationController(
      vsync: this,
      duration: CardSp.revealAnimation,
    )..addStatusListener((status) async {
      if (status.isCompleted) {
        await navigateToDetail();
      }
    });
  }

  @override
  void dispose() {
    selectedCardIndex.dispose();
    selectedTarotCard.dispose();
    wheelScrollController.dispose();
    flipAnimController.dispose();
    revealAnimController.dispose();
    super.dispose();
  }

  Future<void> handleCardScroll(int index) async {
    if (index != lastHapticCardIndex) {
      lastHapticCardIndex = index;
      await HapticFeedbackHelper.heavyImpact();
    }
    selectedCardIndex.value = index;
  }

  Future<void> handleCardTap(int index) async {
    selectedCardIndex.value = index;
    await flipAnimController.forward();
    if (mounted) {
      final tarotBloc = context.read<TarotBloc>();
      selectedTarotCard.value = tarotBloc.state.randomCard;
    }
    await revealAnimController.forward();
  }

  Future<void> navigateToDetail() async {
    await Future<void>.delayed(CardSp.flipCard);
    if (mounted && selectedTarotCard.value != null) {
      await context.pushNamed(
        AppRoutes.tarotRevealDetail,
        pathParameters: {'tarotId': selectedTarotCard.value!.id},
      );
    }
  }

  double getRevealCardWidth({required bool isSelected}) {
    return isSelected ? CardSp.selectedCardWidth : CardSp.unselectedCardWidth;
  }

  double getRevealCardHeight({required bool isSelected}) {
    return isSelected ? CardSp.selectedCardHeight : CardSp.unselectedCardHeight;
  }

  bool get isCardSelected => selectedTarotCard.value != null;

  set cardSelected(bool value) {
    if (!value) {
      selectedTarotCard.value = null;
    }
  }
}
