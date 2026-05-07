part of '../pages/tarot_explore_page.dart';

class ExploreDailyCardWithCooldown extends StatelessWidget {
  const ExploreDailyCardWithCooldown({super.key});

  @override
  Widget build(BuildContext context) {
    return ExploreFeatureCard(
      title: LocaleKeys.explore_page_discover_daily.tr(),
      imageWidget: const DailyFateIllustration(),
      onTap: () => context.push(AppRoutes.tarotReveal),
    );
  }
}
