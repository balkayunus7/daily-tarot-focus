import 'dart:math' as math;

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
      primaryAsset: 'assets/svg/moon-stars.svg',
      supportAssets: [],
    ),
    _OnboardingSlide(
      titleKey: 'onboarding_page.slide1_title',
      subtitleKey: 'onboarding_page.slide1_subtitle',
      primaryAsset: 'assets/strength.webp',
      supportAssets: [
        'assets/ace_of_cups.webp',
        'assets/ace_of_wands.webp',
        'assets/ace_of_pentacles.webp',
        'assets/temperance.webp',
        'assets/judgement.webp',
      ],
    ),
    _OnboardingSlide(
      titleKey: 'onboarding_page.slide2_title',
      subtitleKey: 'onboarding_page.slide2_subtitle',
      primaryAsset: 'assets/svg/moon-stars.svg',
      supportAssets: [
        'assets/svg/zodiac-leo.svg',
        'assets/svg/zodiac-pisces.svg',
        'assets/svg/zodiac-libra.svg',
        'assets/svg/zodiac-scorpio.svg',
      ],
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
    required this.primaryAsset,
    required this.supportAssets,
  });

  final String titleKey;
  final String subtitleKey;
  final String primaryAsset;
  final List<String> supportAssets;
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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(child: _SparkleField(enhanced: index >= 1)),
              if (index == 0)
                const _PlanetaryScene()
              else if (index == 1)
                _OrbitScene(slide: slide)
              else
                _PlannerScene(slide: slide),
            ],
          ),
        );
      },
    );
  }
}

class _OrbitScene extends StatelessWidget {
  const _OrbitScene({required this.slide});

  final _OnboardingSlide slide;

  static const _pillAlignment = Alignment(0, 0.18);

  @override
  Widget build(BuildContext context) {
    final cardAssets = [slide.primaryAsset, ...slide.supportAssets];
    final cards = <_CardSpec>[
      _CardSpec(cardAssets[0], const Alignment(-0.38, -0.55), 82),
      _CardSpec(cardAssets[1], const Alignment(0.55, -0.32), 66),
      _CardSpec(cardAssets[2], const Alignment(-0.92, 0.28), 58),
      _CardSpec(cardAssets[3], const Alignment(0.9, 0.3), 60),
      _CardSpec(cardAssets[4], const Alignment(0.22, 0.66), 60),
      _CardSpec(cardAssets[5], const Alignment(-0.98, -0.05), 50),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _ConnectingArrowsPainter(
              cards: cards,
              pillAlignment: _pillAlignment,
              pillSize: Size(190.w, 40.h),
            ),
          ),
        ),
        for (final card in cards)
          _CardBubble(
            asset: card.asset,
            alignment: card.alignment,
            size: card.size,
          ),
        Align(
          alignment: _pillAlignment,
          child: _LabelPill(
            asset: 'assets/svg/card.svg',
            label: slide.titleKey.tr(),
          ),
        ),
      ],
    );
  }
}

class _CardSpec {
  const _CardSpec(this.asset, this.alignment, this.size);

  final String asset;
  final Alignment alignment;
  final double size;
}

class _PlannerScene extends StatelessWidget {
  const _PlannerScene({required this.slide});

  final _OnboardingSlide slide;

  static const _lavenderTag = Color(0xFFE1D9F1);
  static const _mintTag = Color(0xFFD5EBE6);

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
          top: 70.h,
          left: 2.w,
          right: 2.w,
          child: Column(
            children: [
              _TaskTile(
                asset: 'assets/svg/tarot.svg',
                title: 'onboarding_page.step_reader_title'.tr(),
                subtitle: 'onboarding_page.step_reader_sub'.tr(),
                tag: '1',
                tagColor: _lavenderTag,
              ),
              Transform.translate(
                offset: Offset(10.w, -8.h),
                child: _TaskTile(
                  asset: 'assets/svg/cards-three.svg',
                  title: 'onboarding_page.step_spread_title'.tr(),
                  subtitle: 'onboarding_page.step_spread_sub'.tr(),
                  tag: '2',
                  tagColor: _mintTag,
                  compact: true,
                ),
              ),
              Transform.translate(
                offset: Offset(0, -16.h),
                child: _MiniInput(
                  label: 'onboarding_page.step_cards_title'.tr(),
                ),
              ),
            ],
          ),
        ),
        _AssetBubble(
          asset: slide.supportAssets[2],
          alignment: const Alignment(-0.42, 0.62),
          size: 50,
        ),
        _AssetBubble(
          asset: slide.primaryAsset,
          alignment: const Alignment(0, 0.7),
          size: 78,
        ),
        _AssetBubble(
          asset: slide.supportAssets[3],
          alignment: const Alignment(0.55, 0.56),
          size: 50,
        ),
      ],
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

class _AssetBubble extends StatelessWidget {
  const _AssetBubble({
    required this.asset,
    required this.alignment,
    required this.size,
  });

  final String asset;
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
        padding: EdgeInsets.all((size * 0.23).r),
        child: _OnboardingAsset(asset: asset),
      ),
    );
  }
}

