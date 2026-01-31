part of '../pages/tarot_question_page.dart';

class QuestionTopicCard extends StatelessWidget {
  const QuestionTopicCard({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isSelected,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenSize = Spacing.screenWidth(context);
    final cardWidth = (screenSize / 3) - 24;
    final primaryColor = isSelected ? colors.primary : colors.surfaceSecondary;

    return ScalingContainer(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: SpacingConsts.medium),
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: Spacing.smallBorderRadius,
          border: Border.all(color: primaryColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryColor),
            Spacing.smallH,
            Text(
              title,
              style: m16w500(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
