part of '../pages/tarot_explore_page.dart';

class _GetProChip extends StatelessWidget {
  const _GetProChip();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: () => context.push(AppRoutes.subscriptionPaywall),
      child: Container(
        padding: Sp.medium.padSymR(h: 12, v: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [colors.gradientStart, colors.gradientEnd]),
          borderRadius: BorderRadius.circular(100),
          boxShadow: colors.primary.mediumShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              TarotAppAssets.crown.path,
              height: 14,
              width: 14,
              colorFilter: ColorFilter.mode(colors.textOnPrimary, BlendMode.srcIn),
            ),
            Sp.tiny.widthBox,
            Text(
              LocaleKeys.explore_page_get_pro.tr(),
              style: m12w600(context).copyWith(color: colors.textOnPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

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
        final isPremium = state.userOrCrash.isSubscribed(networkTime: context.networkNow());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(timeIcon, color: colors.primary, size: 28),
                Sp.xsmall.widthBox,
                Flexible(child: Text(timeGreeting, style: m16w700(context))),
                if (!isPremium) ...[
                  Sp.small.widthBox,
                  const _GetProChip(),
                ],
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
