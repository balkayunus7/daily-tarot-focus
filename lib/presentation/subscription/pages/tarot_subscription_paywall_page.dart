import 'package:daily_tarot_focus/presentation/subscription/widgets/paywall_header.dart';
import 'package:daily_tarot_focus/presentation/subscription/widgets/paywall_privileges.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/domain/purchases/subscription_plan.dart';
import 'package:mobile_boilerplate/presentation/purchases/subscription_paywall_page.dart';
import 'package:mobile_boilerplate/presentation/routing/route_arguments.dart';

class TarotSubscriptionPaywallPage extends StatelessWidget {
  const TarotSubscriptionPaywallPage({this.params, super.key});
  final SubscriptionPaywallPageParams? params;

  @override
  Widget build(BuildContext context) {
    return SubscriptionPaywallPage(
      params: params ?? SubscriptionPaywallPageParams(context, subsPlan: SubscriptionPlan.premium),
      header: const TarotPaywallHeader(),
      privileges: const TarotPaywallPrivileges(),
    );
  }
}
