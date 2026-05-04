part of '../pages/tarot_explore_page.dart';

class ExploreZodiacCard extends StatelessWidget {
  const ExploreZodiacCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.userOrCrash != curr.userOrCrash,
      builder: (context, state) {
        final user = state.userOrCrash as TarotUser;
        final sign = user.zodiac;
        if (sign == null) return const SizedBox.shrink();
        return ExploreFeatureCard(
          title: sign.localizedName,
          imageWidget: _ZodiacIllustration(sign: sign),
          onTap: () => context.push(AppRoutes.tarotZodiacDetail),
        );
      },
    );
  }
}

class _ZodiacIllustration extends StatelessWidget {
  const _ZodiacIllustration({required this.sign});

  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.secondary, colors.primary],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(top: 8, left: 14, child: _Sparkle(size: 2.5, opacity: 0.7)),
          const Positioned(top: 22, right: 18, child: _Sparkle(size: 1.5, opacity: 0.6)),
          const Positioned(bottom: 16, right: 12, child: _Sparkle(size: 2, opacity: 0.8)),
          const Positioned(bottom: 24, left: 10, child: _Sparkle(size: 1.5, opacity: 0.5)),
          const Positioned(top: 10, right: 34, child: _Sparkle(size: 1.5, opacity: 0.55)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  sign.svgPath,
                  width: 36.w,
                  height: 36.w,
                  colorFilter: ColorFilter.mode(colors.textOnPrimary, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
