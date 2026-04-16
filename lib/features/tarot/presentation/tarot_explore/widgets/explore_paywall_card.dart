part of '../pages/tarot_explore_page.dart';

class ExplorePaywallCard extends StatelessWidget {
  const ExplorePaywallCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: () => context.push(AppRoutes.subscriptionPaywall),
      child: Container(
        padding: Sp.large.padHVR(Sp.medium),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.gradientStart, colors.gradientEnd, colors.background],
          ),
          borderRadius: Sp.medium.radiusR,
          border: Border.all(color: colors.border),
          boxShadow: colors.primary.mediumShadow,
        ),
        child: Row(
          children: [
            const _PremiumIcon(),
            Sp.small.widthBox,
            const _PaywallTextContent(),
            const _PremiumButton(),
          ],
        ),
      ),
    );
  }
}

class _PremiumIcon extends StatelessWidget {
  const _PremiumIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.star_rounded, color: context.colors.accent, size: 28);
  }
}

class _PaywallTextContent extends StatelessWidget {
  const _PaywallTextContent();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.explore_page_go_premium.tr(),
            style: m16w600(context).copyWith(color: context.colors.textOnPrimary),
          ),
          Sp.tiny.heightBox,
          Text(
            LocaleKeys.explore_page_unlock_all_features.tr(),
            style: m11w500(context).copyWith(color: context.colors.textOnPrimary),
          ),
        ],
      ),
    );
  }
}

class _PremiumButton extends StatelessWidget {
  const _PremiumButton();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.suWidth;
    final buttonWidth = screenWidth * 0.22;
    final buttonHeight = buttonWidth * 0.4;

    return IgnorePointer(
      child: GlassButton(
        height: buttonHeight,
        width: buttonWidth,
        onTap: () {},
        buttonText: LocaleKeys.explore_page_get_pro.tr(),
        buttonTextStyle: m12w600(context).copyWith(color: context.colors.textOnPrimary),
      ),
    );
  }
}
