import 'dart:async';
import 'dart:math' as math;

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reading_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/spread_layout_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

// Virtual canvas constants — logical pixels inside the FittedBox canvas.
// ScreenUtil (.w/.h) must NOT be mixed in here; FittedBox handles real-screen scaling.
const double _kCardW = 100;
const double _kCardH = 165;
const double _kGap = 20;
const double _kBadge = 28;
const double _kBadgeOverhang = _kBadge / 2;

class TarotQuestionStep6Page extends StatefulWidget {
  const TarotQuestionStep6Page({super.key});

  @override
  State<TarotQuestionStep6Page> createState() => _TarotQuestionStep6PageState();
}

class _TarotQuestionStep6PageState extends State<TarotQuestionStep6Page> {
  final ValueNotifier<bool> _isReadingReady = ValueNotifier(false);

  @override
  void dispose() {
    _isReadingReady.dispose();
    super.dispose();
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
              LocaleKeys.tarot_question_step_4_of_4.tr(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SpreadTitleBar(
                title: spread.title,
                onMoreTap: () async => showSpreadDetailsBottomSheet(context, spread: spread),
              ),
              Divider(height: 1, color: colors.textSecondary.withValues(alpha: 0.2)),
              Padding(
                padding: Sp.medium.padSymR(h: Sp.large, v: Sp.xsmall),
                child: Row(
                  children: [
                    Iconify(
                      Mdi.question_mark_circle,
                      color: colors.primary,
                      size: 16.w,
                    ),
                    Sp.tiny.widthBox,
                    Expanded(
                      child: Text(
                        LocaleKeys.tarot_question_step6_ready_to_open.tr(),
                        style: m11w500(context).copyWith(
                          color: colors.textSecondary.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: _InteractiveSpreadLayout(
                    positions: spread.positions.asList(),
                    allCards: state.allCardsOrEmpty.asList(),
                    onAllCardsFlipped: (cards) {
                      context.read<TarotBloc>().addSetReadingCards(cards: cards);
                    },
                    isReadingReadyNotifier: _isReadingReady,
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sp.screen.w, vertical: Sp.large.h),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isReadingReady,
                    builder: (context, isReady, _) {
                      return FancyButton(
                        onTap: () {},
                        text: LocaleKeys.tarot_question_step6_start_reading.tr(),
                        isDisabled: !isReady,
                      );
                    },
                  ),
                ),
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

class _InteractiveSpreadLayout extends StatefulWidget {
  const _InteractiveSpreadLayout({
    required this.positions,
    required this.allCards,
    required this.onAllCardsFlipped,
    required this.isReadingReadyNotifier,
  });

  final List<TarotSpreadPositionModel> positions;
  final List<TarotCardModel> allCards;
  final void Function(List<TarotSelectedReadingCard>) onAllCardsFlipped;
  final ValueNotifier<bool> isReadingReadyNotifier;

  @override
  State<_InteractiveSpreadLayout> createState() => _InteractiveSpreadLayoutState();
}

class _InteractiveSpreadLayoutState extends State<_InteractiveSpreadLayout>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;

  // keyed by TarotSpreadPositionModel.index
  final Map<int, AnimationController> _flipControllers = {};
  final Map<int, String> _assignedCardIds = {};
  final Map<int, bool> _reversedFlags = {};

  bool _allFlippedNotified = false;

  @override
  void initState() {
    super.initState();
    final count = widget.positions.length;
    _entryController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 + (count > 0 ? (count - 1) * 150 : 0)),
    );
    unawaited(_entryController.forward());

    for (final pos in widget.positions) {
      _flipControllers[pos.index] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    for (final c in _flipControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onCardTap(int positionIndex, TarotSpreadPositionModel position) {
    if (widget.allCards.isEmpty) return;

    final usedIds =
        _assignedCardIds.entries.where((e) => e.key != positionIndex).map((e) => e.value).toSet();

    var pool = widget.allCards.where((c) => !usedIds.contains(c.id)).toList();
    if (pool.isEmpty) pool = List.of(widget.allCards);

    final currentId = _assignedCardIds[positionIndex];
    if (currentId != null && pool.length > 1) {
      pool = pool.where((c) => c.id != currentId).toList();
    }

    pool.shuffle();
    final picked = pool.first;
    final isReversed = math.Random().nextBool();

    setState(() {
      _assignedCardIds[positionIndex] = picked.id;
      _reversedFlags[positionIndex] = isReversed;
      if (_allFlippedNotified) {
        _allFlippedNotified = false;
        widget.isReadingReadyNotifier.value = false;
      }
    });

    unawaited(_flipControllers[positionIndex]?.forward(from: 0));

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAllFlipped());
  }

  void _checkAllFlipped() {
    if (_allFlippedNotified) return;
    if (_assignedCardIds.length < widget.positions.length) return;

    final cards =
        widget.positions.map((pos) {
          final cardId = _assignedCardIds[pos.index]!;
          final card = widget.allCards.firstWhere((c) => c.id == cardId);
          return TarotSelectedReadingCard(
            positionIndex: pos.index,
            card: card,
            position: pos,
            isReversed: _reversedFlags[pos.index] ?? false,
          );
        }).toList();

    _allFlippedNotified = true;
    widget.isReadingReadyNotifier.value = true;
    widget.onAllCardsFlipped(cards);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.positions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sp.small.w, vertical: Sp.medium.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxRow = widget.positions.map((p) => p.row).reduce((a, b) => a > b ? a : b).ceil();
          final maxCol = widget.positions.map((p) => p.col).reduce((a, b) => a > b ? a : b).ceil();

          final totalWidth = (maxCol + 1) * _kCardW + maxCol * _kGap;
          final totalHeight = (maxRow + 1) * _kCardH + maxRow * _kGap + _kBadgeOverhang;

          final sorted = List<TarotSpreadPositionModel>.from(widget.positions)
            ..sort((a, b) => a.index.compareTo(b.index));

          final totalDurationMs = 500 + (sorted.isNotEmpty ? (sorted.length - 1) * 150 : 0);

          return Center(
            child: FittedBox(
              child: SizedBox(
                width: totalWidth,
                height: totalHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children:
                      sorted.asMap().entries.map((entry) {
                        final animIdx = entry.key;
                        final pos = entry.value;
                        final isLandscape = pos.rotation == 90;
                        final tileW = isLandscape ? _kCardH : _kCardW;
                        final tileH = isLandscape ? _kCardW : _kCardH;

                        // Align center within the logical cell coordinate
                        final targetLeft = pos.col * (_kCardW + _kGap) + (_kCardW - tileW) / 2;
                        final targetTop = pos.row * (_kCardH + _kGap) + (_kCardH - tileH) / 2;

                        final startLeft = totalWidth / 2 - tileW / 2;
                        final startTop = totalHeight + 300;

                        final intervalStart = (animIdx * 150.0) / totalDurationMs;
                        final intervalEnd = (animIdx * 150.0 + 500.0) / totalDurationMs;

                        final entryCurve = CurvedAnimation(
                          parent: _entryController,
                          curve: Interval(
                            intervalStart.clamp(0.0, 1.0),
                            intervalEnd.clamp(0.0, 1.0),
                            curve: Curves.easeOutCubic,
                          ),
                        );

                        final assignedCard =
                            _assignedCardIds.containsKey(pos.index)
                                ? widget.allCards
                                    .where((c) => c.id == _assignedCardIds[pos.index])
                                    .firstOrNull
                                : null;

                        final isReversed = _reversedFlags[pos.index] ?? false;

                        return AnimatedBuilder(
                          animation: _entryController,
                          builder:
                              (context, child) => Positioned(
                                left: startLeft + (targetLeft - startLeft) * entryCurve.value,
                                top: startTop + (targetTop - startTop) * entryCurve.value,
                                child: Transform.rotate(
                                  angle: (1 - entryCurve.value) * 0.2 * (animIdx.isEven ? 1 : -1),
                                  child: Opacity(
                                    opacity: entryCurve.value.clamp(0.0, 1.0),
                                    child: child,
                                  ),
                                ),
                              ),
                          child: _PlaygroundCardTile(
                            width: tileW,
                            height: tileH,
                            index: pos.index,
                            isLandscape: isLandscape,
                            flipController: _flipControllers[pos.index]!,
                            assignedCard: assignedCard,
                            isReversed: isReversed,
                            onTap: () => _onCardTap(pos.index, pos),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PlaygroundCardTile extends StatelessWidget {
  const _PlaygroundCardTile({
    required this.width,
    required this.height,
    required this.index,
    required this.isLandscape,
    required this.flipController,
    required this.assignedCard,
    required this.isReversed,
    required this.onTap,
  });

  final double width;
  final double height;
  final int index;
  final bool isLandscape;
  final AnimationController flipController;
  final TarotCardModel? assignedCard;
  final bool isReversed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScalingContainer(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height + _kBadgeOverhang,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            _FlipCard(
              width: width,
              height: height,
              isLandscape: isLandscape,
              flipController: flipController,
              assignedCard: assignedCard,
              isReversed: isReversed,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: _kBadge,
                height: _kBadge,
                decoration: BoxDecoration(
                  color: context.colors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.background, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: m14w700(context).copyWith(
                    color: context.colors.textOnPrimary,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlipCard extends StatelessWidget {
  const _FlipCard({
    required this.width,
    required this.height,
    required this.isLandscape,
    required this.flipController,
    required this.assignedCard,
    required this.isReversed,
  });

  final double width;
  final double height;
  final bool isLandscape;
  final AnimationController flipController;
  final TarotCardModel? assignedCard;
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: flipController,
      builder: (context, _) {
        final v = flipController.value;
        final isShowingFront = v > 0.5 && assignedCard != null;

        // Back collapses 0 → π/2; front unfolds −π/2 → 0 (no mirror artefact)
        final angle = isShowingFront ? (v - 1.0) * math.pi : v * math.pi;

        return Transform(
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateY(angle),
          alignment: Alignment.center,
          child: _CardFace(
            imageUrl: isShowingFront ? assignedCard!.imageUrl : TarotAppAssets.cardBgHttp,
            width: width,
            height: height,
            isLandscape: isLandscape,
            // Reversed only applies to the card face, not the card back
            isReversed: isShowingFront && isReversed,
          ),
        );
      },
    );
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace({
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.isLandscape,
    required this.isReversed,
  });

  final String imageUrl;
  final double width;
  final double height;
  final bool isLandscape;
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    // Portrait dimensions: the card image is always portrait internally
    final portraitW = isLandscape ? height : width;
    final portraitH = isLandscape ? width : height;

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: CustomCacheNetworkImage(
        imageUrl: imageUrl,
        width: portraitW,
        height: portraitH,
        fit: BoxFit.fill,
      ),
    );

    // Apply reversed rotation to the image content before landscape rotation
    if (isReversed) {
      image = Transform.rotate(angle: math.pi, child: image);
    }

    if (!isLandscape) return image;

    // RotatedBox properly reports swapped layout dimensions (W↔H) so the
    // parent Transform has the correct anchor point for the flip animation.
    return RotatedBox(quarterTurns: 1, child: image);
  }
}
