import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/pages/tarot_spread_step5_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin Step5PageMixin on State<TarotSpreadStep5Page> {
  final ValueNotifier<bool> isAutoShuffle = ValueNotifier(false);
  final ValueNotifier<int> shuffleTimeLeft = ValueNotifier(0);
  Timer? _autoShuffleTimer;

  @override
  void dispose() {
    _autoShuffleTimer?.cancel();
    isAutoShuffle.dispose();
    shuffleTimeLeft.dispose();
    super.dispose();
  }

  void toggleAutoShuffle() {
    if (isAutoShuffle.value) {
      isAutoShuffle.value = false;
      _autoShuffleTimer?.cancel();
      shuffleTimeLeft.value = 0;
    } else {
      isAutoShuffle.value = true;
      shuffleTimeLeft.value = 10;
      _autoShuffleTimer?.cancel();
      _autoShuffleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (shuffleTimeLeft.value > 1) {
          shuffleTimeLeft.value--;
        } else {
          isAutoShuffle.value = false;
          shuffleTimeLeft.value = 0;
          timer.cancel();
        }
      });
    }
  }

  Future<void> onFinish() async {
    await context.push(AppRoutes.tarotQuestionCardPick);
  }
}
