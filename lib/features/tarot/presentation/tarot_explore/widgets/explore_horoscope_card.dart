part of '../pages/tarot_explore_page.dart';

class ExploreHoroscopeCard extends StatefulWidget {
  const ExploreHoroscopeCard({super.key});

  @override
  State<ExploreHoroscopeCard> createState() => _ExploreHoroscopeCardState();
}

class _ExploreHoroscopeCardState extends State<ExploreHoroscopeCard> {
  late final PageController _controller;
  int _currentPage = 0;

  static const List<HoroscopePeriod> _periods = HoroscopePeriod.values;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final page = _controller.page?.round() ?? 0;
    if (page != _currentPage) setState(() => _currentPage = page);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _navigate(BuildContext context, ZodiacSign sign) async {
    await context.pushNamed<void>(
      AppRoutes.zodiacHoroscope,
      extra: ZodiacHoroscopeArgs(sign: sign, initialIndex: _currentPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.userOrCrash != curr.userOrCrash,
      builder: (context, state) {
        final user = state.userOrCrash as TarotUser;
        final sign = user.zodiac;
        if (sign == null) return const SizedBox.shrink();

        return _HoroscopeCardBody(
          sign: sign,
          controller: _controller,
          currentPage: _currentPage,
          periods: _periods,
          onTap: () => _navigate(context, sign),
        );
      },
    );
  }
}

class _HoroscopeCardBody extends StatelessWidget {
  const _HoroscopeCardBody({
    required this.sign,
    required this.controller,
    required this.currentPage,
    required this.periods,
    required this.onTap,
  });

  final ZodiacSign sign;
  final PageController controller;
  final int currentPage;
  final List<HoroscopePeriod> periods;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cardHeight = context.suHeight / 6;

    return ScalingContainer(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: cardHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.gradientStart, colors.gradientEnd],
          ),
          borderRadius: Sp.large.radiusR,
          border: Border.all(color: colors.border, width: 0.5),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            PageView.builder(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              itemCount: periods.length,
              itemBuilder: (context, index) => _PeriodContainer(sign: sign, period: periods[index]),
            ),
            Positioned(
              bottom: 10.h,
              left: 0,
              right: 0,
              child: Center(
                child: _DotsIndicator(count: periods.length, current: currentPage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodContainer extends StatelessWidget {
  const _PeriodContainer({required this.sign, required this.period});
  final ZodiacSign sign;
  final HoroscopePeriod period;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenWidth = context.suWidth;
    final buttonWidth = screenWidth * 0.28;
    final buttonHeight = buttonWidth * 0.32;

    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, bottom: 28),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period.labelKey.tr(),
                  style: m16w600(context).copyWith(color: colors.textOnPrimary),
                ),
                Sp.tiny.heightBox,
                Text(
                  period.exploreSubtitle,
                  style: m11w500(context).copyWith(
                    color: colors.textOnPrimary.withValues(alpha: 0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Sp.large.heightBox,
                IgnorePointer(
                  child: UnconstrainedBox(
                    alignment: Alignment.centerLeft,
                    child: FancyButton(
                      height: buttonHeight,
                      width: buttonWidth,
                      padding: Sp.small.padXR,
                      onTap: () {},
                      backgroundColor: colors.buttonOnGradient,
                      text: LocaleKeys.explore_page_horoscope_card_button.tr(),
                      textStyle: m12w600(context).copyWith(color: colors.textOnPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Sp.medium.widthBox,
          _PeriodVisual(sign: sign, period: period),
          Sp.medium.widthBox,
        ],
      ),
    );
  }
}

class _PeriodVisual extends StatelessWidget {
  const _PeriodVisual({required this.sign, required this.period});
  final ZodiacSign sign;
  final HoroscopePeriod period;

  @override
  Widget build(BuildContext context) {
    return switch (period) {
      HoroscopePeriod.daily => _DailyVisual(sign: sign),
      HoroscopePeriod.weekly => _WeeklyVisual(sign: sign),
      HoroscopePeriod.monthly => _MonthlyVisual(sign: sign),
    };
  }
}

/// Daily: single prominent zodiac medallion with a sun-glow ring.
class _DailyVisual extends StatelessWidget {
  const _DailyVisual({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final d = 86.r;

    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.accent,
            colors.accent.withValues(alpha: 0.6),
          ],
        ),
        border: Border.all(color: colors.accent.withValues(alpha: 0.8), width: 2),
        boxShadow: [
          BoxShadow(
            color: colors.accent.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          sign.svgPath,
          height: d * 0.48,
          width: d * 0.48,
          colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class _WeeklyVisual extends StatelessWidget {
  const _WeeklyVisual({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sideBg = Color.lerp(colors.accent, Colors.white, 0.15)!.withValues(alpha: 0.35);

    return SizedBox(
      width: 120.r,
      height: 86.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: _CrescentDisc(
              diameter: 58.r,
              color: sideBg,
              borderColor: colors.textOnPrimary.withValues(alpha: 0.35),
              child: Text('🌙', style: TextStyle(fontSize: 20.sp)),
            ),
          ),
          Positioned(
            right: 0,
            child: _CrescentDisc(
              diameter: 58.r,
              color: sideBg,
              borderColor: colors.textOnPrimary.withValues(alpha: 0.35),
              child: Text('⭐', style: TextStyle(fontSize: 20.sp)),
            ),
          ),
          _CrescentDisc(
            diameter: 72.r,
            color: colors.accent,
            borderColor: colors.accent.withValues(alpha: 0.7),
            child: SvgPicture.asset(
              sign.svgPath,
              height: 30.r,
              width: 30.r,
              colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}

class _CrescentDisc extends StatelessWidget {
  const _CrescentDisc({
    required this.diameter,
    required this.color,
    required this.borderColor,
    required this.child,
  });
  final double diameter;
  final Color color;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}

class _MonthlyVisual extends StatelessWidget {
  const _MonthlyVisual({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final d = 86.r;
    final darkBg = Color.lerp(colors.primary, Colors.black, 0.60)!;

    return SizedBox(
      width: d + 16.r,
      height: d + 16.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: d + 14.r,
            height: d + 14.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.accent.withValues(alpha: 0.25),
                width: 1.2,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 12.r,
            child: _OrbitDot(color: colors.accent.withValues(alpha: 0.8), size: 6.r),
          ),
          Positioned(
            bottom: 4.r,
            left: 4.r,
            child: _OrbitDot(color: colors.accent.withValues(alpha: 0.5), size: 5.r),
          ),
          Positioned(
            bottom: 2.r,
            right: 8.r,
            child: _OrbitDot(color: colors.accent.withValues(alpha: 0.6), size: 4.r),
          ),
          Container(
            width: d * 0.82,
            height: d * 0.82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [darkBg, colors.accent.withValues(alpha: 0.35)],
              ),
              border: Border.all(color: colors.accent.withValues(alpha: 0.5), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: colors.accent.withValues(alpha: 0.25),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                sign.svgPath,
                height: d * 0.38,
                width: d * 0.38,
                colorFilter: ColorFilter.mode(
                  colors.textOnPrimary.withValues(alpha: 0.9),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitDot extends StatelessWidget {
  const _OrbitDot({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 4),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          width: isActive ? 14.w : 6.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: colors.textOnPrimary.withValues(alpha: isActive ? 0.9 : 0.35),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
