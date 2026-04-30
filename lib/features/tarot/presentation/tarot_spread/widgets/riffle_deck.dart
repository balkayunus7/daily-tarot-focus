import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class RiffleDeck extends StatefulWidget {
  const RiffleDeck({required this.isAutoShuffle, super.key});

  final ValueNotifier<bool> isAutoShuffle;

  static const int _cardCount = 10;
  static const double _cardW = 155;
  static const double _cardH = 235;
  static const double _splitX = 55;
  static const double _stackOffset = 1.5;

  @override
  State<RiffleDeck> createState() => _RiffleDeckState();
}

class _RiffleDeckState extends State<RiffleDeck> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const Duration _shuffleDuration = Duration(milliseconds: 1500);
  static const Duration _autoInterval = Duration(milliseconds: 400);

  Future<void> _manualShuffle() async {
    if (widget.isAutoShuffle.value || _controller.isAnimating) return;
    await _controller.forward(from: 0);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _shuffleDuration);

    widget.isAutoShuffle.addListener(_onAutoShuffleChanged);
  }

  Future<void> _onAutoShuffleChanged() async {
    if (!widget.isAutoShuffle.value) {
      _controller.stop();
      await _controller.animateTo(0, duration: const Duration(milliseconds: 300));
      return;
    }
    while (widget.isAutoShuffle.value && mounted) {
      await _controller.forward(from: 0);
      if (!widget.isAutoShuffle.value) break;
      await Future<void>.delayed(_autoInterval);
    }
  }

  @override
  void dispose() {
    widget.isAutoShuffle.removeListener(_onAutoShuffleChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScalingContainer(
      onTap: _manualShuffle,
      child: SizedBox(
        width: (RiffleDeck._cardW + RiffleDeck._splitX * 2 + 20).w,
        height: (RiffleDeck._cardH + RiffleDeck._cardCount * RiffleDeck._stackOffset + 30).h,
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(RiffleDeck._cardCount, _buildCard),
        ),
      ),
    );
  }

  Widget _buildCard(int i) {
    final isLeftHalf = i < RiffleDeck._cardCount ~/ 2;
    final halfIndex = isLeftHalf ? i : i - RiffleDeck._cardCount ~/ 2;

    final splitAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.30, curve: Curves.easeOut),
    );
    final targetSplitX = isLeftHalf ? -RiffleDeck._splitX : RiffleDeck._splitX;

    final riffleSlot = isLeftHalf ? halfIndex * 2 : halfIndex * 2 + 1;
    final riffleStart = 0.30 + riffleSlot * (0.45 / (RiffleDeck._cardCount - 1));
    final riffleEnd = (riffleStart + 0.18).clamp(0.0, 0.75);
    final riffleAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(riffleStart, riffleEnd, curve: Curves.easeIn),
    );

    final mergeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.75, 1, curve: Curves.easeOut),
    );

    final riffleTargetY = -(riffleSlot * RiffleDeck._stackOffset);

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final splitProgress = splitAnim.value;
        final splitX = targetSplitX * splitProgress;

        final splitY = -8.0 * splitProgress;

        final riffleProgress = riffleAnim.value;
        final riffleX = splitX * (1 - riffleProgress);
        final riffleY = splitY + (riffleTargetY - splitY) * riffleProgress;

        final mergeProgress = mergeAnim.value;
        final finalX = riffleX * (1 - mergeProgress);
        final finalY =
            riffleY * (1 - mergeProgress) + (-i * RiffleDeck._stackOffset) * mergeProgress;

        final rotation =
            (targetSplitX > 0 ? 0.04 : -0.04) *
            splitProgress *
            (1 - riffleProgress) *
            (1 - mergeProgress);

        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..translate(finalX.w, finalY.h)
                ..rotateZ(rotation),
          child: child,
        );
      },
      child: Container(
        width: RiffleDeck._cardW.w,
        height: RiffleDeck._cardH.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CustomCacheNetworkImage(
            imageUrl: TarotAppAssets.cardBgHttp,
            width: RiffleDeck._cardW.w,
            height: RiffleDeck._cardH.h,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
