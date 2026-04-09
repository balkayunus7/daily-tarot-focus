import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/domain/purchases/subscription_plan.dart';
import 'package:mobile_boilerplate/presentation/purchases/subscription_paywall_page.dart';
import 'package:mobile_boilerplate/presentation/routing/route_arguments.dart';

class TarotSubscriptionPaywallPage extends StatelessWidget {
  const TarotSubscriptionPaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SubscriptionPaywallPage(
        params: SubscriptionPaywallPageParams(context, subsPlan: SubscriptionPlan.premium),
        headerImage: Image.asset(
          TarotAppAssets.paywall.path,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
