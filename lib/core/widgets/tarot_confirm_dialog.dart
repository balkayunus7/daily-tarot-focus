import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotConfirmDialog extends StatelessWidget {
  const TarotConfirmDialog({
    required this.title,
    required this.cancelText,
    required this.confirmText,
    super.key,
    this.body,
    this.confirmColor,
  });

  final String title;
  final String? body;
  final String cancelText;
  final String confirmText;
  final Color? confirmColor;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String cancelText,
    required String confirmText,
    String? body,
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => TarotConfirmDialog(
            title: title,
            body: body,
            cancelText: cancelText,
            confirmText: confirmText,
            confirmColor: confirmColor,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Dialog(
      backgroundColor: colors.background,
      shape: RoundedRectangleBorder(borderRadius: Sp.xlarge.radiusR),
      child: Padding(
        padding: Sp.large.padAllR,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: m16w700(context), textAlign: TextAlign.center),
            if (body != null) ...[
              Sp.small.heightBox,
              Text(
                body!,
                style: m13w400(context).copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            Sp.xlarge.heightBox,
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    text: cancelText,
                    isOutlined: true,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                ),
                Sp.small.widthBox,
                Expanded(
                  child: _DialogButton(
                    text: confirmText,
                    color: confirmColor,
                    onTap: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.text,
    required this.onTap,
    this.isOutlined = false,
    this.color,
  });

  final String text;
  final VoidCallback onTap;
  final bool isOutlined;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final buttonColor = color ?? colors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : buttonColor,
          border: isOutlined ? Border.all(color: buttonColor) : null,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,
          style: m14w600(context).copyWith(
            color: isOutlined ? buttonColor : colors.background,
          ),
        ),
      ),
    );
  }
}
