import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/helpers/reading_page_mixin.dart';
import 'package:flutter/widgets.dart';

class ReadingPageScope extends InheritedWidget {
  const ReadingPageScope({required this.state, required super.child, super.key});
  final ReadingPageMixin state;

  static ReadingPageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ReadingPageScope>();
    assert(result != null, 'No DailyPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ReadingPageScope oldWidget) => false;
}
