import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
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
  late final ValueNotifier<Duration> remaining;
  Timer? cooldownTimer;

  @override
  void initState() {
    super.initState();

    const initialCardIndex = CardSp.totalCards ~/ 2;
    selectedCardIndex = ValueNotifier(initialCardIndex);
    lastHapticCardIndex = initialCardIndex;
    selectedTarotCard = ValueNotifier(null);
    remaining = ValueNotifier(Duration.zero);

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
    remaining.dispose();
    cooldownTimer?.cancel();
    wheelScrollController.dispose();
    flipAnimController.dispose();
    revealAnimController.dispose();
    super.dispose();
  }

  DateTime? getLastSavedAt(TarotState state) {
    final cards = state.dailyCardsOrEmpty.asList();
    if (cards.isEmpty) return null;
    return cards.first.savedAt;
  }

  bool isOnCooldown(DateTime lastSavedAt) =>
      DateTime.now().isBefore(lastSavedAt.add(const Duration(hours: 24)));

  Duration getRemainingDuration(DateTime lastSavedAt) {
    final diff = lastSavedAt.add(const Duration(hours: 24)).difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  void startCooldown(Duration duration) {
    cooldownTimer?.cancel();
    remaining.value = duration;
    cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = remaining.value - const Duration(seconds: 1);
      if (next.isNegative) {
        remaining.value = Duration.zero;
        cooldownTimer?.cancel();
      } else {
        remaining.value = next;
      }
    });
  }

  String formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
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

  double getRevealCardWidth({required bool isSelected}) =>
      isSelected ? CardSp.selectedCardWidth : CardSp.unselectedCardWidth;

  double getRevealCardHeight({required bool isSelected}) =>
      isSelected ? CardSp.selectedCardHeight : CardSp.unselectedCardHeight;

  bool get isCardSelected => selectedTarotCard.value != null;

  set cardSelected(bool value) {
    if (!value) selectedTarotCard.value = null;
  }
}
