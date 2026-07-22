import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/widgets/spread_layout_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class TarotSpreadCardPickPage extends StatefulWidget {
  const TarotSpreadCardPickPage({super.key});

  @override
  State<TarotSpreadCardPickPage> createState() =>
      _TarotSpreadCardPickPageState();
}

class _TarotSpreadCardPickPageState extends State<TarotSpreadCardPickPage> {
  late final ValueNotifier<int> _selectedCardIndex;
  late final ValueNotifier<List<int>> _pickedIndexes;
  late final FixedExtentScrollController _wheelController;
  int _lastHapticCardIndex = -1;

  @override
  void initState() {
    super.initState();
    const initialCardIndex = CardSp.totalCards ~/ 2;
    _selectedCardIndex = ValueNotifier(initialCardIndex);
    _pickedIndexes = ValueNotifier(const []);
    _lastHapticCardIndex = initialCardIndex;
    _wheelController = FixedExtentScrollController(
      initialItem: initialCardIndex,
    );
  }

  @override
  void dispose() {
    _selectedCardIndex.dispose();
    _pickedIndexes.dispose();
    _wheelController.dispose();
    super.dispose();
  }

  Future<void> _handleCardScroll(int index) async {
    if (index != _lastHapticCardIndex) {
      _lastHapticCardIndex = index;
      await HapticFeedbackHelper.lightImpact();
    }
    _selectedCardIndex.value = index;
  }

  Future<void> _handleCardTap(int index, int requiredCount) async {
    final current = _pickedIndexes.value;
    if (current.contains(index)) {
      await HapticFeedbackHelper.lightImpact();
      _pickedIndexes.value =
          current.where((picked) => picked != index).toList();
      return;
    }

    if (current.length >= requiredCount) return;

    await HapticFeedbackHelper.mediumImpact();
    _pickedIndexes.value = [...current, index];
  }

  void _resetSelection() {
    _pickedIndexes.value = const [];
  }

