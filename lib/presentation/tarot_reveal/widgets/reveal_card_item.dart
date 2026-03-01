part of '../pages/tarot_reveal_page.dart';

class RevealCardItem extends StatelessWidget {
  const RevealCardItem({
    required this.index,
    required this.isSelected,
    required this.cardImagePath,
    required this.handleCardTap,
    super.key,
  });
  final int index;
  final bool isSelected;
  final String cardImagePath;
  final void Function(int index) handleCardTap;

  @override
  Widget build(BuildContext context) {
    final scope = RevealPageScope.of(context);
    final cardWidth = scope.getRevealCardWidth(isSelected: isSelected);
    final cardHeight = scope.getRevealCardHeight(isSelected: isSelected);

    return RotatedBox(
      quarterTurns: -1,
      child: Center(
        child: GestureDetector(
          onTap: () => handleCardTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: cardWidth,
            height: cardHeight,
            margin: EdgeInsets.symmetric(vertical: isSelected ? 0 : 2),
            decoration: BoxDecoration(
              borderRadius: Spacing.defaultBorderRadius,
              border: Border.all(color: context.colors.surfaceSecondary),
              boxShadow: isSelected ? context.colors.primary.highShadow : [],
            ),
            child: ClipRRect(
              borderRadius: Spacing.defaultBorderRadius,
              child: Image.asset(TarotAppAssets.cardBg.path, fit: BoxFit.fill),
            ),
          ),
        ),
      ),
    );
  }
}
