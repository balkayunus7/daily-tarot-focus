import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class GlassButton extends StatelessWidget {
  const GlassButton({
    required this.onTap,
    required this.buttonText,
    super.key,
    this.width = double.infinity,
    this.paddingHorizontal = 0,
    this.height = 54,
    this.isLoading = false,
    this.isDisabled = false,
    this.svgIcon,
    this.svgIconSize,
    this.buttonTextStyle,
    this.borderRadius,
    this.glassOutColor,
  });

  final VoidCallback onTap;
  final double width;
  final double paddingHorizontal;
  final String buttonText;
  final bool isDisabled;
  final bool isLoading;
  final String? svgIcon;
  final Size? svgIconSize;
  final double height;
  final TextStyle? buttonTextStyle;
  final BorderRadius? borderRadius;
  final Color? glassOutColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final glassColor = isDisabled ? colors.primary.withValues(alpha: 0.05) : colors.secondary;
    final borderColor =
        isDisabled ? colors.primary.withValues(alpha: 0.1) : colors.primary.withValues(alpha: 0.2);
    final textColor = colors.textOnPrimary;
    final resolvedBorderRadius = borderRadius ?? 24.radiusR;
    final shapeRadius = resolvedBorderRadius.topLeft.x;

    final innerContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,

      children: [
        if (isLoading) ...[
          SpinKitFadingCircle(color: textColor, size: 28),
        ] else ...[
          if (svgIcon != null && svgIcon!.isNotEmpty) ...[
            SvgPicture.asset(
              svgIcon!,
              width: svgIconSize?.width ?? 24,
              height: svgIconSize?.height ?? 24,
            ),
            Sp.tiny.widthBox,
          ],
          Flexible(
            child: Text(
              buttonText,
              overflow: TextOverflow.ellipsis,
              style: buttonTextStyle ?? m16w700(context).copyWith(color: textColor),
            ),
          ),
        ],
      ],
    );

    final buttonBody = Padding(
      padding: paddingHorizontal.padXR,
      child: ScalingContainer(
        onTap: isLoading || isDisabled ? null : onTap,
        child: SizedBox(
          width: width.w,
          height: height.h,
          child: LiquidGlass.withOwnLayer(
            settings: LiquidGlassSettings(
              glassColor: glassOutColor ?? glassColor,
              blur: 24,
              thickness: 10,
              lightIntensity: 1.2,
            ),
            shape: LiquidRoundedSuperellipse(borderRadius: shapeRadius),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.2),
                borderRadius: resolvedBorderRadius,
              ),
              child: GlassGlow(child: Center(child: innerContent)),
            ),
          ),
        ),
      ),
    );

    return IgnorePointer(ignoring: isLoading || isDisabled, child: buttonBody);
  }
}
