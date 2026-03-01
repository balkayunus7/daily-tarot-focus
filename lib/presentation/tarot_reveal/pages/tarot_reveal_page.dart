import 'dart:async';
import 'dart:math' as math;

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:daily_tarot_focus/presentation/tarot_reveal/helpers/reveal_page_mixin.dart';
import 'package:daily_tarot_focus/presentation/tarot_reveal/helpers/reveal_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';

part '../widgets/reveal_card_item.dart';
part '../widgets/reveal_card_wheel.dart';
part '../widgets/reveal_flip_card.dart';

class TarotRevealPage extends StatefulWidget {
  const TarotRevealPage({super.key});

  @override
  State<TarotRevealPage> createState() => _TarotRevealPageState();
}

class _TarotRevealPageState extends State<TarotRevealPage>
    with TickerProviderStateMixin, RevealPageStateMixin {
  @override
  Widget build(BuildContext context) {
    return RevealPageScope(
      state: this,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const TarotAppBar(),
        body: ValueListenableBuilder<TarotCard?>(
          valueListenable: selectedTarotCard,
          builder: (context, value, child) {
            final isCardSelected = this.isCardSelected;
            return Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(TarotAppAssets.dailyPickBg.path, fit: BoxFit.cover),
                ),
                AnimatedOpacity(
                  duration: SpacingConsts.wheelAnimationDuration,
                  opacity: isCardSelected ? 0.0 : 1.0,
                  child: SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateTime.now().toLocal().dayMonthDay(Localizations.localeOf(context)),
                            style: m28w600(context),
                          ),
                          Spacing.mediumH,
                          Text(
                            LocaleKeys.revealTapToPick.tr(),
                            style: m14w500(context).copyWith(color: context.colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isCardSelected) ...[
                  const RevealFlipCard(),
                ] else ...[
                  const RevealCardWheel(),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
