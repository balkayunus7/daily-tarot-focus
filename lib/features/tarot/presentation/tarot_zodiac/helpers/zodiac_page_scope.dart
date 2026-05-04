import 'package:daily_tarot_focus/features/tarot/presentation/tarot_zodiac/helpers/zodiac_page_mixin.dart';
import 'package:flutter/widgets.dart';

class ZodiacPageScope extends InheritedWidget {
  const ZodiacPageScope({
    required this.state,
    required super.child,
    super.key,
  });

  final ZodiacPageMixin state;

  static ZodiacPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ZodiacPageScope>();
    assert(result != null, 'No ZodiacPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ZodiacPageScope oldWidget) => false;
}
