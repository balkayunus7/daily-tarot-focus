import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _ink = Color(0xFF2A0F02);

  static const _slides = <_OnboardingSlide>[
    _OnboardingSlide(
      titleKey: 'onboarding_page.slide_planetary_title',
      subtitleKey: 'onboarding_page.slide_planetary_subtitle',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int page) {
    return _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onNext() async {
    if (_currentPage < _slides.length - 1) {
      await _goToPage(_currentPage + 1);
    } else {
      context.go(AppRoutes.registerStepRelationship);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;

    final colors = context.colors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 0.5, 1],
          colors: [
            colors.gradientStart,
            colors.gradientEnd,
            colors.background,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 0),
                child: _OnboardingHeader(
                  count: _slides.length,
                  currentIndex: _currentPage,
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    return _OnboardingStep(
                      index: index,
                      slide: _slides[index],
                      isLastPage: isLastPage,
                      onNext: _onNext,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.titleKey,
    required this.subtitleKey,
  });

  final String titleKey;
  final String subtitleKey;
}

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader({
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: Row(
        children: List.generate(count, (index) {
          final isFilled = index <= currentIndex;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 3.5.h,
              decoration: BoxDecoration(
                color:
                    isFilled
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({
    required this.index,
    required this.slide,
    required this.isLastPage,
    required this.onNext,
  });

  final int index;
  final _OnboardingSlide slide;
  final bool isLastPage;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 26.h),
      child: Column(
        children: [
          Expanded(
            flex: 57,
            child: _SceneFrame(
              index: index,
              slide: slide,
            ),
          ),
          Expanded(
            flex: 43,
            child: Column(
              children: [
                const Spacer(flex: 2),
                Text(
                  slide.titleKey.tr(),
                  textAlign: TextAlign.center,
                  style: m28w600(context).copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    height: 1.22,
                  ),
                ),
                Sp.small.heightBox,
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 318.w),
                  child: Text(
                    slide.subtitleKey.tr(),
                    textAlign: TextAlign.center,
                    style: m15w400(context).copyWith(
                      color: const Color(0xFF202020),
                      height: 1.55,
                    ),
                  ),
                ),
                const Spacer(flex: 5),
                FancyButton(
                  width: isLastPage ? 218.w : 156.w,
                  height: 54.h,
                  text:
                      '${isLastPage ? 'onboarding_page.start_button'.tr() : 'onboarding_page.next_button'.tr()} ->',
                  onTap: onNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SceneFrame extends StatelessWidget {
  const _SceneFrame({
    required this.index,
    required this.slide,
  });

  final int index;
  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: const Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(child: _SparkleField()),
              _PlanetaryScene(),
            ],
          ),
        );
      },
    );
  }
}

class _PlanetSpec {
  const _PlanetSpec(this.glyph, this.color, this.nameKey, this.meaningKey);

  final String glyph;
  final Color color;
  final String nameKey;
  final String meaningKey;
}

class _PlanetaryScene extends StatelessWidget {
  const _PlanetaryScene();

  static const _venus = _PlanetSpec(
    '♀',
    Color(0xFFE05A82),
    'planetary_page.planet_venus',
    'planetary_page.meaning_venus',
  );
  static const _sun = _PlanetSpec(
    '☉',
    Color(0xFFE8B85A),
    'planetary_page.planet_sun',
    'planetary_page.meaning_sun',
  );
  static const _mercury = _PlanetSpec(
    '☿',
    Color(0xFF82C4E8),
    'planetary_page.planet_mercury',
    'planetary_page.meaning_mercury',
  );
  static const _moon = _PlanetSpec(
    '☽',
    Color(0xFFB8C4D8),
    'planetary_page.planet_moon',
    'planetary_page.meaning_moon',
  );
  static const _jupiter = _PlanetSpec(
    '♃',
    Color(0xFF7BC67A),
    'planetary_page.planet_jupiter',
    'planetary_page.meaning_jupiter',
  );
  static const _saturn = _PlanetSpec(
    '♄',
    Color(0xFF9B8AC4),
    'planetary_page.planet_saturn',
    'planetary_page.meaning_saturn',
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, -0.04),
          child: Container(
            width: 248.w,
            height: 250.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFD0CCF0),
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(34.r),
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: 62.h,
          left: 2.w,
          right: 2.w,
          child: Column(
            children: [
              const _CurrentHourTile(planet: _venus),
              Transform.translate(
                offset: Offset(10.w, -8.h),
                child: const _PlanetHourTile(planet: _sun),
              ),
              Transform.translate(
                offset: Offset(-6.w, -16.h),
                child: const _PlanetHourTile(planet: _mercury),
              ),
            ],
          ),
        ),
        const _GlyphBubble(
          planet: _jupiter,
          alignment: Alignment(-0.42, 0.62),
          size: 50,
        ),
        const _GlyphBubble(
          planet: _moon,
          alignment: Alignment(0, 0.72),
          size: 74,
        ),
        const _GlyphBubble(
          planet: _saturn,
          alignment: Alignment(0.55, 0.56),
          size: 50,
        ),
      ],
    );
  }
}

