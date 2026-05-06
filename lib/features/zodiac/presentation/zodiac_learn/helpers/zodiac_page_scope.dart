import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/zodiac_page_mixin.dart';
import 'package:flutter/widgets.dart';

class ZodiacLearnPageScope extends InheritedWidget {
  const ZodiacLearnPageScope({required this.state, required super.child, super.key});
  final ZodiacLearnPageMixin state;

  static ZodiacLearnPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ZodiacLearnPageScope>();
    assert(result != null, 'No ZodiacPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ZodiacLearnPageScope oldWidget) => false;
}
