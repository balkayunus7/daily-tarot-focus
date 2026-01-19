import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

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
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
        ),
        image: image != null ? DecorationImage(image: image!, fit: BoxFit.cover) : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.25),
              blurRadius: 10,
              spreadRadius: 2,
              inset: true,
            ),
          ],
          border: GradientBoxBorder(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.3),
                Colors.white.withValues(alpha: 0.7),
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0),
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