class _CardBubble extends StatelessWidget {
  const _CardBubble({
    required this.asset,
    required this.alignment,
    required this.size,
  });

  final String asset;
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
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: ClipOval(
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        ),
      ),
    );
  }
}

class _AssetCircle extends StatelessWidget {
  const _AssetCircle({
    required this.asset,
    required this.size,
  });

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF7F3EF),
        border: Border.all(color: Colors.white, width: 2),
      ),
      padding: EdgeInsets.all((size * 0.23).r),
      child: _OnboardingAsset(asset: asset),
    );
  }
}

class _LabelPill extends StatelessWidget {
  const _LabelPill({
    required this.asset,
    required this.label,
  });

  final String asset;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 200.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE7A969).withValues(alpha: 0.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22.r,
            height: 22.r,
            decoration: const BoxDecoration(
              color: _OnboardingPageState._ink,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(5.r),
            child: _OnboardingAsset(asset: asset, color: Colors.white),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: m12w600(context).copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    this.compact = false,
  });

  final String asset;
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 300.w : 330.w,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: compact ? 12.h : 14.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _AssetCircle(asset: asset, size: compact ? 36 : 42),
          Sp.small.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: m13w700(
                    context,
                  ).copyWith(color: Colors.black, height: 1.1),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: m12w400(
                    context,
                  ).copyWith(color: const Color(0xFF4B4B4B)),
                ),
              ],
            ),
          ),
          Sp.small.widthBox,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              tag,
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

class _MiniInput extends StatelessWidget {
  const _MiniInput({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 214.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 17.r,
            height: 17.r,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF6BA3B5), width: 1.8),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Sp.small.widthBox,
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: m12w500(context).copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingAsset extends StatelessWidget {
  const _OnboardingAsset({
    required this.asset,
    this.color = _OnboardingPageState._ink,
  });

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (asset.endsWith('.svg')) {
      return SvgPicture.asset(
        asset,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return Image.asset(asset, fit: BoxFit.cover, gaplessPlayback: true);
  }
}

class _SparkleField extends StatelessWidget {
  const _SparkleField({this.enhanced = false});

  final bool enhanced;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _SparkleFieldPainter(enhanced: enhanced));
  }
}

class _SparkleFieldPainter extends CustomPainter {
  const _SparkleFieldPainter({required this.enhanced});

  final bool enhanced;

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

  static const _extraSparkles = <_Sparkle>[
    _Sparkle(.14, .08, 9, Colors.white),
    _Sparkle(.32, .04, 6, _lavender),
    _Sparkle(.70, .03, 11, Colors.white),
    _Sparkle(.46, .14, 5, _lightPurple),
    _Sparkle(.04, .58, 7, Colors.white),
    _Sparkle(.96, .50, 9, _lavender),
    _Sparkle(.40, .42, 5, Colors.white),
    _Sparkle(.60, .48, 6, _lightPurple),
    _Sparkle(.10, .92, 8, Colors.white),
    _Sparkle(.86, .92, 7, _lavender),
    _Sparkle(.50, .98, 6, Colors.white),
  ];

  static const _moons = <_Moon>[
    _Moon(.18, .18, 11, Colors.white),
    _Moon(.84, .82, 9, _lavender),
    _Moon(.92, .12, 8, _lightPurple),
  ];

  static const _sixPoints = <_Sparkle>[
    _Sparkle(.50, .08, 8, Colors.white),
    _Sparkle(.08, .44, 7, _lavender),
    _Sparkle(.90, .38, 6, Colors.white),
    _Sparkle(.30, .92, 7, _lightPurple),
  ];

