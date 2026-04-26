import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
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
      freeColumnLabel: 'ÜCRETSİZ',
      tableBgColor: colors.surface.withValues(alpha: 0.6),
    );
  }

  static const List<PaywallFeature> _features = [
    PaywallFeature(label: 'Günlük Tarot Çekimi', availableInFree: true),
    PaywallFeature(label: 'Günlük Soru Sorma', freeText: '2', proText: '10'),
    PaywallFeature(label: 'Aylık Özet ve Grafikler'),
    PaywallFeature(label: 'Detaylı ve Derin Yorumlama'),
  ];

  static const List<PaywallPackageBadge> _badges = [
    PaywallPackageBadge(
      period: SubscriptionPeriod.month1,
      label: 'Sık Tercih Edilen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SubscriptionPaywallPage(
      plan: SubscriptionPlan.premium,
      title: 'Ayrıcalıklı Deneyim',
      subtitle: 'Kaderinin tüm kapılarını arala',
      features: _features,
      packageBadges: _badges,
      theme: buildTheme(context),
      dismissDelay: const Duration(seconds: 3),
      headerImage: const CustomCacheNetworkImage(imageUrl: TarotAppAssets.paywallHttp),
    );
  }
}
