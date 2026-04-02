import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class TarotButton extends StatelessWidget {
  const TarotButton({
    required this.onTap,
    required this.buttonText,
    super.key,
    this.width = double.infinity,
    this.paddingHorizontal = 0,
    this.height = 54,
    this.bgColor,
    this.isLoading = false,
    this.isDisabled = false,
    this.svgIcon,
    this.svgIconSize,
    this.buttonTextStyle,
    this.borderRadius,
  });

  final VoidCallback onTap;
  final double width;
  final double paddingHorizontal;
  final String buttonText;
  final Color? bgColor;
  final bool isDisabled;
  final bool isLoading;
  final String? svgIcon;
  final Size? svgIconSize;
  final double height;
  final TextStyle? buttonTextStyle;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading || isDisabled,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        child: ScalingContainer(
          onTap: isLoading || isDisabled ? null : onTap,
          child: Opacity(
            opacity: isLoading || isDisabled ? 0.5 : 1,
            child: FancyButton(
              width: width,
              height: height,
              text: buttonText,
              textStyle: buttonTextStyle,
              onPressed: onTap,
              backgroundColor: bgColor ?? context.colors.primary,
              borderRadius: borderRadius,
              isLoading: isLoading,
              icon: svgIcon != null && svgIcon!.isNotEmpty ? SvgPicture.asset(svgIcon!) : null,
            ),
          ),
        ),
      ),
    );
  }
}