class _CurrentHourTile extends StatelessWidget {
  const _CurrentHourTile({required this.planet});

  final _PlanetSpec planet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.colors.gradientStart, context.colors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _GlyphCircle(planet: planet, size: 42, filled: true),
          Sp.small.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'planetary_page.hour_of'.tr(args: [planet.nameKey.tr()]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: m13w700(
                    context,
                  ).copyWith(color: Colors.white, height: 1.1),
                ),
                SizedBox(height: 3.h),
                Text(
                  planet.meaningKey.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: m12w400(context).copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
          Sp.small.widthBox,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              'planetary_page.now'.tr(),
              style: m10w600(
                context,
              ).copyWith(color: _OnboardingPageState._ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanetHourTile extends StatelessWidget {
  const _PlanetHourTile({required this.planet});

  final _PlanetSpec planet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _GlyphCircle(planet: planet, size: 36),
          Sp.small.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planet.nameKey.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: m13w700(
                    context,
                  ).copyWith(color: Colors.black, height: 1.1),
                ),
                SizedBox(height: 3.h),
                Text(
                  planet.meaningKey.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: m12w400(
                    context,
                  ).copyWith(color: const Color(0xFF4B4B4B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlyphCircle extends StatelessWidget {
  const _GlyphCircle({
    required this.planet,
    required this.size,
    this.filled = false,
  });

  final _PlanetSpec planet;
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? Colors.white : planet.color.withValues(alpha: 0.16),
        border: Border.all(
          color:
              filled ? Colors.white : planet.color.withValues(alpha: 0.4),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        planet.glyph,
        style: TextStyle(
          fontSize: (size * 0.5).sp,
          height: 1,
          color: planet.color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _GlyphBubble extends StatelessWidget {
  const _GlyphBubble({
    required this.planet,
    required this.alignment,
    required this.size,
  });

  final _PlanetSpec planet;
  final Alignment alignment;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF7F3EF),
          border: Border.all(color: Colors.white, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          planet.glyph,
          style: TextStyle(
            fontSize: (size * 0.44).sp,
            height: 1,
            color: planet.color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SparkleField extends StatelessWidget {
  const _SparkleField();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(painter: _SparkleFieldPainter());
  }
}

class _SparkleFieldPainter extends CustomPainter {
  const _SparkleFieldPainter();

  static const _lavender = Color(0xFFE1D9F1);
  static const _lightPurple = Color(0xFFD0CCF0);
  static const _mutedLavender = Color(0xFFB8B5D0);

  static const _baseSparkles = <_Sparkle>[
    _Sparkle(.06, .30, 13, _lavender),
    _Sparkle(.92, .22, 15, Colors.white),
    _Sparkle(.79, .68, 12, _mutedLavender),
    _Sparkle(.22, .78, 10, Colors.white),
    _Sparkle(.55, .76, 7, _lightPurple),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final sparkle in _baseSparkles) {
      final paint =
          Paint()
            ..style = PaintingStyle.fill
            ..color = sparkle.color.withValues(alpha: .95);
      _drawFourPoint(
        canvas,
        Offset(sparkle.x * size.width, sparkle.y * size.height),
        sparkle.radius,
        paint,
      );
    }
  }

  void _drawFourPoint(Canvas canvas, Offset c, double r, Paint paint) {
    final path =
        Path()
          ..moveTo(c.dx, c.dy - r)
          ..cubicTo(
            c.dx + r * .18,
            c.dy - r * .24,
            c.dx + r * .24,
            c.dy - r * .18,
            c.dx + r,
            c.dy,
          )
          ..cubicTo(
            c.dx + r * .24,
            c.dy + r * .18,
            c.dx + r * .18,
            c.dy + r * .24,
            c.dx,
            c.dy + r,
          )
          ..cubicTo(
            c.dx - r * .18,
            c.dy + r * .24,
            c.dx - r * .24,
            c.dy + r * .18,
            c.dx - r,
            c.dy,
          )
          ..cubicTo(
            c.dx - r * .24,
            c.dy - r * .18,
            c.dx - r * .18,
            c.dy - r * .24,
            c.dx,
            c.dy - r,
          )
          ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparkleFieldPainter oldDelegate) => false;
}


class _Sparkle {
  const _Sparkle(this.x, this.y, this.radius, this.color);

  final double x;
  final double y;
  final double radius;
  final Color color;
}
