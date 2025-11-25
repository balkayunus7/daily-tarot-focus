import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotsSplashView extends StatefulWidget {
  const TarotsSplashView({super.key, required this.logo});
  final Widget? logo;

  @override
  State<TarotsSplashView> createState() => _TarotsSplashViewState();
}

class _TarotsSplashViewState extends State<TarotsSplashView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller =
        AnimationController(
            vsync: this,
            lowerBound: 0.75,
            upperBound: 1.0,
            duration: const Duration(seconds: 1),
          )
          ..forward()
          ..repeat(reverse: true, min: 0.85);

    super.initState();
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
          decoration: BoxDecoration(color: Color(0xfffefdfc)),
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
