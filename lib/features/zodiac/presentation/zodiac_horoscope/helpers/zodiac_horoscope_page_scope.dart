part of '../pages/zodiac_horoscope_page.dart';

class ZodiacHoroscopePageScope extends InheritedWidget {
  const ZodiacHoroscopePageScope({required this.state, required super.child, super.key});
  final ZodiacHoroscopePageMixin state;

  static ZodiacHoroscopePageScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ZodiacHoroscopePageScope>();
    assert(result != null, 'No ZodiacHoroscopePageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ZodiacHoroscopePageScope oldWidget) => false;
}
