import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class PaddedContainer extends StatelessWidget {
  const PaddedContainer({
    required this.child,
    super.key,
    this.padding,
    this.width,
    this.height,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: Sp.large.radiusR,
        border: Border.all(color: borderColor ?? context.colors.border),
      ),
      child: Padding(
        padding: padding ?? Sp.tiny.padAllR,
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: Sp.medium.radiusR,
          ),
          child: child,
        ),
      ),
    );
  }
}
