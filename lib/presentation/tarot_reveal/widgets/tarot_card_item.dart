part of '../pages/tarot_reveal_page.dart';

class CardItem extends StatelessWidget {
  const CardItem({
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
    double getCardSize({required bool isWidth, required bool isSelected}) {
      if (isWidth) {
        return isSelected ? SpacingConsts.wheelCardSelectedWidth : SpacingConsts.wheelCardUnselectedWidth;
      }
      return isSelected ? SpacingConsts.wheelCardSelectedHeight : SpacingConsts.wheelCardUnselectedHeight;
    }

    return RotatedBox(
      quarterTurns: -1,
      child: Center(
        child: GestureDetector(
          onTap: () => handleCardTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: getCardSize(isWidth: true, isSelected: isSelected),
            height: getCardSize(isWidth: false, isSelected: isSelected),
            margin: EdgeInsets.symmetric(vertical: isSelected ? 0 : 2),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: Spacing.xsmallBorderRadius,
              border:
                  isSelected
                      ? Border.all(
                        color: context.colors.surfaceSecondary,
                        width: 1.5,
                      )
                      : null,
              boxShadow: [
                BoxShadow(
                  color: context.colors.background.withValues(
                    alpha: isSelected ? 0.4 : 0.3,
                  ),
                  blurRadius: isSelected ? 15 : 8,
                  spreadRadius: isSelected ? 2 : 1,
                ),
                if (isSelected)
                  BoxShadow(
                    color: context.colors.surfaceSecondary,
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: Spacing.xsmallBorderRadius,
              child: Image.asset(
                TarotAppAssets.cardDesign.path,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
