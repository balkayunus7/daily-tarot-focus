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
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _scaleAnim = Tween<double>(begin: 0.86, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    unawaited(_controller.repeat(reverse: true));
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
              animation: _scaleAnim,
              builder:
                  (context, child) => Transform.scale(
                    scale: _scaleAnim.value,
                    child: child,
                  ),
              child: widget.logo ?? const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
