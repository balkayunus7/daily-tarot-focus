import 'dart:async';

import 'package:daily_tarot_focus/application/tarot/tarot_card_cubit.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:daily_tarot_focus/presentation/tarot_reveal/pages/tarot_reveal_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin RevealPageStateMixin on State<TarotRevealPage>, TickerProvider {
  late final ValueNotifier<int> selectedCardIndex;
  int lastHapticCardIndex = -1;
  late final ValueNotifier<TarotData?> selectedTarotCard;
  late final FixedExtentScrollController wheelScrollController;
  late final AnimationController flipAnimController;
  late final AnimationController revealAnimController;

  @override
  void initState() {
    super.initState();

    const initialCardIndex = SpacingConsts.totalCards ~/ 2;
    selectedCardIndex = ValueNotifier(initialCardIndex);
    lastHapticCardIndex = initialCardIndex;
    selectedTarotCard = ValueNotifier(null);

    wheelScrollController = FixedExtentScrollController(initialItem: initialCardIndex);

    flipAnimController = AnimationController(
      vsync: this,
      duration: SpacingConsts.flipAnimationDuration,
    );

    revealAnimController = AnimationController(
      vsync: this,
      duration: SpacingConsts.revealAnimationDuration,
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
    // Get a random card from the Cubit
    if (mounted) {
      final tarotCardCubit = context.read<TarotCardCubit>();
      selectedTarotCard.value = tarotCardCubit.getRandomCard();
    }
    // Start reveal animation after card is selected
    await revealAnimController.forward();
  }

  Future<void> navigateToDetail() async {
    await Future<void>.delayed(SpacingConsts.flipCardDuration);
    if (mounted && selectedTarotCard.value != null) {
      await context.pushNamed(
        AppRoutes.tarotRevealDetail,
        pathParameters: {'tarotId': selectedTarotCard.value!.title},
      );
    }
  }

  double getRevealCardWidth({required bool isSelected}) {
    return isSelected
        ? SpacingConsts.wheelCardSelectedWidth
        : SpacingConsts.wheelCardUnselectedWidth;
  }

  double getRevealCardHeight({required bool isSelected}) {
    return isSelected
        ? SpacingConsts.wheelCardSelectedHeight
        : SpacingConsts.wheelCardUnselectedHeight;
  }

  bool get isCardSelected => selectedTarotCard.value != null;

  set cardSelected(bool value) {
    if (!value) {
      selectedTarotCard.value = null;
    }
  }
}
