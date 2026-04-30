import 'dart:async';
import 'dart:math' as math;

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/scaleable_image.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_daily/page/tarot_daily_calendar_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/helpers/reveal_page_mixin.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/helpers/reveal_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';

part '../widgets/reveal_card_item.dart';
part '../widgets/reveal_card_wheel.dart';
part '../widgets/reveal_cooldown_view.dart';
part '../widgets/reveal_flip_card.dart';

class TarotRevealPage extends StatefulWidget {
  const TarotRevealPage({super.key});

  @override
  State<TarotRevealPage> createState() => _TarotRevealPageState();
}

class _TarotRevealPageState extends State<TarotRevealPage>
    with TickerProviderStateMixin, RevealPageStateMixin {
  late final ValueNotifier<Duration> _remaining;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _remaining = ValueNotifier(Duration.zero);
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _remaining.dispose();
    super.dispose();
  }

  DateTime? _getLastSavedAt(TarotState state) {
    final cards = state.dailyCardsOrEmpty.asList();
    if (cards.isEmpty) return null;
    return cards.first.savedAt;
  }

  bool _isOnCooldown(DateTime lastSavedAt) =>
      DateTime.now().isBefore(lastSavedAt.add(const Duration(hours: 24)));

  Duration _getRemainingDuration(DateTime lastSavedAt) {
    final diff = lastSavedAt.add(const Duration(hours: 24)).difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  void _startCooldown(Duration duration) {
    _cooldownTimer?.cancel();
    _remaining.value = duration;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = _remaining.value - const Duration(seconds: 1);
      if (next.isNegative) {
        _remaining.value = Duration.zero;
        _cooldownTimer?.cancel();
      } else {
        _remaining.value = next;
      }
    });
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TarotBloc, TarotState>(
      listenWhen: (prev, curr) => _getLastSavedAt(prev) != _getLastSavedAt(curr),
      listener: (context, state) {
        final lastSavedAt = _getLastSavedAt(state);
        if (lastSavedAt != null && _isOnCooldown(lastSavedAt)) {
          _startCooldown(_getRemainingDuration(lastSavedAt));
        } else {
          _cooldownTimer?.cancel();
          _remaining.value = Duration.zero;
        }
      },
      buildWhen: (prev, curr) => _getLastSavedAt(prev) != _getLastSavedAt(curr),
      builder: (context, state) {
        final lastSavedAt = _getLastSavedAt(state);
        final onCooldown = lastSavedAt != null && _isOnCooldown(lastSavedAt);

        if (onCooldown && _cooldownTimer == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _startCooldown(_getRemainingDuration(lastSavedAt));
          });
        }

        return RevealPageScope(
          state: this,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: TarotAppBar(
              trailingIcon: Icons.calendar_month_outlined,
              onIconTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const TarotDailyCalendarPage(),
                ),
              ),
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                const ScaleableImage(imagePath: TarotAppAssets.dailyPickBgHttp),
                Positioned(
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const CustomCacheNetworkImage(imageUrl: TarotAppAssets.dailyPickBgHttp),
                ),
                if (onCooldown)
                  ValueListenableBuilder<Duration>(
                    valueListenable: _remaining,
                    builder: (context, dur, child) =>
                        _RevealCooldownView(formatted: _formatDuration(dur)),
                  )
                else
                  ValueListenableBuilder<TarotCardModel?>(
                    valueListenable: selectedTarotCard,
                    builder: (context, value, child) {
                      final isCardSelected = this.isCardSelected;
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          AnimatedOpacity(
                            duration: CardSp.wheelAnimation,
                            opacity: isCardSelected ? 0.0 : 1.0,
                            child: SafeArea(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateTime.now()
                                          .toLocal()
                                          .dayMonthDay(Localizations.localeOf(context)),
                                      style: m28w600(context),
                                    ),
                                    Sp.medium.heightBox,
                                    Text(
                                      LocaleKeys.reveal_page_tap_to_pick.tr(),
                                      style: m14w500(context)
                                          .copyWith(color: context.colors.textSecondary),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
