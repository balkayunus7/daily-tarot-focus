part of '../pages/tarot_reveal_page.dart';

class RevealCardWheel extends StatelessWidget {
  const RevealCardWheel({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = RevealPageScope.of(context);
    final cardWheelheight = context.suHeight * 0.25;
    final screenWidth = context.suWidth;

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
                    itemExtent: CardSp.wheelItemExtent,
                    diameterRatio: CardSp.wheelDiameterRatio,
                    perspective: CardSp.wheelPerspective,
                    physics: const FixedExtentScrollPhysics(parent: ClampingScrollPhysics()),
                    squeeze: CardSp.wheelSqueeze,
                    clipBehavior: Clip.none,
                    onSelectedItemChanged: scope.handleCardScroll,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: CardSp.totalCards,
                      builder: (context, index) {
                        final isSelected = index == selectedCardIndex;

                        return RevealCardItem(
                          index: index,
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
          Sp.xsmall.heightBox,
          CustomCacheNetworkImage(
            imageUrl: TarotAppAssets.arrowHttp,
            width: screenWidth * 0.25,
            height: screenWidth * 0.12,
            color: context.colors.primary,
          ),
          Text(
            LocaleKeys.reveal_page_drag_to_move.tr(),
            style: m12w500(context).copyWith(color: context.colors.textSecondary),
          ),
          Sp.medium.heightBox,
        ],
      ),
    );
  }
}
