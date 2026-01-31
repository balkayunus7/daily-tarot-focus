part of '../pages/tarot_explore_page.dart';

class ExplorePaywallCard extends StatelessWidget {
  const ExplorePaywallCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: () async {},
      child: Container(
        padding: Spacing.hLargeVMediumPad,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.secondary, colors.accent],
          ),
          borderRadius: Spacing.defaultBorderRadius,
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: colors.primary.mediumShadow,
        ),
        child: const Row(
          children: [
            _PremiumIcon(),
            Spacing.smallW,
            _PaywallTextContent(),
            _PremiumButton(),
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
    return Icon(
      Icons.star_rounded,
      color: context.colors.textPrimary,
      size: 28,
    );
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
            LocaleKeys.exploreGoPremium.tr(),
            style: m18w700(context),
          ),
          Spacing.tinyH,
          Text(
            LocaleKeys.exploreUnlockAllFeatures.tr(),
            style: m12w500(context),
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
    final colors = context.colors;
    final screenWidth = Spacing.screenWidth(context);
    final buttonWidth = screenWidth * 0.25;
    final buttonHeight = buttonWidth * 0.4;

    return IgnorePointer(
      child: TarotButton(
        height: buttonHeight,
        width: buttonWidth,
        onTap: () {
          // TODO: Paywall sayfasına yönlendirme veya bottom sheet tetikleme
        },
        buttonText: LocaleKeys.exploreGetPro.tr(),
        bgColor: colors.textPrimary,
        buttonTextStyle: m14w700(context).copyWith(
          color: colors.primary,
        ),
      ),
    );
  }
}
