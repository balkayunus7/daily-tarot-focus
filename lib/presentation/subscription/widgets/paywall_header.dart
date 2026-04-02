import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:flutter/material.dart';

class TarotPaywallHeader extends StatelessWidget {
  const TarotPaywallHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.3;
    return ClipRect(
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Image.asset(TarotAppAssets.paywall.path, fit: BoxFit.contain),
      ),
    );
  }
}
