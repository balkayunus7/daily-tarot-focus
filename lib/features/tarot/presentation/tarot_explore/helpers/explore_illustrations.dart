import 'dart:math';

import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class ZodiacIllustration extends StatelessWidget {
  const ZodiacIllustration({required this.sign, super.key});
  final ZodiacSign sign;

  static const _fireColor = Color(0xFFE8855A);
  static const _earthColor = Color(0xFF7BC67A);
  static const _airColor = Color(0xFF82C4E8);
  static const _waterColor = Color(0xFF6B9FD4);

  Color get _elementColor {
    switch (sign.element) {
      case ZodiacElement.fire:
        return _fireColor;
      case ZodiacElement.earth:
        return _earthColor;
      case ZodiacElement.air:
        return _airColor;
      case ZodiacElement.water:
        return _waterColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final elementColor = _elementColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.gradientStart, colors.gradientEnd],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(top: 8, left: 12, child: Sparkle(size: 2.5, opacity: 0.75)),
          const Positioned(top: 18, right: 16, child: Sparkle(size: 1.5, opacity: 0.55)),
          const Positioned(top: 38, left: 20, child: Sparkle(size: 2, opacity: 0.5)),
          const Positioned(bottom: 12, right: 10, child: Sparkle(size: 2, opacity: 0.7)),
          const Positioned(bottom: 20, left: 8, child: Sparkle(size: 1.5, opacity: 0.45)),
          const Positioned(top: 10, right: 32, child: Sparkle(size: 1.5, opacity: 0.6)),
          const Positioned(bottom: 28, right: 26, child: Sparkle(size: 1, opacity: 0.4)),
          Positioned.fill(
            child: CustomPaint(
              painter: _ZodiacCelestialPainter(
                elementColor: elementColor,
                element: sign.element,
              ),
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: elementColor.withValues(alpha: 0.35),
                        blurRadius: 22,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: elementColor.withValues(alpha: 0.45)),
                    gradient: RadialGradient(
                      colors: [elementColor.withValues(alpha: 0.20), Colors.transparent],
                    ),
                  ),
                ),
                SvgPicture.asset(
                  sign.svgPath,
                  height: 32.sp,
                  width: 32.sp,
                  colorFilter: ColorFilter.mode(context.colors.accent, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ZodiacCelestialPainter extends CustomPainter {
  const _ZodiacCelestialPainter({required this.elementColor, required this.element});
  final Color elementColor;
  final ZodiacElement element;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ringRadius = size.shortestSide * 0.33;

    // outer zodiac wheel
    canvas.drawCircle(
      center,
      ringRadius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.75,
    );

    // 12 tick dots — larger at the 4 cardinal positions
    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * pi / 180;
      final isMajor = i % 3 == 0;
      final pos = Offset(
        center.dx + ringRadius * cos(angle),
        center.dy + ringRadius * sin(angle),
      );
      dotPaint.color = Colors.white.withValues(alpha: isMajor ? 0.7 : 0.38);
      canvas.drawCircle(pos, isMajor ? 2.0 : 1, dotPaint);
    }

    // 4 spokes: inner gap to ring edge
    final spokePaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.75;

    for (var i = 0; i < 4; i++) {
      final a = i * pi / 2;
      canvas.drawLine(
        Offset(center.dx + ringRadius * 0.55 * cos(a), center.dy + ringRadius * 0.55 * sin(a)),
        Offset(center.dx + ringRadius * cos(a), center.dy + ringRadius * sin(a)),
        spokePaint,
      );
    }

    _drawConstellation(canvas, center, ringRadius * 0.5);
  }

  void _drawConstellation(Canvas canvas, Offset center, double r) {
    final linePaint =
        Paint()
          ..color = elementColor.withValues(alpha: 0.32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.75
          ..strokeCap = StrokeCap.round;

    final starPaint =
        Paint()
          ..color = elementColor.withValues(alpha: 0.78)
          ..style = PaintingStyle.fill;

    final pts = _constellationPoints(center, r);

    for (var i = 0; i < pts.length - 1; i++) {
      canvas.drawLine(pts[i], pts[i + 1], linePaint);
    }
    for (final p in pts) {
      canvas.drawCircle(p, 1.8, starPaint);
    }
  }

  List<Offset> _constellationPoints(Offset c, double r) {
    switch (element) {
      // fire → upward triangle with two inner sparks
      case ZodiacElement.fire:
        return [
          Offset(c.dx, c.dy - r * 0.88),
          Offset(c.dx - r * 0.76, c.dy + r * 0.44),
          Offset(c.dx + r * 0.76, c.dy + r * 0.44),
          Offset(c.dx - r * 0.34, c.dy + r * 0.02),
          Offset(c.dx + r * 0.34, c.dy + r * 0.02),
        ];
      // earth → diamond with centre anchor
      case ZodiacElement.earth:
        return [
          Offset(c.dx, c.dy - r * 0.88),
          Offset(c.dx + r * 0.88, c.dy),
          Offset(c.dx, c.dy + r * 0.88),
          Offset(c.dx - r * 0.88, c.dy),
          Offset(c.dx, c.dy),
        ];
      // air → flowing wave / zigzag
      case ZodiacElement.air:
        return [
          Offset(c.dx - r * 0.88, c.dy + r * 0.28),
          Offset(c.dx - r * 0.40, c.dy - r * 0.62),
          Offset(c.dx, c.dy + r * 0.14),
          Offset(c.dx + r * 0.40, c.dy - r * 0.62),
          Offset(c.dx + r * 0.88, c.dy + r * 0.28),
        ];
      // water → arc / crescent curve
      case ZodiacElement.water:
        return [
          Offset(c.dx - r * 0.65, c.dy - r * 0.65),
          Offset(c.dx, c.dy - r * 0.88),
          Offset(c.dx + r * 0.65, c.dy - r * 0.65),
          Offset(c.dx + r * 0.85, c.dy + r * 0.04),
          Offset(c.dx, c.dy + r * 0.76),
        ];
    }
  }

  @override
  bool shouldRepaint(_ZodiacCelestialPainter old) =>
      old.elementColor != elementColor || old.element != element;
}

class Sparkle extends StatelessWidget {
  const Sparkle({required this.size, super.key, this.opacity = 1.0});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size.r,
        height: size.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CompatibilityIllustration extends StatelessWidget {
  const CompatibilityIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.gradientStart, colors.gradientEnd],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(top: 10, left: 14, child: Sparkle(size: 2.5, opacity: 0.75)),
          const Positioned(top: 22, right: 18, child: Sparkle(size: 1.5, opacity: 0.55)),
          const Positioned(bottom: 18, right: 12, child: Sparkle(size: 2, opacity: 0.7)),
          const Positioned(bottom: 26, left: 10, child: Sparkle(size: 1.5, opacity: 0.45)),
          const Positioned(top: 8, right: 36, child: Sparkle(size: 1.5, opacity: 0.60)),
          const Positioned(bottom: 10, left: 32, child: Sparkle(size: 1, opacity: 0.40)),
          Positioned.fill(child: CustomPaint(painter: _CompatPainter())),
        ],
      ),
    );
  }
}

