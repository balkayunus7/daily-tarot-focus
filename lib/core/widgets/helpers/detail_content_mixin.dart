import 'package:daily_tarot_focus/core/widgets/tarot_detail_content.dart';
import 'package:flutter/material.dart';

mixin TarotDetailContentMixin on State<TarotDetailContent>, TickerProvider {
  late final ValueNotifier<bool> isUpright;
  late final ValueNotifier<bool> isExpanded;
  late final AnimationController animController;
  late final Animation<double> expandAnimation;

  @override
  void initState() {
    super.initState();
    isUpright = ValueNotifier(true);
    isExpanded = ValueNotifier(false);

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    expandAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    isUpright.dispose();
    isExpanded.dispose();
    animController.dispose();
    super.dispose();
  }

  set upright(bool value) => isUpright.value = value;

  Future<void> toggle() async {
    isExpanded.value = !isExpanded.value;
    if (isExpanded.value) {
      await animController.forward();
    } else {
      await animController.reverse();
    }
  }
}
