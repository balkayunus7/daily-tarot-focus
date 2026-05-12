part of '../pages/tarot_explore_page.dart';

class ExploreNumerologyCard extends StatelessWidget {
  const ExploreNumerologyCard({super.key});

  Future<void> _onTap(BuildContext context) async {
    final saved = await NumerologyStorage.load();
    if (!context.mounted) return;
    if (saved != null) {
      unawaited(context.push(AppRoutes.numerologyResult, extra: saved));
    } else {
      unawaited(context.push(AppRoutes.numerologyInput));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExploreFeatureCard(
      title: LocaleKeys.numerology_page_explore_card_title.tr(),
      imageWidget: const NumerologyIllustration(),
      onTap: () => _onTap(context),
    );
  }
}
