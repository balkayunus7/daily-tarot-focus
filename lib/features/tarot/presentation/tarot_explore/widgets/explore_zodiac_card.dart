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
          title: 'Learn Horoscope',
          imageWidget: ZodiacIllustration(sign: sign),
          onTap: () => context.push(AppRoutes.tarotZodiacDetail),
        );
      },
    );
  }
}
