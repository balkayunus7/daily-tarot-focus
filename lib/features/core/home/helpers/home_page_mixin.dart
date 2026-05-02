import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/features/core/home/home_page.dart';
import 'package:flutter/material.dart';

mixin HomePageMixin on State<HomePage> {
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final initialTab = widget.arguments.initialTabIndex;
    pageController = PageController(initialPage: initialTab);
    currentIndex = initialTab;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newArgs = widget.arguments;
    final oldArgs = oldWidget.arguments;
    var shouldJump = false;
    if (newArgs.forceUpdateKey != null && newArgs.forceUpdateKey != oldArgs.forceUpdateKey) {
      shouldJump = true;
    } else if (newArgs.initialTabIndex != oldArgs.initialTabIndex) {
      shouldJump = true;
    }
    if (shouldJump && currentIndex != newArgs.initialTabIndex) {
      setState(() => currentIndex = newArgs.initialTabIndex);
      if (pageController.hasClients) pageController.jumpToPage(currentIndex);
    }
  }

  Future<void> onNavbarTap(int index) async {
    await HapticFeedbackHelper.selectionClick();
    setState(() => currentIndex = index);
    pageController.jumpToPage(index);
  }
}
