import 'package:daily_tarot_focus/features/planetary_hours/domain/planetary_hour_calculator.dart';

/// A day-to-day activity mapped to the classical planet that traditionally
/// rules it. Used by the Best Time Planner to point the user at the planetary
/// hours best suited to what they want to do today.
enum PlanetaryActivity {
  study(PlanetaryRuler.mercury),
  workout(PlanetaryRuler.mars),
  meeting(PlanetaryRuler.mercury),
  meditation(PlanetaryRuler.moon),
  date(PlanetaryRuler.venus),
  creativity(PlanetaryRuler.venus),
  business(PlanetaryRuler.jupiter),
  travel(PlanetaryRuler.jupiter);

  const PlanetaryActivity(this.ruler);

  /// The planet whose hours are the best time for this activity.
  final PlanetaryRuler ruler;

  /// Activities that a given planet is a good time for (reverse mapping).
  static List<PlanetaryActivity> forRuler(PlanetaryRuler ruler) =>
      PlanetaryActivity.values.where((a) => a.ruler == ruler).toList();
}
