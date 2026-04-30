import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class FancyButton extends StatelessWidget {
  const FancyButton({
    required this.onTap,
    super.key,
    this.text,
    this.icon,
    this.textColor,
    this.backgroundColor,
    this.padding,
    this.width,
    this.height = 48,
    this.textStyle,
    this.isLoading = false,
    this.isDisabled = false,
  });

  final String? text;
  final VoidCallback onTap;
  final Widget? icon;
  final TextStyle? textStyle;
  final Color? textColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final bool isLoading;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final buttonColor = backgroundColor ?? context.colors.primary;

    return ScalingContainer(
      onTap: () async {
        await HapticFeedbackHelper.lightImpact();
        onTap();
      },
      child: Opacity(
        opacity: isDisabled ? 0.3 : 1,
        child: FancyContainer(
          color: buttonColor,
          borderRadius: 100,
          padding: padding ?? EdgeInsets.zero,
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                SpinKitFadingCircle(color: textColor ?? context.colors.background, size: 28),
              ] else ...[
                if (icon != null) ...[icon!],
                if (text != null) ...[
                  Sp.tiny.widthBox,
                  Text(
                    text!,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle ?? m15w700(context).copyWith(color: context.colors.background),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
