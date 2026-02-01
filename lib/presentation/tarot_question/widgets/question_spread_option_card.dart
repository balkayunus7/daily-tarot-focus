part of '../pages/tarot_question_page.dart';

class QuestionSpreadOptionCard extends StatelessWidget {
  const QuestionSpreadOptionCard({
    required this.cardCount,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final int cardCount;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final itemWidth = MediaQuery.of(context).size.width / 2 - 28;
    final itemHeight = itemWidth + SpacingConsts.medium;
    final selectedColor = isSelected ? colors.primary : colors.surfaceSecondary;
    final cardWidth = itemHeight / 5;
    final cardHeight = itemHeight / 3;

    return ScalingContainer(
      onTap: onTap,
      child: Container(
        height: itemHeight,
        width: itemWidth,
        decoration: BoxDecoration(
          borderRadius: Spacing.defaultBorderRadius,
          border: Border.all(color: selectedColor, width: 2),
        ),
        child: Padding(
          padding: Spacing.xsmallPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  cardCount,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingConsts.tiny,
                    ),
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        borderRadius: Spacing.xsmallBorderRadius,
                        border: Border.all(color: selectedColor),
                      ),
                    ),
                  ),
                ),
              ),
              Spacing.mediumH,
              Text(title, style: m16w500(context)),
              Spacing.tinyH,
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: m12w500(context).copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
