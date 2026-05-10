import 'dart:async';
import 'dart:math';

import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/answer_book/pages/answer_book_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin AnswerBookPageMixin on State<AnswerBookPage>, TickerProvider {
  late final AnimationController flipController;
  late final AnimationController revealController;
  late final ValueNotifier<bool> isAnswerShown;
  late final ValueNotifier<int> currentIndex;
  Timer? cycleTimer;

  @override
  void initState() {
    super.initState();
    isAnswerShown = ValueNotifier(false);
    currentIndex = ValueNotifier(Random().nextInt(TarotMockData.answersEn.length));

    flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    unawaited(flipController.repeat());

    revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    unawaited(startCycling());
  }

  Future<void> startCycling() async {
    cycleTimer?.cancel();
    isAnswerShown.value = false;
    await revealController.reverse();
    if (!mounted) return;
    currentIndex.value = Random().nextInt(answers.length);
    cycleTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      if (mounted) {
        currentIndex.value = Random().nextInt(answers.length);
      }
    });
  }

  Future<void> revealAnswer() async {
    if (isAnswerShown.value) return;
    cycleTimer?.cancel();
    isAnswerShown.value = true;
    await revealController.forward();
  }

  @override
  void dispose() {
    flipController.dispose();
    revealController.dispose();
    cycleTimer?.cancel();
    super.dispose();
  }

  List<String> get answers {
    final locale = context.locale.languageCode;
    return locale == 'tr' ? TarotMockData.answersTr : TarotMockData.answersEn;
  }

  String get currentAnswer => answers[currentIndex.value];
  double get blur => 0.5 + sin(flipController.value * pi * 2).abs() * 0.5;
}
