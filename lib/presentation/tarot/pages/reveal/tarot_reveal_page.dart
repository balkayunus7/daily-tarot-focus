import 'dart:async';
import 'dart:math' as math;
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_datas.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';

part '../../widgets/reveal/tarot_card_item.dart';
part '../../widgets/reveal/tarot_card_wheel.dart';
part '../../widgets/reveal/tarot_flip_card.dart';

class TarotRevealPage extends StatefulWidget {
  const TarotRevealPage({super.key});

  @override
  State<TarotRevealPage> createState() => _TarotRevealPageState();
}

class _TarotRevealPageState extends State<TarotRevealPage>
    with TickerProviderStateMixin {
  bool _isCardSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const TarotAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(TarotAppAssets.background.path, fit: BoxFit.cover),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: _isCardSelected ? 0.0 : 1.0,
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateTime.now().toLocal().dayMonthDay(
                        Localizations.localeOf(context),
                      ),
                      style: m28w600(context),
                    ),
                    Spacing.mediumH,
                    Text(
                      'Tap to pick your card',
                      style: m14w500(
                        context,
                      ).copyWith(color: context.colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!_isCardSelected)
            TarotCardWheel(
              onCardSelected: () {
                setState(() {
                  _isCardSelected = true;
                });
              },
            ),
          if (_isCardSelected) const TarotFlipCard(),
        ],
      ),
    );
  }
}
