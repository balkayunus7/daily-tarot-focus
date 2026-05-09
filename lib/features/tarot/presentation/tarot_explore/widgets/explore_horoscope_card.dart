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
              itemBuilder:
                  (context, index) => _PeriodContainer(
                    sign: sign,
                    period: periods[index],
                  ),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                period.labelKey.tr(),
                style: m16w600(context).copyWith(color: colors.textOnPrimary),
              ),
              Sp.medium.heightBox,
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
          Sp.huge.widthBox,
          Sp.medium.widthBox,
          _MedallionStack(sign: sign),
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

class _MedallionStack extends StatelessWidget {
  const _MedallionStack({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    const all = ZodiacSign.values;
    final idx = all.indexOf(sign);
    final prev = all[(idx - 1 + 12) % 12];
    final next = all[(idx + 1) % 12];

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        _ZodiacMedallion(sign: prev, rotation: -0.3, offsetX: -52, diameter: 68, isPrimary: false),
        _ZodiacMedallion(sign: next, rotation: 0.3, offsetX: 52, diameter: 68, isPrimary: false),
        _ZodiacMedallion(sign: sign, rotation: 0, offsetX: 0, diameter: 96, isPrimary: true),
      ],
    );
  }
}

class _ZodiacMedallion extends StatelessWidget {
  const _ZodiacMedallion({
    required this.sign,
    required this.rotation,
    required this.offsetX,
    required this.diameter,
    required this.isPrimary,
  });

  final ZodiacSign sign;
  final double rotation;
  final double offsetX;
  final double diameter;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final d = diameter.r;
    final cardDark = Color.lerp(colors.primary, Colors.black, 0.72)!;
    final cardMid = Color.lerp(colors.primary, Colors.black, 0.42)!;

    return Transform.translate(
      offset: Offset(offsetX, 0),
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: d,
          height: d,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isPrimary
                      ? [colors.accent, colors.accent.withValues(alpha: 0.75)]
                      : [cardDark, cardMid],
            ),
            border: Border.all(
              color: colors.primary.withValues(alpha: isPrimary ? 0.65 : 0.35),
              width: isPrimary ? 1.2 : 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isPrimary ? 0.45 : 0.30),
                blurRadius: isPrimary ? 14 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              sign.svgPath,
              height: d * 0.45,
              width: d * 0.45,
              colorFilter: ColorFilter.mode(
                isPrimary ? colors.primary : colors.primary.withValues(alpha: 0.50),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
