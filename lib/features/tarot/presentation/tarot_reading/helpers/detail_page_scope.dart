import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/helpers/detail_page_mixin.dart';
import 'package:flutter/widgets.dart';

class DetailPageScope extends InheritedWidget {
  const DetailPageScope({required this.state, required super.child, super.key});
  final DetailPageMixin state;

  static DetailPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<DetailPageScope>();
    assert(result != null, 'No DetailPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DetailPageScope oldWidget) => false;
}
