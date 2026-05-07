part of '../pages/tarot_explore_page.dart';

class ExploreCompatibilityCard extends StatelessWidget {
  const ExploreCompatibilityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ExploreFeatureCard(
      title: LocaleKeys.compat_page_explore_card_title.tr(),
      imageWidget: const CompatibilityIllustration(),
      onTap: () => context.push(AppRoutes.tarotCompatibilityInput),
    );
  }
}
