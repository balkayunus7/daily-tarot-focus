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
            margin: (isSelected ? 0.0 : 2.0).padYR,
            decoration: BoxDecoration(
              borderRadius: Sp.medium.radiusR,
              border: Border.all(color: context.colors.border),
              boxShadow: isSelected ? context.colors.primary.mediumShadow : [],
            ),
            child: ClipRRect(
              borderRadius: Sp.medium.radiusR,
              child: CustomCacheNetworkImage(
                imageUrl: TarotAppAssets.cardBgHttp,
                width: cardWidth,
                height: cardHeight,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
