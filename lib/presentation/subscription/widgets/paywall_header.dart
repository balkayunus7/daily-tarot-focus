import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/spacing.dart';

/// Paywall sayfasının üst kısmında gösterilen tarot temalı header widget'ı.
class TarotPaywallHeader extends StatelessWidget {
  const TarotPaywallHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Spacing.xlarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.primary, colors.secondary, colors.accent],
              ),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }
}
