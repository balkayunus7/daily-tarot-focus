part of '../pages/tarot_explore_page.dart';

class ExploreNumerologyCard extends StatelessWidget {
  const ExploreNumerologyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ExploreFeatureCard(
      title: LocaleKeys.numerology_page_explore_card_title.tr(),
      imageWidget: const NumerologyIllustration(),
      onTap: () => context.push(AppRoutes.numerologyInput),
    );
  }
}
