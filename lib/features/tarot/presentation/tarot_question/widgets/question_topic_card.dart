part of '../pages/tarot_question_page.dart';

class QuestionTopicCard extends StatelessWidget {
  const QuestionTopicCard({
    required this.title,
    required this.svgIconPath,
    required this.onTap,
    required this.isSelected,
    super.key,
  });

  final String title;
  final String svgIconPath;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenSize = Spacing.screenWidth(context);
    final cardWidth = (screenSize / 3) - 24;
    final primaryColor = isSelected ? colors.primary : colors.textDisabled;

    return ScalingContainer(
      onTap: onTap,
      child: FancyContainer(
        padding: Spacing.hMediumVSmallPad,
        width: cardWidth,
        height: cardWidth * 1.2,
        color:
            isSelected
                ? colors.primary.withValues(alpha: 0.1)
                : colors.secondary.withValues(alpha: 0.1),
        borderRadius: Spacing.smallBorderRadius,
        borderType: isSelected ? BorderType.high : BorderType.low,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset(
                svgIconPath,
                colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
              ),
            ),
            Spacing.smallH,
            Text(
              title,
              style: m16w600(context).copyWith(color: primaryColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
