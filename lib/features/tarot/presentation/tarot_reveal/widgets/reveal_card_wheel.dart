part of '../pages/tarot_reveal_page.dart';

class RevealCardWheel extends StatelessWidget {
  const RevealCardWheel({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = RevealPageScope.of(context);
    final cardWheelheight = Spacing.screenHeight(context) * 0.25;
    final screenWidth = Spacing.screenWidth(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: cardWheelheight,
            child: RotatedBox(
              quarterTurns: 1,
              child: ValueListenableBuilder<int>(
                valueListenable: scope.selectedCardIndex,
                builder: (context, selectedCardIndex, _) {
                  return ListWheelScrollView.useDelegate(
                    controller: scope.wheelScrollController,
                    itemExtent: SpacingConsts.cardWheelItemExtent,
                    diameterRatio: SpacingConsts.cardWheelDiameterRatio,
                    perspective: SpacingConsts.cardWheelPerspective,
                    physics: const FixedExtentScrollPhysics(parent: ClampingScrollPhysics()),
                    squeeze: SpacingConsts.cardWheelSqueeze,
                    clipBehavior: Clip.none,
                    onSelectedItemChanged: scope.handleCardScroll,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: SpacingConsts.totalCards,
                      builder: (context, index) {
                        final isSelected = index == selectedCardIndex;

                        return RevealCardItem(
                          index: index,
                          cardImagePath: TarotMockData.randomTarotCard,
                          isSelected: isSelected,
                          handleCardTap: scope.handleCardTap,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Spacing.xsmallH,
          Image.asset(
            TarotAppAssets.arrow.path,
            width: screenWidth * 0.25,
            height: screenWidth * 0.12,
            color: context.colors.primary,
          ),
          Text(
            LocaleKeys.reveal_page_drag_to_move.tr(),
            style: m12w500(context).copyWith(color: context.colors.textSecondary),
          ),
          Spacing.mediumH,
        ],
      ),
    );
  }
}
