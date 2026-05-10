part of '../pages/tarot_explore_page.dart';

class ExploreAnswerBookCard extends StatelessWidget {
  const ExploreAnswerBookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ExploreFeatureCard(
      title: LocaleKeys.answer_book_explore_card_title.tr(),
      imageWidget: const BookOfAnswersIllustration(),
      onTap: () => context.push(AppRoutes.answerBook),
    );
  }
}
