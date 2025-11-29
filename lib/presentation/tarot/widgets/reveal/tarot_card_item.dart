part of '../../pages/tarot_reveal_page.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    required this.index,
    required this.isSelected,
    required this.handleCardTap,
    super.key,
  });
  final int index;
  final bool isSelected;
  final void Function(int index) handleCardTap;

  @override
  Widget build(BuildContext context) {
    final cardWidth = isSelected ? 100.0 : 70.0;
    final cardHeight = isSelected ? 200.0 : 110.0;

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
              color: Colors.transparent,
              borderRadius: Spacing.xsmallBorderRadius,

              border:
                  isSelected
                      ? Border.all(
                        color: context.colors.primary.withValues(alpha: 0.4),
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
                    color: context.colors.primary.withValues(alpha: 0.5),
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
