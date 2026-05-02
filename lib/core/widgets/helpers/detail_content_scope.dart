import 'package:daily_tarot_focus/core/widgets/helpers/detail_content_mixin.dart';
import 'package:flutter/widgets.dart';

class TarotDetailContentScope extends InheritedWidget {
  const TarotDetailContentScope({required this.state, required super.child, super.key});
  final TarotDetailContentMixin state;

  static TarotDetailContentScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<TarotDetailContentScope>();
    assert(result != null, 'No TarotDetailContentScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TarotDetailContentScope oldWidget) => false;
}
