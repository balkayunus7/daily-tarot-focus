part of '../pages/tarot_explore_page.dart';

class ExploreHoroscopeCard extends StatelessWidget {
  const ExploreHoroscopeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.userOrCrash != curr.userOrCrash,
      builder: (context, state) {
        final user = state.userOrCrash as TarotUser;
        final sign = user.zodiac;
        if (sign == null) return const SizedBox.shrink();

        return _HoroscopeCardBody(sign: sign);
      },
    );
  }
}

class _HoroscopeCardBody extends StatelessWidget {
  const _HoroscopeCardBody({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenHeight = context.suHeight;
    final cardHeight = screenHeight / 6;

    return ScalingContainer(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: cardHeight,
        padding: const EdgeInsets.only(left: 20, right: 12, top: 16, bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.gradientStart, colors.gradientEnd],
          ),
          borderRadius: Sp.large.radiusR,
          border: Border.all(color: colors.border, width: 0.5),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = context.suWidth;
            final buttonWidth = screenWidth * 0.28;
            final buttonHeight = buttonWidth * 0.32;

            return Stack(
              fit: StackFit.expand,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sign.localizedName.toUpperCase(),
                            style: m12w600(context).copyWith(
                              color: colors.textOnPrimary.withValues(alpha: 0.65),
                              letterSpacing: 1.3,
                            ),
                          ),
                          Sp.tiny.heightBox,
                          Text(
                            LocaleKeys.explore_page_horoscope_card_title.tr(),
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
                                textStyle: m12w600(context).copyWith(
                                  color: colors.textOnPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Sp.huge.widthBox,
                    Flexible(child: _MedallionStack(sign: sign)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
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
        _ZodiacMedallion(sign: prev, rotation: -0.3, offsetX: -56, diameter: 64, isPrimary: false),
        _ZodiacMedallion(sign: next, rotation: 0.3, offsetX: 56, diameter: 64, isPrimary: false),
        _ZodiacMedallion(sign: sign, rotation: 0, offsetX: 0, diameter: 90, isPrimary: true),
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
