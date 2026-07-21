part of '../pages/tarot_explore_page.dart';

/// Full Planetary Hours experience (day/night hour tables, day ruler, sunrise
/// and sunset), embedded directly in the first Explore tab so it is the
/// first thing shown, not just a teaser card above the tabs.
class ExplorePlanetaryHoursTab extends StatefulWidget {
  const ExplorePlanetaryHoursTab({super.key});

  @override
  State<ExplorePlanetaryHoursTab> createState() => _ExplorePlanetaryHoursTabState();
}

class _ExplorePlanetaryHoursTabState extends State<ExplorePlanetaryHoursTab>
    with PlanetaryHoursPageMixin<ExplorePlanetaryHoursTab> {
  @override
  Widget build(BuildContext context) {
    return PlanetaryHoursPageScope(
      state: this,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ExplorePlanetaryHoursCard(),
        ],
      ),
    );
  }
}