class _CompatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.shortestSide * 0.20;
    final gap = r * 0.55;

    final leftCenter = Offset(cx - gap, cy);
    final rightCenter = Offset(cx + gap, cy);

    // Left circle (gold tint)
    final leftFill =
        Paint()
          ..color = const Color(0xFFE8D5A3).withValues(alpha: 0.22)
          ..style = PaintingStyle.fill;
    final leftStroke =
        Paint()
          ..color = const Color(0xFFE8D5A3).withValues(alpha: 0.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
    canvas
      ..drawCircle(leftCenter, r, leftFill)
      ..drawCircle(leftCenter, r, leftStroke);

    // Right circle (pink tint)
    final rightFill =
        Paint()
          ..color = const Color(0xFFE05A82).withValues(alpha: 0.22)
          ..style = PaintingStyle.fill;
    final rightStroke =
        Paint()
          ..color = const Color(0xFFE05A82).withValues(alpha: 0.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
    canvas
      ..drawCircle(rightCenter, r, rightFill)
      ..drawCircle(rightCenter, r, rightStroke);

    // Glowing intersection oval
    final midX = (leftCenter.dx + rightCenter.dx) / 2;
    final intersectPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.12)
          ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(midX, cy), width: gap * 0.9, height: r * 1.1),
      intersectPaint,
    );

    // Venus symbol (♀) left circle: circle + cross below
    _drawVenus(canvas, leftCenter, r * 0.46, const Color(0xFFE8D5A3).withValues(alpha: 0.75));

    // Mars symbol (♂) right circle: circle + arrow
    _drawMars(canvas, rightCenter, r * 0.46, const Color(0xFFE05A82).withValues(alpha: 0.75));

    // Outer ring of dots at 12 positions
    final dotRadius = size.shortestSide * 0.36;
    final dotPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.28)
          ..style = PaintingStyle.fill;
    for (var i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * pi / 180;
      canvas.drawCircle(
        Offset(cx + dotRadius * cos(angle), cy + dotRadius * sin(angle)),
        i % 3 == 0 ? 1.8 : 1.0,
        dotPaint,
      );
    }
  }

  // Venus ♀: circle + vertical line + horizontal bar
  void _drawVenus(Canvas canvas, Offset c, double r, Color color) {
    final p =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round;
    canvas
      ..drawCircle(c, r * 0.52, p)
      ..drawLine(
        Offset(c.dx, c.dy + r * 0.52),
        Offset(c.dx, c.dy + r),
        p,
      )
      ..drawLine(
        Offset(c.dx - r * 0.3, c.dy + r * 0.78),
        Offset(c.dx + r * 0.3, c.dy + r * 0.78),
        p,
      );
  }

  // Mars ♂: circle + diagonal arrow
  void _drawMars(Canvas canvas, Offset c, double r, Color color) {
    final p =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, r * 0.52, p);
    final arrowEnd = Offset(c.dx + r * 0.7, c.dy - r * 0.7);
    canvas
      ..drawLine(
        Offset(c.dx + r * 0.37, c.dy - r * 0.37),
        arrowEnd,
        p,
      )
      ..drawLine(arrowEnd, Offset(arrowEnd.dx - r * 0.32, arrowEnd.dy), p)
      ..drawLine(arrowEnd, Offset(arrowEnd.dx, arrowEnd.dy + r * 0.32), p);
  }

  @override
  bool shouldRepaint(_CompatPainter _) => false;
}

