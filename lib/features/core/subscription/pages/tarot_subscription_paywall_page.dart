import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/domain/purchases/subscription_period.dart';
import 'package:mobile_boilerplate/domain/purchases/subscription_plan.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/purchases/subscription_paywall_page.dart';

class TarotSubscriptionPaywallPage extends StatelessWidget {
  const TarotSubscriptionPaywallPage({super.key});

  PaywallPageTheme buildTheme(BuildContext context) {
    final colors = context.colors;

    return PaywallPageTheme(
      background: colors.background,
      surface: colors.surface,
      tableRowAltBackground: colors.background,
      proBadgeBackground: colors.primary,
      proBadgeForeground: colors.background,
      proColumnBackground: colors.primary.withValues(alpha: 0.08),
      borderColor: colors.borderSecondary,
      dividerColor: colors.border,
      textPrimary: colors.textPrimary,
      textSecondary: colors.textSecondary,
      checkColorFree: colors.textPrimary,
      checkColorPro: colors.primary,
      cardSelectedBackground: colors.primary,
      cardSelectedBorderColor: colors.textOnPrimary,
      cardBadgeBackground: colors.primary.withValues(alpha: 0.8),
      cardBadgeForeground: colors.background,
      buttonTextColor: colors.background,
      buttonColor: colors.primary.withValues(alpha: 0.8),
      freeColumnLabel: LocaleKeys.paywall_free.tr(),
      tableBgColor: colors.surface.withValues(alpha: 0.6),
    );
  }

  List<PaywallFeature> _features() => [
    PaywallFeature(
      label: LocaleKeys.paywall_daily_questions.tr(),
      freeText: '1',
      proText: '10',
    ),
    PaywallFeature(label: LocaleKeys.paywall_detailed_interpretation.tr()),
    PaywallFeature(
      label: LocaleKeys.paywall_personalized_daily_card.tr(),
    ),
    PaywallFeature(
      label: LocaleKeys.paywall_personalized_horoscope.tr(),
    ),
    PaywallFeature(label: LocaleKeys.paywall_unlimited_spread_journal.tr()),
  ];

  List<PaywallPackageBadge> _badges() => [
    PaywallPackageBadge(
      period: SubscriptionPeriod.month1,
      label: LocaleKeys.paywall_popular.tr(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SubscriptionPaywallPage(
      plan: SubscriptionPlan.premium,
      title: LocaleKeys.subscription_paywall_page_title.tr(),
      subtitle: LocaleKeys.subscription_paywall_page_subtitle.tr(),
      features: _features(),
      packageBadges: _badges(),
      theme: buildTheme(context),
      dismissDelay: const Duration(seconds: 3),
      headerImage: const CustomCacheNetworkImage(
        imageUrl: TarotAppAssets.paywallHttp,
      ),
    );
  }
}
