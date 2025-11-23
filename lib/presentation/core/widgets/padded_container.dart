import 'package:daily_tarot_focus/presentation/core/constants/lyrics_app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:mobile_core/presentation/extensions/build_context_theme_ext.dart';

class PaddedContainer extends StatelessWidget {
  const PaddedContainer({
    super.key,
    required this.child,
    this.padding = Spacing.tinyPadding,
    this.width,
    this.height,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final double? width;
  final double? height;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: Spacing.largeBorderRadius,
        border: Border.all(color: borderColor ?? context.colors.border),
      ),
      child: Padding(
        padding: padding,
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: Spacing.defaultBorderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}
