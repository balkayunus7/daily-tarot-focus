import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class FancyButton extends StatelessWidget {
  const FancyButton({
    required this.onPressed,
    super.key,
    this.text,
    this.icon,
    this.textColor,
    this.backgroundColor,
    this.padding,
    this.width,
    this.height,
    this.textStyle,
    this.isLoading = false,
    this.borderRadius,
  }) : assert(
         textColor == null || textStyle == null,
         'Cannot provide both textColor and textStyle',
       );

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
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final baseColor = backgroundColor ?? context.colors.primary;
    final glassColorRef = baseColor.withValues(alpha: 0.35);
    final borderColor = baseColor.withValues(alpha: 0.5);
    final resolvedBorderRadius = borderRadius ?? 16.radiusR;
    final shapeRadius = resolvedBorderRadius.topLeft.x;

    return ScalingContainer(
      onTap: () async {
        await HapticFeedback.lightImpact();
        onPressed();
      },
      child: SizedBox(
        width: width,
        height: height,
        child: LiquidGlass.withOwnLayer(
          settings: LiquidGlassSettings(
            glassColor: glassColorRef,
            blur: 16,
            thickness: 10,
            lightIntensity: 1.1,
          ),
          shape: LiquidRoundedSuperellipse(borderRadius: shapeRadius),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: shapeRadius.radiusR,
            ),
            child: GlassGlow(
              child: Padding(
                padding: padding ?? 12.padSymR(v: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading) ...[
                      SpinKitFadingCircle(
                        color: context.colors.primary,
                        size: 28,
                      ),
                    ] else ...[
                      if (icon != null) ...[icon!],
                      if (text != null) ...[
                        Sp.tiny.widthBox,
                        Text(
                          text!,
                          overflow: TextOverflow.ellipsis,
                          style:
                              textStyle ??
                              m16w700(context).copyWith(
                                color: context.colors.background,
                              ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
