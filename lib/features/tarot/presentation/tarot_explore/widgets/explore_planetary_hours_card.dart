part of '../pages/tarot_explore_page.dart';

class ExplorePlanetaryHoursCard extends StatelessWidget {
  const ExplorePlanetaryHoursCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ExploreFeatureCard(
      title: LocaleKeys.planetary_page_explore_card_title.tr(),
      imageWidget: const PlanetaryHoursIllustration(),
      onTap: () => context.push(AppRoutes.planetaryHours),
    );
  }
}
