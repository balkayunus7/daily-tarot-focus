import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    this.glassColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.child,
    this.borderColor,
    this.blur,
    this.thickness,
    this.chromaticAberration,
    this.refractiveIndex,
  });

  final Widget? child;
  final Color? glassColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double? blur;
  final double? thickness;
  final double? chromaticAberration;
  final double? refractiveIndex;

  @override
  Widget build(BuildContext context) {
    final resolvedGlassColor = glassColor ?? context.colors.primary.withValues(alpha: 0.25);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.transparent, width: 2),
        borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
      ),
      child: LiquidGlass.withOwnLayer(
        settings: LiquidGlassSettings(
          glassColor: resolvedGlassColor,
          blur: blur ?? 6,
          thickness: thickness ?? 12,
          chromaticAberration: chromaticAberration ?? 0.005,
          refractiveIndex: refractiveIndex ?? 1.15,
        ),
        shape: LiquidRoundedSuperellipse(borderRadius: borderRadius ?? 100),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}