  static const _dust = <Offset>[
    Offset(.20, .20),
    Offset(.78, .14),
    Offset(.34, .30),
    Offset(.64, .26),
    Offset(.12, .64),
    Offset(.88, .60),
    Offset(.26, .50),
    Offset(.74, .54),
    Offset(.18, .86),
    Offset(.82, .88),
    Offset(.44, .88),
    Offset(.56, .92),
    Offset(.40, .58),
    Offset(.62, .62),
    Offset(.04, .36),
    Offset(.96, .28),
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

    if (!enhanced) return;

    for (final sparkle in _extraSparkles) {
      final paint =
          Paint()
            ..style = PaintingStyle.fill
            ..color = sparkle.color.withValues(alpha: .92);
      _drawFourPoint(
        canvas,
        Offset(sparkle.x * size.width, sparkle.y * size.height),
        sparkle.radius,
        paint,
      );
    }

    for (final star in _sixPoints) {
      final paint =
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4
            ..strokeCap = StrokeCap.round
            ..color = star.color.withValues(alpha: .88);
      _drawSixPoint(
        canvas,
        Offset(star.x * size.width, star.y * size.height),
        star.radius,
        paint,
      );
    }

    for (final moon in _moons) {
      _drawCrescent(
        canvas,
        Offset(moon.x * size.width, moon.y * size.height),
        moon.radius,
        moon.color,
      );
    }

    final dustPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white.withValues(alpha: .85);
    for (final p in _dust) {
      canvas.drawCircle(
        Offset(p.dx * size.width, p.dy * size.height),
        1.6,
        dustPaint,
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

  void _drawSixPoint(Canvas canvas, Offset c, double r, Paint paint) {
    for (var i = 0; i < 3; i++) {
      final angle = math.pi / 3 * i;
      final dx = math.cos(angle) * r;
      final dy = math.sin(angle) * r;
      canvas.drawLine(
        Offset(c.dx - dx, c.dy - dy),
        Offset(c.dx + dx, c.dy + dy),
        paint,
      );
    }
  }

  void _drawCrescent(Canvas canvas, Offset c, double r, Color color) {
    final outer = Path()..addOval(Rect.fromCircle(center: c, radius: r));
    final inner =
        Path()..addOval(
          Rect.fromCircle(
            center: Offset(c.dx + r * 0.42, c.dy - r * 0.05),
            radius: r * 0.92,
          ),
        );
    final crescent = Path.combine(PathOperation.difference, outer, inner);
    final paint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = color.withValues(alpha: .9);
    canvas.drawPath(crescent, paint);
  }

  @override
  bool shouldRepaint(_SparkleFieldPainter oldDelegate) =>
      oldDelegate.enhanced != enhanced;
}

class _Moon {
  const _Moon(this.x, this.y, this.radius, this.color);

  final double x;
  final double y;
  final double radius;
  final Color color;
}

class _ConnectingArrowsPainter extends CustomPainter {
  const _ConnectingArrowsPainter({
    required this.cards,
    required this.pillAlignment,
    required this.pillSize,
  });

  final List<_CardSpec> cards;
  final Alignment pillAlignment;
  final Size pillSize;

  static const _arrowColor = Color(0xFFFFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    final pillCenter = Offset(
      size.width / 2 + pillAlignment.x * (size.width - pillSize.width) / 2,
      size.height / 2 + pillAlignment.y * (size.height - pillSize.height) / 2,
    );
    final pillRx = pillSize.width / 2;
    final pillRy = pillSize.height / 2;

    final strokePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 2
          ..color = _arrowColor.withValues(alpha: 0.7);

    final fillPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = _arrowColor.withValues(alpha: 0.85);

    for (var i = 0; i < cards.length; i++) {
      final card = cards[i];
      final cardSize = card.size.r;
      final cardCenter = Offset(
        size.width / 2 + card.alignment.x * (size.width - cardSize) / 2,
        size.height / 2 + card.alignment.y * (size.height - cardSize) / 2,
      );

      final dx = pillCenter.dx - cardCenter.dx;
      final dy = pillCenter.dy - cardCenter.dy;
      final dist = math.sqrt(dx * dx + dy * dy);
      if (dist < 1) continue;
      final ux = dx / dist;
      final uy = dy / dist;

      final startMargin = cardSize / 2 + 6;
      final start = Offset(
        cardCenter.dx + ux * startMargin,
        cardCenter.dy + uy * startMargin,
      );

      final pillReach =
          1 /
          math.sqrt(
            (ux * ux) / (pillRx * pillRx) + (uy * uy) / (pillRy * pillRy),
          );
      final endMargin = pillReach + 4;
      final end = Offset(
        pillCenter.dx - ux * endMargin,
        pillCenter.dy - uy * endMargin,
      );

      final perpX = -uy;
      final perpY = ux;
      final curveSide = i.isEven ? 1.0 : -1.0;
      final curveAmount = math.min<double>(28, dist * 0.18) * curveSide;
      final mid = Offset(
        (start.dx + end.dx) / 2 + perpX * curveAmount,
        (start.dy + end.dy) / 2 + perpY * curveAmount,
      );

      final path =
          Path()
            ..moveTo(start.dx, start.dy)
            ..quadraticBezierTo(mid.dx, mid.dy, end.dx, end.dy);
      canvas.drawPath(path, strokePaint);

      final tangent = Offset(end.dx - mid.dx, end.dy - mid.dy);
      final tLen = tangent.distance;
      if (tLen > 0.001) {
        final tx = tangent.dx / tLen;
        final ty = tangent.dy / tLen;
        const arrowLen = 8.0;
        const arrowHalf = 4.5;
        final base = Offset(end.dx - tx * arrowLen, end.dy - ty * arrowLen);
        final left = Offset(
          base.dx + -ty * arrowHalf,
          base.dy + tx * arrowHalf,
        );
        final right = Offset(
          base.dx - -ty * arrowHalf,
          base.dy - tx * arrowHalf,
        );
        final head =
            Path()
              ..moveTo(end.dx, end.dy)
              ..lineTo(left.dx, left.dy)
              ..lineTo(right.dx, right.dy)
              ..close();
        canvas.drawPath(head, fillPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_ConnectingArrowsPainter oldDelegate) =>
      oldDelegate.cards != cards ||
      oldDelegate.pillAlignment != pillAlignment ||
      oldDelegate.pillSize != pillSize;
}

class _Sparkle {
  const _Sparkle(this.x, this.y, this.radius, this.color);

  final double x;
  final double y;
  final double radius;
  final Color color;
}
