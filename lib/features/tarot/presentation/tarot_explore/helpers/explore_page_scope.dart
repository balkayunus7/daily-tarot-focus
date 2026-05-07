part of '../pages/tarot_explore_page.dart';

class ExplorePageScope extends InheritedWidget {
  const ExplorePageScope({required this.state, required super.child, super.key});

  final ExplorePageStateMixin state;

  static ExplorePageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ExplorePageScope>();
    assert(result != null, 'No ExplorePageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ExplorePageScope oldWidget) => false;
}
