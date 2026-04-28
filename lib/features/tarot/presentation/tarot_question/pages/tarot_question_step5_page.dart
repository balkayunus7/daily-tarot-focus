import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/riffle_deck.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/spread_layout_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class TarotQuestionStep5Page extends StatefulWidget {
  const TarotQuestionStep5Page({super.key});

  @override
  State<TarotQuestionStep5Page> createState() => _TarotQuestionStep5PageState();
}

class _TarotQuestionStep5PageState extends State<TarotQuestionStep5Page>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _isAutoShuffle = ValueNotifier(false);
  final ValueNotifier<int> _shuffleTimeLeft = ValueNotifier(0);
  Timer? _autoShuffleTimer;

  @override
  void dispose() {
    _autoShuffleTimer?.cancel();
    _isAutoShuffle.dispose();
    _shuffleTimeLeft.dispose();
    super.dispose();
  }

  void _toggleAutoShuffle() {
    if (_isAutoShuffle.value) {
      _isAutoShuffle.value = false;
      _autoShuffleTimer?.cancel();
      _shuffleTimeLeft.value = 0;
    } else {
      _isAutoShuffle.value = true;
      _shuffleTimeLeft.value = 10;
      _autoShuffleTimer?.cancel();
      _autoShuffleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_shuffleTimeLeft.value > 1) {
          _shuffleTimeLeft.value--;
        } else {
          _isAutoShuffle.value = false;
          _shuffleTimeLeft.value = 0;
          timer.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: TarotAppBar(
        titleWidget: Column(
          children: [
            Text(LocaleKeys.tarot_shuffle_title.tr(), style: m16w700(context)),
            Sp.tiny.heightBox,
            Text(
              LocaleKeys.tarot_question_step_5_of_6.tr(),
              style: m10w500(context).copyWith(color: colors.textSecondary, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
      body: BlocBuilder<TarotBloc, TarotState>(
        builder: (context, state) {
          final spread = state.selectedSpread;
          if (spread == null) return const SizedBox.shrink();

          return Column(
            children: [
              _SpreadTitleBar(
                title: spread.title,
                onMoreTap: () async => showSpreadDetailsBottomSheet(context, spread: spread),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sp.screen.w,
                    vertical: Sp.small.h,
                  ),
                  child: Column(
                    children: [
                      _TipItem(
                        emoji: '🧘',
                        title: LocaleKeys.tarot_shuffle_tip_1_title.tr(),
                        description: LocaleKeys.tarot_shuffle_tip_1_desc.tr(),
                      ),
                      Sp.small.heightBox,
                      _TipItem(
                        emoji: '🃏',
                        title: LocaleKeys.tarot_shuffle_tip_2_title.tr(),
                        description: LocaleKeys.tarot_shuffle_tip_2_desc.tr(),
                      ),
                      Sp.small.heightBox,
                      _TipItem(
                        emoji: '✨',
                        title: LocaleKeys.tarot_shuffle_tip_3_title.tr(),
                        description: LocaleKeys.tarot_shuffle_tip_3_desc.tr(),
                      ),
                      Sp.xxlarge.heightBox,
                      RiffleDeck(isAutoShuffle: _isAutoShuffle),
                      Sp.xxlarge.heightBox,
                    ],
                  ),
                ),
              ),
              _BottomButtons(
                isAutoShuffle: _isAutoShuffle,
                shuffleTimeLeft: _shuffleTimeLeft,
                onToggleAutoShuffle: _toggleAutoShuffle,
                onFinish: () async {
                  await context.push(AppRoutes.tarotQuestionStep6);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SpreadTitleBar extends StatelessWidget {
  const _SpreadTitleBar({required this.title, required this.onMoreTap});

  final String title;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sp.screen.w, vertical: Sp.small.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
          ),
          Sp.xsmall.widthBox,
          Expanded(
            child: Text(
              title,
              style: m14w600(context).copyWith(color: colors.textSecondary, letterSpacing: 0.2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Sp.small.widthBox,
          ScalingContainer(
            onTap: onMoreTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.common_more.tr(),
                  style: m12w500(context).copyWith(color: colors.primary),
                ),
                Sp.tiny.widthBox,
                Icon(Icons.keyboard_arrow_right_rounded, color: colors.primary, size: 14.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({required this.emoji, required this.title, required this.description});

  final String emoji;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: TextStyle(fontSize: 18.sp)),
        Sp.small.widthBox,
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title ',
                  style: m14w700(context).copyWith(color: colors.textPrimary),
                ),
                TextSpan(
                  text: description,
                  style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons({
    required this.isAutoShuffle,
    required this.shuffleTimeLeft,
    required this.onToggleAutoShuffle,
    required this.onFinish,
  });

  final ValueNotifier<bool> isAutoShuffle;
  final ValueNotifier<int> shuffleTimeLeft;
  final VoidCallback onToggleAutoShuffle;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sp.screen.w, vertical: Sp.medium.h),
        child: Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: isAutoShuffle,
                builder:
                    (_, isAuto, _) => ScalingContainer(
                      onTap: onToggleAutoShuffle,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 52.h,
                        decoration: BoxDecoration(
                          color:
                              isAuto ? colors.primary.withValues(alpha: 0.10) : Colors.transparent,
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(
                            color: isAuto ? colors.primary : colors.border,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              LocaleKeys.tarot_shuffle_auto_toggle.tr(),
                              style: m12w600(context).copyWith(
                                color: isAuto ? colors.primary : colors.textSecondary,
                              ),
                            ),
                            ValueListenableBuilder<int>(
                              valueListenable: shuffleTimeLeft,
                              builder: (_, timeLeft, _) {
                                final timeText = timeLeft > 0 ? ' ($timeLeft s)' : '';
                                return Text(
                                  isAuto
                                      ? '${LocaleKeys.tarot_shuffle_auto_on.tr()}$timeText'
                                      : LocaleKeys.tarot_shuffle_auto_off.tr(),
                                  style: m10w400(context).copyWith(
                                    color: isAuto ? colors.primary : colors.textDisabled,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
              ),
            ),
            Sp.small.widthBox,
            Expanded(
              child: FancyButton(
                onTap: onFinish,
                text: LocaleKeys.tarot_shuffle_finish.tr(),
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
