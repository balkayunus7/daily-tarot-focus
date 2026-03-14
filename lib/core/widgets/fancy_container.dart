import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

enum BorderType {
  high(0.9),
  medium(0.6),
  low(0.2);

  const BorderType(this.value);
  final double value;

  Border getBorder(BuildContext context) =>
      Border.all(color: context.colors.primary.withValues(alpha: value), width: value);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: borderRadius,
        border: borderType.getBorder(context),
        image: image != null ? DecorationImage(image: image!, fit: BoxFit.cover) : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withValues(alpha: 0.25),
              blurRadius: 5,
              spreadRadius: 1,
              inset: true,
            ),
          ],
          border: GradientBoxBorder(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.colors.primary.withValues(alpha: 0.3),
                context.colors.primary.withValues(alpha: 0.7),
                context.colors.primary.withValues(alpha: 0.1),
                context.colors.primary.withValues(alpha: 0.05),
                context.colors.primary.withValues(alpha: 0),
              ],
              stops: const [0.0, 0.1, 0.5, 0.8, 1.0],
            ),
          ),
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}
