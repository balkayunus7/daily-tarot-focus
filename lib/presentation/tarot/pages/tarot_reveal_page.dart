import 'dart:async';
import 'dart:math' as math;
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';

part '../widgets/reveal/tarot_flip_card.dart';
part '../widgets/reveal/tarot_card_wheel.dart';
part '../widgets/reveal/tarot_card_item.dart';

// Constants
class _TarotRevealConstants {
  static const int totalCards = 50;
  static const double cardExtent = 130;
  static const double wheelDiameterRatio = 1.5;
  static const double wheelPerspective = 0.0008;
  static const double wheelSqueeze = 1.5;

  static const Duration entranceAnimationDuration = Duration(
    milliseconds: 1500,
  );
  static const Duration flipAnimationDuration = Duration(milliseconds: 800);
  static const Duration starsAnimationDuration = Duration(seconds: 2);
  static const Duration cardFlipDuration = Duration(milliseconds: 3000);
}

class _TarotRevealStateNotifier extends ChangeNotifier {
  bool _isCardSelected = false;

  bool get isCardSelected => _isCardSelected;

  void setCardSelected({required bool value}) {
    if (_isCardSelected != value) {
      _isCardSelected = value;
      notifyListeners();
    }
  }
}

class _TarotRevealStateInherited
    extends InheritedNotifier<_TarotRevealStateNotifier> {
  const _TarotRevealStateInherited({
    required super.notifier,
    required super.child,
  });

  static _TarotRevealStateInherited? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_TarotRevealStateInherited>();
  }
}

class TarotRevealPage extends StatefulWidget {
  const TarotRevealPage({super.key});

  @override
  State<TarotRevealPage> createState() => _TarotRevealPageState();
}

class _TarotRevealPageState extends State<TarotRevealPage>
    with TickerProviderStateMixin {
  late final _TarotRevealStateNotifier _stateNotifier;

  @override
  void initState() {
    super.initState();
    _stateNotifier = _TarotRevealStateNotifier();
    _stateNotifier.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _stateNotifier
      ..removeListener(_onStateChanged)
      ..dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCardSelected = _stateNotifier.isCardSelected;

    return Scaffold(
      body: _TarotRevealStateInherited(
        notifier: _stateNotifier,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(TarotAppAssets.background.path, fit: BoxFit.cover),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: isCardSelected ? 0.0 : 1.0,
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
            if (!isCardSelected) const TarotCardWheel(),
            if (isCardSelected) const TarotFlipCard(),
          ],
        ),
      ),
    );
  }
}
