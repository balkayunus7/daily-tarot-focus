import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

enum BorderType {
  high(0.9),
  medium(0.6),
  low(0.2);

  const BorderType(this.value);
  final double value;

  Border getBorder(BuildContext context, {Color? color}) => Border.all(
    color: color ?? context.colors.textOnPrimary.withValues(alpha: value),
    width: 0.5,
  );
}

class FancyContainer extends StatelessWidget {
  const FancyContainer({
    super.key,
    this.color,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.child,
    this.gradient,
    this.image,
    this.borderType = BorderType.low,
    this.borderColor,
  });

  final Widget? child;
  final Color? color;
  final Gradient? gradient;
  final ImageProvider? image;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final BorderType borderType;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final resolvedBorderRadius = borderRadius ?? Sp.small.radiusR;
    final shapeRadius = resolvedBorderRadius.topLeft.x;
    final glassColor = color ?? context.colors.primary;

    final glassChild = LiquidGlass.withOwnLayer(
      settings: LiquidGlassSettings(
        glassColor: glassColor.withValues(alpha: 0.25),
        blur: 6,
        thickness: 12,
        chromaticAberration: 0.005,
        refractiveIndex: 1.15,
      ),
      shape: LiquidRoundedSuperellipse(borderRadius: shapeRadius),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: glassChild,
    );
  }
}
