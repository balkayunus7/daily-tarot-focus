import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/scaleable_image.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/helpers/reveal_page_mixin.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/helpers/reveal_page_scope.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/widgets/reveal_card_wheel.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/widgets/reveal_cooldown_view.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/widgets/reveal_flip_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotRevealPage extends StatefulWidget {
  const TarotRevealPage({super.key});

  @override
  State<TarotRevealPage> createState() => _TarotRevealPageState();
}

class _TarotRevealPageState extends State<TarotRevealPage>
    with TickerProviderStateMixin, RevealPageStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TarotBloc, TarotState>(
      listenWhen: (prev, curr) => getLastSavedAt(prev) != getLastSavedAt(curr),
      listener: (context, state) {
        final lastSavedAt = getLastSavedAt(state);
        if (lastSavedAt != null && isOnCooldown(lastSavedAt)) {
          startCooldown(getRemainingDuration(lastSavedAt));
        } else {
          cooldownTimer?.cancel();
          remaining.value = Duration.zero;
        }
      },
      buildWhen: (prev, curr) => getLastSavedAt(prev) != getLastSavedAt(curr),
      builder: (context, state) {
        final lastSavedAt = getLastSavedAt(state);
        final onCooldown = lastSavedAt != null && isOnCooldown(lastSavedAt);

        if (onCooldown && cooldownTimer == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) startCooldown(getRemainingDuration(lastSavedAt));
          });
        }

        return RevealPageScope(
          state: this,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: TarotAppBar(
              trailingIcon: Icons.calendar_month_outlined,
              onIconTap: () => context.push(AppRoutes.tarotDailyCalendar),
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                const ScaleableImage(imagePath: TarotAppAssets.dailyPickBgHttp),
                Positioned(
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const CustomCacheNetworkImage(
                    imageUrl: TarotAppAssets.dailyPickBgHttp,
                  ),
                ),
                if (onCooldown) ...[
                  const RevealCooldownView(),
                ] else ...[
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
                                      formattedRevealDate(
                                        DateTime.now().toLocal(),
                                        Localizations.localeOf(context),
                                      ),
                                      style: m28w600(context),
                                    ),
                                    Sp.medium.heightBox,
                                    Text(
                                      LocaleKeys.reveal_page_tap_to_pick.tr(),
                                      style: m14w500(
                                        context,
                                      ).copyWith(
                                        color: context.colors.textSecondary,
                                      ),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
