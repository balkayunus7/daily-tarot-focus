import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/helpers/loading_page_mixin.dart';
import 'package:flutter/widgets.dart';

class LoadingPageScope extends InheritedWidget {
  const LoadingPageScope({required this.state, required super.child, super.key});
  final LoadingPageMixin state;

  static LoadingPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LoadingPageScope>();
    assert(result != null, 'No LoadingPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(LoadingPageScope oldWidget) => false;
}
