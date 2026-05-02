import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/helpers/reveal_detail_page_mixin.dart';
import 'package:flutter/widgets.dart';

class RevealDetailPageScope extends InheritedWidget {
  const RevealDetailPageScope({required this.state, required super.child, super.key});
  final RevealDetailPageMixin state;

  static RevealDetailPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<RevealDetailPageScope>();
    assert(result != null, 'No RevealDetailPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RevealDetailPageScope oldWidget) => false;
}
