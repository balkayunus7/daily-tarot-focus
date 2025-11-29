part of '../../pages/tarot_reveal_page.dart';

class TarotCardWheel extends StatefulWidget {
  const TarotCardWheel({super.key});

  @override
  State<TarotCardWheel> createState() => _TarotCardWheelState();
}

class _TarotCardWheelState extends State<TarotCardWheel>
    with TickerProviderStateMixin {
  int _selectedCardIndex = 0;
  int _lastHapticCardIndex = -1;
  // Animation Controllers
  late final AnimationController _entranceController;

  // Scroll Controller
  late final FixedExtentScrollController _scrollController;
  late final AnimationController _flipController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startEntranceAnimation();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _entranceController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    const initialCardIndex = _TarotRevealConstants.totalCards ~/ 2;

    _scrollController = FixedExtentScrollController(
      initialItem: initialCardIndex,
    );
    _selectedCardIndex = initialCardIndex;
    _lastHapticCardIndex = initialCardIndex;

    _entranceController = AnimationController(
      vsync: this,
      duration: _TarotRevealConstants.entranceAnimationDuration,
    );

    _flipController = AnimationController(
      vsync: this,
      duration: _TarotRevealConstants.flipAnimationDuration,
    );
  }

  void _startEntranceAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () async {
      if (mounted) {
        await _entranceController.forward();
      }
    });
  }

  Future<void> _handleCardScroll(int index) async {
    if (index != _lastHapticCardIndex) {
      _lastHapticCardIndex = index;
      await HapticFeedbackHelper.mediumImpact();
    }

    setState(() => _selectedCardIndex = index);
  }

  Future<void> _handleCardTap(int index) async {
    final inheritedWidget = _TarotRevealStateInherited.of(context);
    final notifier = inheritedWidget?.notifier;
    if (notifier == null || notifier.isCardSelected) return;

    setState(() => _selectedCardIndex = index);

    notifier.setCardSelected(value: true);
    await _flipController.forward();
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
            child: AnimatedBuilder(
              animation: _entranceController,
              builder: (context, child) {
                return Opacity(
                  opacity: Curves.easeOut.transform(
                    _entranceController.value,
                  ),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: ListWheelScrollView.useDelegate(
                      controller: _scrollController,
                      itemExtent: _TarotRevealConstants.cardExtent,
                      diameterRatio: _TarotRevealConstants.wheelDiameterRatio,
                      perspective: _TarotRevealConstants.wheelPerspective,
                      physics: const FixedExtentScrollPhysics(
                        parent: ClampingScrollPhysics(),
                      ),
                      squeeze: _TarotRevealConstants.wheelSqueeze,
                      clipBehavior: Clip.none,
                      onSelectedItemChanged: _handleCardScroll,
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          final isSelected = index == _selectedCardIndex;
                          return CardItem(
                            index: index,
                            isSelected: isSelected,
                            handleCardTap: _handleCardTap,
                          );
                        },
                        childCount: _TarotRevealConstants.totalCards,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Spacing.xsmallH,
          AnimatedBuilder(
            animation: _entranceController,
            builder: (context, child) {
              return Opacity(
                opacity: Curves.easeOut.transform(_entranceController.value),
                child: Text(
                  'Drag to move',
                  style: m12w500(context).copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
