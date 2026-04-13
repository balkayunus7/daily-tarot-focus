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
    final selectedColor = isSelected ? colors.primary : colors.textDisabled;
    final cardWidth = itemHeight / 4;

    return ScalingContainer(
      onTap: onTap,
      child: FancyContainer(
        height: itemHeight,
        width: itemWidth,
        borderRadius: Spacing.defaultBorderRadius,
        borderType: isSelected ? BorderType.high : BorderType.low,
        child: Padding(
          padding: Spacing.xsmallPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  cardCount,
                  (index) => SizedBox(
                    width: cardWidth,
                    height: cardWidth,
                    child: SvgPicture.asset(
                      TarotAppAssets.card.path,
                      colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
              Spacing.mediumH,
              Text(title, style: m16w600(context).copyWith(color: selectedColor)),
              Spacing.tinyH,
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: m12w500(context).copyWith(color: selectedColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
