import 'dart:async';
import 'dart:math';

import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/answer_book/pages/answer_book_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin AnswerBookPageMixin on State<AnswerBookPage>, TickerProvider {
  late final AnimationController flipController;
  late final AnimationController settleController;
  late final AnimationController revealController;
  late final ValueNotifier<bool> isAnswerShown;
  late final ValueNotifier<bool> hasCompletedFlipCycle;
  late final ValueNotifier<int> currentIndex;
  Timer? cycleTimer;
  bool _isRevealInProgress = false;
  double _previousFlipValue = 0;

  @override
  void initState() {
    super.initState();
    isAnswerShown = ValueNotifier(false);
    hasCompletedFlipCycle = ValueNotifier(false);
    currentIndex = ValueNotifier(
      Random().nextInt(TarotMockData.answersEn.length),
    );

    flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    flipController.addListener(_onFlipTick);
    unawaited(flipController.repeat());

    settleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    unawaited(startCycling());
  }

  Future<void> startCycling() async {
    cycleTimer?.cancel();
    isAnswerShown.value = false;
    _isRevealInProgress = false;
    await revealController.reverse();
    await settleController.reverse();
    if (!mounted) return;
    if (!flipController.isAnimating) {
      unawaited(flipController.repeat());
    }
    currentIndex.value = Random().nextInt(answers.length);
    cycleTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      if (mounted) {
        currentIndex.value = Random().nextInt(answers.length);
      }
    });
  }

  Future<void> revealAnswer() async {
    if (isAnswerShown.value || _isRevealInProgress) return;
    _isRevealInProgress = true;
    cycleTimer?.cancel();
    flipController.stop();
    isAnswerShown.value = true;
    await revealController.forward();
    _isRevealInProgress = false;
  }

  @override
  void dispose() {
    flipController.dispose();
    settleController.dispose();
    revealController.dispose();
    hasCompletedFlipCycle.dispose();
    cycleTimer?.cancel();
    super.dispose();
  }

  void _onFlipTick() {
    final value = flipController.value;
    if (!hasCompletedFlipCycle.value &&
        _previousFlipValue > 0.9 &&
        value < 0.1) {
      hasCompletedFlipCycle.value = true;
    }
    _previousFlipValue = value;
  }

  List<String> get answers {
    final locale = context.locale.languageCode;
    return locale == 'tr' ? TarotMockData.answersTr : TarotMockData.answersEn;
  }

  String get currentAnswer => answers[currentIndex.value];
  double get blur => 0.5 + sin(flipController.value * pi * 2).abs() * 0.5;
}
