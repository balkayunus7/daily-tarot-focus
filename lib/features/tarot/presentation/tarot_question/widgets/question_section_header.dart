part of '../pages/tarot_question_page.dart';

class QuestionSectionHeader extends StatelessWidget {
  const QuestionSectionHeader({required this.title, required this.icon, super.key});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, color: colors.primary, size: 20),
        Spacing.mediumW,
        Text(title, style: m16w500(context)),
      ],
    );
  }
}
