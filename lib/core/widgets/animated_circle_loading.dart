import 'dart:async';

import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:flutter/material.dart';

class AnimatedCircleLoading extends StatefulWidget {
  const AnimatedCircleLoading({super.key, this.circleSize = 200});
  final double circleSize;

  @override
  State<AnimatedCircleLoading> createState() => _AnimatedLoadingImageState();
}

class _AnimatedLoadingImageState extends State<AnimatedCircleLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    unawaited(_controller.repeat(reverse: true));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.1416,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.circleSize,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: child,
            ),
          );
        },
        child: Image.asset(TarotAppAssets.loading.path),
      ),
    );
  }
}
