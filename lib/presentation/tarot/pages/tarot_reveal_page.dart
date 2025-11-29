import 'dart:math' as math;
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';

// Constants
class _TarotRevealConstants {
  static const int totalCards = 22;
  static const double cardExtent = 130;
  static const double wheelDiameterRatio = 1.8;
  static const double wheelPerspective = 0.008;
  static const double wheelSqueeze = 1.5;

  static const Duration entranceAnimationDuration = Duration(
    milliseconds: 1500,
  );
  static const Duration flipAnimationDuration = Duration(milliseconds: 800);
  static const Duration starsAnimationDuration = Duration(seconds: 2);
  static const Duration cardFlipDuration = Duration(milliseconds: 3000);
  static const Duration navigationDelay = Duration(milliseconds: 5000);

  static const double selectedCardWidth = 100;
  static const double unselectedCardWidth = 70;
  static const double selectedCardHeight = 200;
  static const double unselectedCardHeight = 110;

  static const double cardBorderRadius = 12;
  static const double shiningStarsScale = 5;
}

class TarotRevealPage extends StatefulWidget {
  const TarotRevealPage({super.key});

  @override
  State<TarotRevealPage> createState() => _TarotRevealPageState();
}

class _TarotRevealPageState extends State<TarotRevealPage>
    with TickerProviderStateMixin {
  // Animation Controllers
  late final AnimationController _entranceController;
  late final AnimationController _flipController;
  late final AnimationController _starsController;

  // Scroll Controller
  late final FixedExtentScrollController _scrollController;

  // State
  bool _isCardSelected = false;
  bool _isNavigating = false;
  int _selectedCardIndex = 0;
  int _lastHapticCardIndex = -1;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startEntranceAnimation();
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

    _starsController = AnimationController(
      vsync: this,
      duration: _TarotRevealConstants.starsAnimationDuration,
    );
  }

  void _startEntranceAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () async {
      if (mounted) {
        await _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _entranceController.dispose();
    _flipController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  Future<void> _handleCardTap(int index) async {
    if (_isCardSelected) return;

    setState(() => _isCardSelected = true);
    await _flipController.forward();
    _scheduleNavigation();
  }

  void _scheduleNavigation() {
    Future.delayed(_TarotRevealConstants.navigationDelay, () {
      if (mounted && !_isNavigating) {
        _navigateToCardDetail();
      }
    });
  }

  void _navigateToCardDetail() {
    setState(() => _isNavigating = true);
    context.go(AppRoutes.tarotCardDetail);
  }

  Future<void> _handleCardScroll(int index) async {
    if (index != _lastHapticCardIndex) {
      _lastHapticCardIndex = index;
      await HapticFeedbackHelper.mediumImpact();
    }

    setState(() => _selectedCardIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          _buildHeader(),
          if (!_isCardSelected) _buildCardWheel(),
          if (_isCardSelected) _buildFlippingCard(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Image.asset(
      TarotAppAssets.background.path,
      fit: BoxFit.cover,
    );
  }

  Widget _buildHeader() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: _isCardSelected ? 0.0 : 1.0,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateTime.now().toLocal().dayMonthDay(
                  Localizations.localeOf(context),
                ),
                style: m28w600(context),
              ),
              Spacing.xsmallH,
              Text(
                'Tap to pick your card',
                style: m14w500(context).copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardWheel() {
    return Positioned(
      bottom: 80,
      left: -150,
      right: -150,
      height: 250,
      child: ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 600,
            child: AnimatedBuilder(
              animation: _entranceController,
              builder: (context, child) {
                return Opacity(
                  opacity: Curves.easeOut.transform(_entranceController.value),
                  child: _buildRotatedCardWheel(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRotatedCardWheel() {
    return RotatedBox(
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
          builder: (context, index) => _buildCardItem(index),
          childCount: _TarotRevealConstants.totalCards,
        ),
      ),
    );
  }

  Widget _buildCardItem(int index) {
    final isSelected = index == _selectedCardIndex;

    return RotatedBox(
      quarterTurns: -1,
      child: Center(
        child: GestureDetector(
          onTap: () => _handleCardTap(index),
          child: _buildCardContainer(isSelected),
        ),
      ),
    );
  }

  Widget _buildCardContainer(bool isSelected) {
    final cardWidth =
        isSelected
            ? _TarotRevealConstants.selectedCardWidth
            : _TarotRevealConstants.unselectedCardWidth;
    final cardHeight =
        isSelected
            ? _TarotRevealConstants.selectedCardHeight
            : _TarotRevealConstants.unselectedCardHeight;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(vertical: isSelected ? 0 : 2),
      decoration: _buildCardDecoration(isSelected),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          _TarotRevealConstants.cardBorderRadius,
        ),
        child: Image.asset(
          TarotAppAssets.cardDesign.path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration(bool isSelected) {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(
        _TarotRevealConstants.cardBorderRadius,
      ),
      border:
          isSelected
              ? Border.all(
                color: Colors.amber.withValues(alpha: 0.4),
                width: 1.5,
              )
              : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isSelected ? 0.4 : 0.3),
          blurRadius: isSelected ? 15 : 8,
          spreadRadius: isSelected ? 2 : 1,
        ),
        if (isSelected)
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 3,
          ),
      ],
    );
  }

  Widget _buildFlippingCard() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: _TarotRevealConstants.cardFlipDuration,
        curve: Curves.easeInOutCubic,
        builder: (context, value, child) {
          final isFrontVisible = value >= 0.5;
          final scale = 1.0 + (value * 1.5);
          final rotateY = math.pi * value;

          return Stack(
            alignment: Alignment.center,
            children: [
              _buildFlippingCardTransform(rotateY, scale, isFrontVisible),
              if (isFrontVisible) _buildShiningStars(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFlippingCardTransform(
    double rotateY,
    double scale,
    bool isFrontVisible,
  ) {
    return Transform(
      alignment: Alignment.center,
      transform:
          Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(rotateY)
            ..scale(scale),
      child:
          isFrontVisible
              ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(math.pi),
                child: const _TarotCardFront(),
              )
              : const _TarotCardBack(),
    );
  }

  Widget _buildShiningStars() {
    return _ShiningStarsAnimation(controller: _starsController);
  }
}

// Separate widget for card back
class _TarotCardBack extends StatelessWidget {
  const _TarotCardBack();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'daily_tarot_card_hero',
      child: Container(
        width: 120,
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            _TarotRevealConstants.cardBorderRadius,
          ),
          border: Border.all(
            color: Colors.amber.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Image.asset(
            TarotAppAssets.cardDesign.path,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// Separate widget for card front
class _TarotCardFront extends StatelessWidget {
  const _TarotCardFront();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'daily_tarot_card_hero',
      child: Container(
        width: 120,
        height: 190,
        padding: const EdgeInsets.all(8),
        decoration: _buildDecoration(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  TarotAppAssets.starCard.path,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              child: Text('The Star', style: m12w600(context)),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(
        _TarotRevealConstants.cardBorderRadius,
      ),
      border: Border.all(color: Colors.amber, width: 2),
      boxShadow: [
        BoxShadow(
          color: Colors.amber.withValues(alpha: 0.3),
          blurRadius: 30,
          spreadRadius: 10,
        ),
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          context.colors.primary,
          context.colors.secondary,
          context.colors.accent,
        ],
      ),
    );
  }
}

// Shining stars animation widget
class _ShiningStarsAnimation extends StatefulWidget {
  const _ShiningStarsAnimation({required this.controller});

  final AnimationController controller;

  @override
  State<_ShiningStarsAnimation> createState() => _ShiningStarsAnimationState();
}

class _ShiningStarsAnimationState extends State<_ShiningStarsAnimation> {
  @override
  void initState() {
    super.initState();
    widget.controller.repeat();
  }

  @override
  void dispose() {
    widget.controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Transform.scale(
          scale: _TarotRevealConstants.shiningStarsScale,
          child: Lottie.asset(
            TarotAppAssets.shiningStars.path,
            controller: widget.controller,
            fit: BoxFit.contain,
            repeat: true,
            animate: true,
          ),
        ),
      ),
    );
  }
}