class DailyFateIllustration extends StatelessWidget {
  const DailyFateIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const moonGold = Color(0xFFE8D5A3);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.gradientStart, colors.gradientEnd],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(top: 10, left: 16, child: Sparkle(size: 3.5, opacity: 0.9)),
          const Positioned(top: 24, right: 22, child: Sparkle(size: 2, opacity: 0.7)),
          const Positioned(top: 42, left: 28, child: Sparkle(size: 2.5, opacity: 0.6)),
          const Positioned(top: 12, left: 52, child: Sparkle(size: 1.5, opacity: 0.8)),
          const Positioned(bottom: 20, left: 12, child: Sparkle(size: 2, opacity: 0.6)),
          const Positioned(bottom: 32, right: 14, child: Sparkle(size: 1.5, opacity: 0.5)),
          const Positioned(top: 6, right: 38, child: Sparkle(size: 2.5, opacity: 0.75)),
          const Positioned(bottom: 14, left: 40, child: Sparkle(size: 1.5, opacity: 0.4)),
          const Center(
            child: SizedBox(
              width: 64,
              height: 64,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40E8D5A3),
                      blurRadius: 28,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 56,
              height: 56,
              child: ClipOval(
                child: Stack(
                  children: [
                    const ColoredBox(color: moonGold, child: SizedBox.expand()),
                    Positioned(
                      right: -13,
                      top: -13,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.lerp(colors.secondary, Colors.black, 0.75),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SacredDecksIllustration extends StatelessWidget {
  const SacredDecksIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.gradientStart, colors.gradientEnd],
        ),
      ),
      child: const Stack(
        children: [
          Positioned(top: 8, left: 14, child: Sparkle(size: 2, opacity: 0.7)),
          Positioned(top: 20, right: 10, child: Sparkle(size: 1.5, opacity: 0.6)),
          Positioned(bottom: 14, right: 18, child: Sparkle(size: 2.5, opacity: 0.8)),
          Positioned(bottom: 22, left: 8, child: Sparkle(size: 1.5, opacity: 0.5)),
          Positioned(top: 10, right: 30, child: Sparkle(size: 1.5, opacity: 0.55)),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _MiniTarotCard(rotationAngle: -0.38, isBack: true, offsetX: -16),
                _MiniTarotCard(rotationAngle: 0, isBack: true),
                _MiniTarotCard(rotationAngle: 0.38, isBack: false, offsetX: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniTarotCard extends StatelessWidget {
  const _MiniTarotCard({
    required this.rotationAngle,
    required this.isBack,
    this.offsetX = 0,
  });

  final double rotationAngle;
  final bool isBack;
  final double offsetX;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cardDark = Color.lerp(colors.primary, Colors.black, 0.75)!;
    final cardMid = Color.lerp(colors.primary, Colors.black, 0.48)!;

    return Transform.translate(
      offset: Offset(offsetX, 0),
      child: Transform.rotate(
        angle: rotationAngle,
        child: Container(
          width: 38.r,
          height: 56.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isBack
                      ? [cardDark, cardMid]
                      : [colors.accent, colors.accent.withValues(alpha: 0.7)],
            ),
            border: Border.all(
              color: colors.primary.withValues(alpha: isBack ? 0.4 : 0.7),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child:
              isBack
                  ? Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: colors.primary.withValues(alpha: 0.65),
                      size: 18.sp,
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wb_sunny_outlined, color: colors.primary, size: 16.sp),
                        const SizedBox(height: 6),
                        Container(height: 1, color: colors.primary.withValues(alpha: 0.45)),
                        const SizedBox(height: 4),
                        Container(height: 1, color: colors.primary.withValues(alpha: 0.3)),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
