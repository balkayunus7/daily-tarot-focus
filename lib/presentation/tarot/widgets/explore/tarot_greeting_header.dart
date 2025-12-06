part of '../../pages/tarot_explore_page.dart';

class TarotGreetingHeader extends StatelessWidget {
  const TarotGreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final user = context.read<AuthCubit>().state.userOrCrash as TarotUser;
    final userZodiac = user.zodiac;
    final isNight = DateTime.now().isNight();
    final timeGreeting =
        !isNight
            ? 'Günün enerjisi seninle.'
            : "Ay'ın gizemli enerjisi seninle.";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.sunny,
              color: colors.primary,
              size: 28,
            ),
            Spacing.xsmallW,
            Text(
              timeGreeting,
              style: m18w700(context),
            ),
          ],
        ),
        Spacing.smallH,
        Text(
          'Sevgili ${userZodiac?.value}, sezgilerinin sesi yol göstersin.',
          style: m16w600(context).copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
