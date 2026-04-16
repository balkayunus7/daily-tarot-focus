import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class SplashView extends StatefulWidget {
  const SplashView({required this.logo, super.key});
  final Widget? logo;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.75,
      duration: const Duration(seconds: 1),
    );
    unawaited(_controller.forward());
    unawaited(_controller.repeat(reverse: true, min: 0.85));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.getUIOverlayStyle().copyWith(
        systemNavigationBarColor: context.colors.primary,
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: context.colors.background),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _controller.value,
                  child: widget.logo ?? const SizedBox(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
