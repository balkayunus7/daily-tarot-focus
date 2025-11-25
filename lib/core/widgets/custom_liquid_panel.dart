import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidPanel extends StatelessWidget {
  const LiquidPanel({
    super.key,
    this.height = 132,
    this.width = double.infinity,
    this.padding = const EdgeInsets.all(16),
    required this.child,
  });

  final double height;
  final double width;
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: LiquidGlassLayer(
        settings: LiquidGlassSettings(lightAngle: 0.7, thickness: 70),
        child: LiquidGlass(
          shape: LiquidRoundedRectangle(borderRadius: 16),
          child: Container(
            color: Colors.white.withValues(alpha: 0.04),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
