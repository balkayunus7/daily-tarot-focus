import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_compatibility/helpers/zodiac_compatibility_page_mixin.dart';
import 'package:flutter/widgets.dart';

class ZodiacCompatibilityPageScope extends InheritedWidget {
  const ZodiacCompatibilityPageScope({required this.state, required super.child, super.key});
  final ZodiacCompatibilityPageMixin state;

  static ZodiacCompatibilityPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ZodiacCompatibilityPageScope>();
    assert(result != null, 'No ZodiacCompatibilityPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ZodiacCompatibilityPageScope oldWidget) => false;
}
