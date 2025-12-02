part of '../../pages/tarot_reveal_page.dart';

class TarotCardWheel extends StatefulWidget {
  const TarotCardWheel({required this.onCardSelected, super.key});
  final VoidCallback onCardSelected;

  @override
  State<TarotCardWheel> createState() => _TarotCardWheelState();
}

class _TarotCardWheelState extends State<TarotCardWheel>
    with TickerProviderStateMixin {
  int selectedCardIndex = 0;
  int lastHapticCardIndex = -1;

  late final FixedExtentScrollController _scrollController;
  late final AnimationController _flipController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    const initialCardIndex = SpacingConsts.totalCards ~/ 2;

    _scrollController = FixedExtentScrollController(
      initialItem: initialCardIndex,
    );
    selectedCardIndex = initialCardIndex;
    lastHapticCardIndex = initialCardIndex;

    _flipController = AnimationController(
      vsync: this,
      duration: SpacingConsts.flipAnimationDuration,
    );
  }

  Future<void> _handleCardScroll(int index) async {
    if (index != lastHapticCardIndex) {
      lastHapticCardIndex = index;
      await HapticFeedbackHelper.heavyImpact();
    }

    setState(() => selectedCardIndex = index);
  }

  Future<void> _handleCardTap(int index) async {
    setState(() => selectedCardIndex = index);
    await _flipController.forward();
    widget.onCardSelected();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 250,
            child: RotatedBox(
              quarterTurns: 1,
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: SpacingConsts.cardWheelItemExtent,
                diameterRatio: SpacingConsts.cardWheelDiameterRatio,
                perspective: SpacingConsts.cardWheelPerspective,
                physics: const FixedExtentScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                squeeze: SpacingConsts.cardWheelSqueeze,
                clipBehavior: Clip.none,
                onSelectedItemChanged: _handleCardScroll,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: SpacingConsts.totalCards,
                  builder: (context, index) {
                    final isSelected = index == selectedCardIndex;

                    return CardItem(
                      index: index,
                      cardImagePath: TarotMockDatas.randomTarotCard,
                      isSelected: isSelected,
                      handleCardTap: _handleCardTap,
                    );
                  },
                ),
              ),
            ),
          ),
          Spacing.xsmallH,
          Image.asset(
            TarotAppAssets.arrow.path,
            width: 100,
            height: 50,
            color: context.colors.primary,
          ),
          Text(
            'Drag to move',
            style: m12w500(
              context,
            ).copyWith(color: context.colors.textSecondary),
          ),
          Spacing.mediumH,
        ],
      ),
    );
  }
}
