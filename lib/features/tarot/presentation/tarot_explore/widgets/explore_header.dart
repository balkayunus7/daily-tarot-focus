part of '../pages/tarot_explore_page.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isNight = context.networkNow().isNight();
    final exploreMoonEnergy = LocaleKeys.explore_page_moon_energy.tr();
    final exploreDayEnergy = LocaleKeys.explore_page_day_energy.tr();
    final timeIcon = isNight ? Icons.nightlight_round : Icons.sunny;
    final timeGreeting = isNight ? exploreMoonEnergy : exploreDayEnergy;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current.isAuthenticated,
      builder: (context, state) {
        final user = state.userOrCrash as TarotUser;
        final userZodiac = user.zodiac;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(timeIcon, color: colors.primary, size: 28),
                Sp.xsmall.widthBox,
                Flexible(child: Text(timeGreeting, style: m16w700(context))),
              ],
            ),
            Sp.small.heightBox,
            if (userZodiac != null) ...[
              Text(
                LocaleKeys.explore_page_intuition_guide.tr(args: [userZodiac.localizedName]),
                style: m13w500(context).copyWith(color: colors.textSecondary),
              ),
            ],
          ],
        );
      },
    );
  }
}