  Future<void> _continueToLayout() async {
    await context.push(AppRoutes.tarotQuestionStep6);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: TarotAppBar(
        titleWidget: Column(
          children: [
            Text(
              LocaleKeys.tarot_question_card_pick_step_title.tr(),
              style: m18w700(context),
            ),
            Sp.tiny.heightBox,
            Text(
              LocaleKeys.tarot_question_step_5_of_6.tr(),
              style: m10w500(context).copyWith(
                color: colors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<TarotBloc, TarotState>(
        builder: (context, state) {
          final spread = state.selectedSpread;
          if (spread == null) return const SizedBox.shrink();

          final requiredCount = spread.positions.size;

          return Column(
            children: [
              _SpreadTitleBar(
                title: spread.title,
                onMoreTap:
                    () => showSpreadDetailsBottomSheet(context, spread: spread),
              ),
              Divider(
                height: 1,
                color: colors.textSecondary.withValues(alpha: 0.16),
              ),
              _SelectionHeader(
                requiredCount: requiredCount,
                pickedIndexes: _pickedIndexes,
              ),
              Expanded(
                child: _SpreadCardWheel(
                  requiredCount: requiredCount,
                  selectedCardIndex: _selectedCardIndex,
                  pickedIndexes: _pickedIndexes,
                  wheelController: _wheelController,
                  onScroll: _handleCardScroll,
                  onTap: _handleCardTap,
                ),
              ),
              _SelectionFooter(
                requiredCount: requiredCount,
                pickedIndexes: _pickedIndexes,
                onReset: _resetSelection,
                onContinue: _continueToLayout,
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
      padding: EdgeInsets.symmetric(
        horizontal: Sp.screen.w,
        vertical: Sp.small.h,
      ),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Sp.xsmall.widthBox,
          Expanded(
            child: Text(
              title,
              style: m14w600(
                context,
              ).copyWith(color: colors.textSecondary, letterSpacing: 0.2),
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
                Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: colors.primary,
                  size: 14.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionHeader extends StatelessWidget {
  const _SelectionHeader({
    required this.requiredCount,
    required this.pickedIndexes,
  });
  final int requiredCount;
  final ValueNotifier<List<int>> pickedIndexes;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Sp.screen.w,
        Sp.medium.h,
        Sp.screen.w,
        Sp.small.h,
      ),
      child: ValueListenableBuilder<List<int>>(
        valueListenable: pickedIndexes,
        builder: (context, selected, _) {
          final progress =
              requiredCount == 0 ? 0.0 : selected.length / requiredCount;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              borderRadius: Sp.medium.radiusR,
              border: Border.all(color: colors.primary.withValues(alpha: 0.14)),
            ),
            padding: Sp.medium.padAllR,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        LocaleKeys.tarot_question_choose_cards_subtitle.tr(),
                        style: m13w500(context).copyWith(
                          color: colors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ),
                    Sp.small.widthBox,
                    Text(
                      '${selected.length} / $requiredCount',
                      style: m16w700(context).copyWith(color: colors.primary),
                    ),
                  ],
                ),
                Sp.small.heightBox,
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 5.h,
                    backgroundColor: colors.border.withValues(alpha: 0.45),
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SpreadCardWheel extends StatelessWidget {
  const _SpreadCardWheel({
    required this.requiredCount,
    required this.selectedCardIndex,
    required this.pickedIndexes,
    required this.wheelController,
    required this.onScroll,
    required this.onTap,
  });

  final int requiredCount;
  final ValueNotifier<int> selectedCardIndex;
  final ValueNotifier<List<int>> pickedIndexes;
  final FixedExtentScrollController wheelController;
  final void Function(int index) onScroll;
  final void Function(int index, int requiredCount) onTap;

  @override
  Widget build(BuildContext context) {
    final cardWheelHeight = context.suHeight * 0.30;
    final screenWidth = context.suWidth;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: cardWheelHeight,
          child: RotatedBox(
            quarterTurns: 1,
            child: ValueListenableBuilder<int>(
              valueListenable: selectedCardIndex,
              builder: (context, selected, _) {
                return ValueListenableBuilder<List<int>>(
                  valueListenable: pickedIndexes,
                  builder: (context, picked, _) {
                    return ListWheelScrollView.useDelegate(
                      controller: wheelController,
                      itemExtent: CardSp.wheelItemExtent,
                      diameterRatio: CardSp.wheelDiameterRatio,
                      perspective: CardSp.wheelPerspective,
                      physics: const FixedExtentScrollPhysics(
                        parent: ClampingScrollPhysics(),
                      ),
                      squeeze: CardSp.wheelSqueeze,
                      clipBehavior: Clip.none,
                      onSelectedItemChanged: onScroll,
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: CardSp.totalCards,
                        builder: (context, index) {
                          return _SelectableDeckCard(
                            isCurrent: index == selected,
                            isPicked: picked.contains(index),
                            onTap: () => onTap(index, requiredCount),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        Sp.small.heightBox,
        CustomCacheNetworkImage(
          imageUrl: TarotAppAssets.arrowHttp,
          width: screenWidth * 0.16,
          height: screenWidth * 0.09,
          color: context.colors.primary,
        ),
        Sp.xsmall.heightBox,
        Text(
          LocaleKeys.tarot_question_scroll_and_tap_cards.tr(),
          style: m12w500(context).copyWith(color: context.colors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SelectableDeckCard extends StatelessWidget {
  const _SelectableDeckCard({
    required this.isCurrent,
    required this.isPicked,
    required this.onTap,
  });

  final bool isCurrent;
  final bool isPicked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cardWidth =
        isCurrent ? CardSp.selectedCardWidth : CardSp.unselectedCardWidth;
    final cardHeight =
        isCurrent ? CardSp.selectedCardHeight : CardSp.unselectedCardHeight;

    return RotatedBox(
      quarterTurns: -1,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: cardWidth,
            height: cardHeight,
            margin: (isCurrent ? 0.0 : 2.0).padYR,
            decoration: BoxDecoration(
              borderRadius: Sp.medium.radiusR,
              border: Border.all(
                color: isPicked ? colors.primary : colors.border,
                width: isPicked ? 2 : 1,
              ),
              boxShadow: isCurrent ? colors.primary.mediumShadow : [],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: Sp.medium.radiusR,
                  child: CustomCacheNetworkImage(
                    imageUrl: TarotAppAssets.cardBgHttp,
                    width: cardWidth,
                    height: cardHeight,
                    fit: BoxFit.fill,
                  ),
                ),
                if (isPicked)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.18),
                      borderRadius: Sp.medium.radiusR,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        margin: Sp.xsmall.padAllR,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: colors.textOnPrimary,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionFooter extends StatelessWidget {
  const _SelectionFooter({
    required this.requiredCount,
    required this.pickedIndexes,
    required this.onReset,
    required this.onContinue,
  });

  final int requiredCount;
  final ValueNotifier<List<int>> pickedIndexes;
  final VoidCallback onReset;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Sp.screen.w,
          Sp.small.h,
          Sp.screen.w,
          Sp.large.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<List<int>>(
              valueListenable: pickedIndexes,
              builder: (context, selected, _) {
                return Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: requiredCount,
                          separatorBuilder: (_, _) => Sp.xsmall.widthBox,
                          itemBuilder: (context, index) {
                            final isFilled = index < selected.length;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 34.w,
                              decoration: BoxDecoration(
                                color:
                                    isFilled
                                        ? colors.primary.withValues(alpha: 0.12)
                                        : colors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(7.r),
                                border: Border.all(
                                  color:
                                      isFilled ? colors.primary : colors.border,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${index + 1}',
                                style: m12w600(context).copyWith(
                                  color:
                                      isFilled
                                          ? colors.primary
                                          : colors.textDisabled,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Sp.small.widthBox,
                    ScalingContainer(
                      onTap: selected.isEmpty ? () {} : onReset,
                      child: Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: colors.surfaceSecondary,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.border),
                        ),
                        child: Icon(
                          Icons.refresh_rounded,
                          color:
                              selected.isEmpty
                                  ? colors.textDisabled
                                  : colors.primary,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Sp.medium.heightBox,
            ValueListenableBuilder<List<int>>(
              valueListenable: pickedIndexes,
              builder: (context, selected, _) {
                return FancyButton(
                  onTap: onContinue,
                  text: LocaleKeys.common_next.tr(),
                  isDisabled: selected.length < requiredCount,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
