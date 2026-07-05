part of '../pages/planetary_hours_page.dart';

class PlanetaryHoursPageScope extends InheritedWidget {
  const PlanetaryHoursPageScope({
    required this.state,
    required super.child,
    super.key,
  });
  final PlanetaryHoursPageMixin state;

  static PlanetaryHoursPageScope of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<PlanetaryHoursPageScope>();
    assert(result != null, 'No PlanetaryHoursPageScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(PlanetaryHoursPageScope oldWidget) => false;
}
