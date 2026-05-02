import 'package:daily_tarot_focus/core/widgets/tarot_detail_content.dart';
import 'package:flutter/material.dart';

mixin TarotDetailContentMixin on State<TarotDetailContent> {
  late final ValueNotifier<bool> isUpright;

  @override
  void initState() {
    super.initState();
    isUpright = ValueNotifier(true);
  }

  @override
  void dispose() {
    isUpright.dispose();
    super.dispose();
  }

  set upright(bool value) => isUpright.value = value;
}
