import 'dart:math';

import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class NumerologyInputVisual extends StatelessWidget {
  const NumerologyInputVisual({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = 220.r;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _NumerologyInputPainter(
                  primary: colors.primary,
                  accent: colors.accent,
                  secondary: colors.secondary,
                ),
              ),
            ),
            Container(
              width: 92.r,
              height: 92.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors.gradientStart, colors.gradientEnd],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.4),
                    blurRadius: 28,
                    spreadRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                '?',
                style: m24w700(context).copyWith(
                  fontSize: 44.sp,
                  color: colors.textOnPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumerologyInputPainter extends CustomPainter {
  const _NumerologyInputPainter({
    required this.primary,
    required this.accent,
    required this.secondary,
  });

  final Color primary;
  final Color accent;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.42;

    // Outer faint ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = primary.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // Digits 1..9 placed around the mid ring
    final midRadius = radius * 0.78;
    const digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (var i = 0; i < digits.length; i++) {
      final angle = (i * (360 / digits.length) - 90) * pi / 180;
      final pos = Offset(
        center.dx + midRadius * cos(angle),
        center.dy + midRadius * sin(angle),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: digits[i],
          style: TextStyle(
            color: accent.withValues(alpha: 0.7),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos.translate(-tp.width / 2, -tp.height / 2));
    }

    // Inner spokes
    final spokePaint =
        Paint()
          ..color = secondary.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.7;
    for (var i = 0; i < 6; i++) {
      final angle = (i * 60) * pi / 180;
      canvas.drawLine(
        Offset(center.dx + radius * 0.3 * cos(angle), center.dy + radius * 0.3 * sin(angle)),
        Offset(center.dx + radius * 0.55 * cos(angle), center.dy + radius * 0.55 * sin(angle)),
        spokePaint,
      );
    }

    // Outer sparkle dots
    for (var i = 0; i < 12; i++) {
      final angle = (i * 30) * pi / 180;
      canvas.drawCircle(
        Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle)),
        i % 3 == 0 ? 1.8 : 1.0,
        Paint()..color = Colors.white.withValues(alpha: i % 3 == 0 ? 0.7 : 0.32),
      );
    }
  }

  @override
  bool shouldRepaint(_NumerologyInputPainter old) =>
      old.primary != primary || old.accent != accent || old.secondary != secondary;
}
