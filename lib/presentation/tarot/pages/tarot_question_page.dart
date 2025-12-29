import 'dart:math';

import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_datas.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_library.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/app_colors.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotQuestionPage extends StatefulWidget {
  const TarotQuestionPage({super.key});

  @override
  State<TarotQuestionPage> createState() => _TarotQuestionPageState();
}

class _TarotQuestionPageState extends State<TarotQuestionPage>
    with TickerProviderStateMixin {
  List<TarotLibrary> _deck = [];
  List<TarotLibrary> _drawnCards = [];
  bool _isDrawing = false;
  late AnimationController _drawController;
  late Animation<double> _slideDownAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _resetDeck();

    _drawController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideDownAnimation = Tween<double>(
      begin: 0.0,
      end: 300.0,
    ).animate(
      CurvedAnimation(
        parent: _drawController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _drawController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _drawController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _drawController.dispose();
    super.dispose();
  }

  void _resetDeck() {
    setState(() {
      _deck = List.from(TarotMockDatas.fullTarotDeckMock)..shuffle();
      _drawnCards.clear();
    });
  }

  Future<void> _drawCard() async {
    if (_deck.isEmpty || _isDrawing) return;

    setState(() {
      _isDrawing = true;
    });

    await _drawController.forward();

    setState(() {
      final card = _deck.removeLast();
      _drawnCards.add(card);
      _isDrawing = false;
    });

    _drawController.reset();
  }

  Widget _buildDeckCard(BuildContext context, int index) {
    final colors = context.colors;
    final isTopCard = index == _deck.length - 1;

    return AnimatedBuilder(
      animation: _drawController,
      builder: (context, child) {
        final slideDown = isTopCard && _isDrawing
            ? _slideDownAnimation.value
            : 0.0;
        final scale = isTopCard ? _scaleAnimation.value : 1.0;
        final opacity = isTopCard ? _opacityAnimation.value : 1.0;

        // Transform kullan
        Widget cardWidget = Transform.translate(
          offset: Offset(0, slideDown),
          child: Transform.scale(
            scale: isTopCard && _isDrawing
                ? scale.clamp(0.0, 1.0)
                : 1.0,
            child: Opacity(
              opacity: isTopCard && _isDrawing
                  ? opacity.clamp(0.0, 1.0)
                  : 1.0,
              child: child,
            ),
          ),
        );

        return cardWidget;
      },
      child: Container(
        width: 160,
        height: 240,
        decoration: BoxDecoration(
          borderRadius: Spacing.defaultBorderRadius,
          border: Border.all(
            color: colors.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.background.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: colors.primary.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: Spacing.defaultBorderRadius,
          child: Image.asset(
           TarotAppAssets.cardDesign.path,
           fit: BoxFit.cover,
           width: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawnCard(BuildContext context, TarotLibrary card, int index) {
    final colors = context.colors;
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: clampedValue,
          child: Transform.rotate(
            angle: (1 - clampedValue) * 0.5,
            child: Opacity(
              opacity: clampedValue.clamp(0.0, 1.0),
              child: child,
            ),
          ),
        );
      },
      child: Container(
        width: 130,
        height: 200,
        margin: Spacing.tinyPadding,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: Spacing.xsmallBorderRadius,
          border: Border.all(
            color: colors.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withOpacity(0.4),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: Spacing.tinyBorderRadius,
          child: Image.asset(
            card.imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.primary.withOpacity(0.2),
                      colors.accent.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 70,
                    color: colors.primary.withOpacity(0.6),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const TarotAppBar(title: 'Tarot Kart Çekme'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary,
              colors.secondary,
              colors.accent,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Spacing.mediumH,
              // Subtitle
              Text(
                'Desteden kartınızı çekin',
                style: m16w500(context).copyWith(
                  color: colors.primary.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
              Spacing.mediumH,
              // Deck Area
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 280,
                      child:
                          _deck.isEmpty
                              ? Center(
                                child: Container(
                                  width: 160,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colors.primary,
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: Spacing.xsmallBorderRadius,
                                  ),
      child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.inbox_outlined,
                                          color: colors.primary,
                                          size: 40,
                                        ),
                                        Spacing.xsmallH,
                                        Text(
                                          'Boş',
                                          style: m20w800(context).copyWith(
                                            color: colors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              : Stack(
                                clipBehavior: Clip.none,
                        alignment: Alignment.center,
                                children: List.generate(
                                  min(_deck.length, 6),
                                  (index) {
                                    final cardIndex = _deck.length - 1 - index;
                                    return _buildDeckCard(context, cardIndex);
                                  },
                                ),
                              ),
                    ),
                    // Buton
                    if (!_deck.isEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: SpacingConsts.medium),
                        decoration: BoxDecoration(
                          borderRadius: Spacing.circularBorderRadius,
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _deck.isEmpty || _isDrawing
                              ? null
                              : _drawCard,
                          icon: Icon(
                            Icons.auto_awesome,
                            color: _deck.isEmpty || _isDrawing
                                ? colors.textSecondary
                                : colors.background,
                          ),
                          label: Text(
                            'Kart Çek',
                            style: m16w700(context).copyWith(
                              color: _deck.isEmpty || _isDrawing
                                  ? colors.textSecondary
                                  : colors.background,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            disabledBackgroundColor: colors.surfaceSecondary,
                            disabledForegroundColor: colors.textSecondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpacingConsts.xxlarge,
                              vertical: SpacingConsts.medium,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: Spacing.circularBorderRadius,
                            ),
                            elevation: 8,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Spacing.mediumH,
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(
                    SpacingConsts.medium,
                    SpacingConsts.small,
                    SpacingConsts.medium,
                    SpacingConsts.medium,
                  ),
                  padding: Spacing.defaultPadding,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.surface.withOpacity(0.1),
                        colors.surface.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: Spacing.largeBorderRadius,
                    border: Border.all(
                      color: colors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.background.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark,
                            color: colors.primary,
                            size: 24,
                          ),
                          Spacing.xsmallW,
                            Text(
                            'Çekilen Kartlar',
                            style: m20w800(context).copyWith(
                              color: colors.primary,
                            ),
                          ),
                          Spacing.xsmallW,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: SpacingConsts.small,
                              vertical: SpacingConsts.tiny,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: Spacing.xsmallBorderRadius,
                            ),
                            child: Text(
                              '${_drawnCards.length}',
                              style: m16w700(context).copyWith(
                                color: colors.background,
                              ),
                              ),
                            ),
                        ],
                      ),
                      Spacing.mediumH,
                      Expanded(
                        child:
                            _drawnCards.isEmpty
                                ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.touch_app,
                                        color: colors.primary.withOpacity(0.5),
                                        size: 60,
                                      ),
                                      Spacing.mediumH,
                                      Text(
                                        'Henüz kart çekilmedi',
                                        style: m18w500(context).copyWith(
                                          color: colors.primary.withOpacity(
                                            0.7,
                                          ),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 150,
                                        childAspectRatio: 0.65,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                  itemCount: _drawnCards.length,
                                  itemBuilder: (context, index) {
                                    return _buildDrawnCard(
                                      context,
                                      _drawnCards[index],
                                      index,
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for mystical pattern on card backs
class MysticalPatternPainter extends CustomPainter {
  const MysticalPatternPainter({required this.colors});
  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = colors.primary.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw mystical circles
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        20.0 * i,
        paint,
      );
    }

    // Draw star pattern
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final angle = (i * 45) * pi / 180;
      final x = centerX + cos(angle) * 40;
      final y = centerY + sin(angle) * 40;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for sparkles background
class SparklesPainter extends CustomPainter {
  const SparklesPainter({required this.colors});

  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = colors.primary.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    final random = Random(42);
    for (var i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
