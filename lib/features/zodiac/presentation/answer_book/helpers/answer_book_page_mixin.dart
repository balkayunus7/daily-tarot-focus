import 'dart:async';
import 'dart:math';

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/answer_book/pages/answer_book_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin AnswerBookPageMixin on State<AnswerBookPage>, TickerProvider {
  static const List<String> _answerKeys = [
    LocaleKeys.answer_book_answer_1,
    LocaleKeys.answer_book_answer_2,
    LocaleKeys.answer_book_answer_3,
    LocaleKeys.answer_book_answer_4,
    LocaleKeys.answer_book_answer_5,
    LocaleKeys.answer_book_answer_6,
    LocaleKeys.answer_book_answer_7,
    LocaleKeys.answer_book_answer_8,
    LocaleKeys.answer_book_answer_9,
    LocaleKeys.answer_book_answer_10,
    LocaleKeys.answer_book_answer_11,
    LocaleKeys.answer_book_answer_12,
    LocaleKeys.answer_book_answer_13,
    LocaleKeys.answer_book_answer_14,
    LocaleKeys.answer_book_answer_15,
    LocaleKeys.answer_book_answer_16,
    LocaleKeys.answer_book_answer_17,
    LocaleKeys.answer_book_answer_18,
    LocaleKeys.answer_book_answer_19,
    LocaleKeys.answer_book_answer_20,
    LocaleKeys.answer_book_answer_21,
    LocaleKeys.answer_book_answer_22,
    LocaleKeys.answer_book_answer_23,
    LocaleKeys.answer_book_answer_24,
    LocaleKeys.answer_book_answer_25,
    LocaleKeys.answer_book_answer_26,
    LocaleKeys.answer_book_answer_27,
    LocaleKeys.answer_book_answer_28,
    LocaleKeys.answer_book_answer_29,
    LocaleKeys.answer_book_answer_30,
    LocaleKeys.answer_book_answer_31,
    LocaleKeys.answer_book_answer_32,
    LocaleKeys.answer_book_answer_33,
    LocaleKeys.answer_book_answer_34,
    LocaleKeys.answer_book_answer_35,
    LocaleKeys.answer_book_answer_36,
    LocaleKeys.answer_book_answer_37,
    LocaleKeys.answer_book_answer_38,
    LocaleKeys.answer_book_answer_39,
    LocaleKeys.answer_book_answer_40,
  ];

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
    currentIndex = ValueNotifier(Random().nextInt(_answerKeys.length));

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
    currentIndex.value = Random().nextInt(_answerKeys.length);
    cycleTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      if (mounted) {
        currentIndex.value = Random().nextInt(_answerKeys.length);
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

  String get currentAnswer => _answerKeys[currentIndex.value].tr();

  double get blur => 0.5 + sin(flipController.value * pi * 2).abs() * 0.5;
}
