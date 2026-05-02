import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/pages/tarot_spread_step6_page.dart';
import 'package:flutter/material.dart';

mixin Step6PageMixin on State<TarotSpreadStep6Page> {
  final ValueNotifier<bool> isReadingReady = ValueNotifier(false);

  @override
  void dispose() {
    isReadingReady.dispose();
    super.dispose();
  }
}
