import 'dart:math' as math;

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/app_text_styles.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class SpreadCategoryGuide extends StatelessWidget {
  const SpreadCategoryGuide({required this.onTap, super.key});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      padding: Sp.xlarge.padAllR,
      color: context.colors.textOnPrimary,
      child: Stack(
        children: [
          Positioned(
            right: -32,
            bottom: -32,
            child: CustomPaint(
              size: const Size(180, 180),
              painter: _SparklePainter(color: context.colors.accent),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(LocaleKeys.tarot_question_need_guidance.tr(), style: m21w600(context)),
              Sp.xsmall.heightBox,
              Text(
                LocaleKeys.tarot_question_guide_subtitle.tr(),
                style: m12w500(context).copyWith(color: context.colors.textSecondary, height: 1.5),
              ),
              Sp.xlarge.heightBox,
              FancyButton(
                onTap: onTap,
                text: LocaleKeys.tarot_question_guide_button.tr(),
                backgroundColor: context.colors.primary,
                textStyle: m14w700(context).copyWith(color: context.colors.textOnPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    _drawSparkle(
      canvas,
      paint,
      center: Offset(size.width * 0.58, size.height * 0.56),
      outerRadius: size.width * 0.40,
      innerRadius: size.width * 0.12,
    );
    _drawSparkle(
      canvas,
      paint,
      center: Offset(size.width * 0.10, size.height * 0.14),
      outerRadius: size.width * 0.12,
      innerRadius: size.width * 0.035,
    );
  }

  void _drawSparkle(
    Canvas canvas,
    Paint paint, {
    required Offset center,
    required double outerRadius,
    required double innerRadius,
  }) {
    const arms = 4;
    const startAngle = -math.pi / 2;
    const step = math.pi / arms;

    final path = Path();

    for (var i = 0; i < arms * 2; i++) {
      final angle = startAngle + step * i;
      final r = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) => oldDelegate.color != color;
}
