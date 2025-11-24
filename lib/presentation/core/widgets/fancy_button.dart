import 'package:daily_tarot_focus/presentation/core/constants/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/presentation/core/helper/text_style_helper.dart';
import 'package:daily_tarot_focus/presentation/core/widgets/custom_loading_indicator.dart';
import 'package:daily_tarot_focus/presentation/core/widgets/fancy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class FancyButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Widget? icon;
  final TextStyle? textStyle;
  final Color? textColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final bool isLoading;

  // Either textColor or textStyle must be provided, or none of them
  const FancyButton({
    super.key,
    this.text,
    required this.onPressed,
    this.icon,
    this.textColor,
    this.backgroundColor,
    this.padding,
    this.width,
    this.height,
    this.textStyle,
    this.isLoading = false,
  }) : assert(textColor == null || textStyle == null);

  @override
  Widget build(BuildContext context) {
    final buttonColor = backgroundColor ?? context.colors.primary;

    return ScalingContainer(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: FancyContainer(
        color: buttonColor,
        borderRadius: BorderRadius.circular(100),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              CustomLoadingIndicator(
                indicatorSize: 28,
                color: context.colors.background,
              ),
            ] else ...[
              if (icon != null) ...[icon!],
              if (text != null) ...[
                Spacing.tinyW,
                Text(
                  text!,
                  overflow: TextOverflow.ellipsis,
                  style:
                      textStyle ??
                      n16w700(
                        context,
                      ).copyWith(color: context.colors.background),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
