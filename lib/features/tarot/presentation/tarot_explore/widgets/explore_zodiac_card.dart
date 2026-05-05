part of '../pages/tarot_explore_page.dart';

class ExploreZodiacCard extends StatelessWidget {
  const ExploreZodiacCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.userOrCrash != curr.userOrCrash,
      builder: (context, state) {
        final user = state.userOrCrash as TarotUser;
        final sign = user.zodiac;
        if (sign == null) return const SizedBox.shrink();

        return ExploreFeatureCard(
          title: 'Learn Horoscope',
          imageWidget: _ZodiacIllustration(sign: sign),
          onTap: () => context.push(AppRoutes.tarotZodiacDetail),
        );
      },
    );
  }
}

class _ZodiacIllustration extends StatelessWidget {
  const _ZodiacIllustration({required this.sign});
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
          colors: [colors.secondary, colors.primary],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(top: 8, left: 12, child: _Sparkle(size: 2.5, opacity: 0.75)),
          const Positioned(top: 18, right: 16, child: _Sparkle(size: 1.5, opacity: 0.55)),
          const Positioned(top: 38, left: 20, child: _Sparkle(size: 2, opacity: 0.5)),
          const Positioned(bottom: 12, right: 10, child: _Sparkle(size: 2, opacity: 0.7)),
          const Positioned(bottom: 20, left: 8, child: _Sparkle(size: 1.5, opacity: 0.45)),
          const Positioned(top: 10, right: 32, child: _Sparkle(size: 1.5, opacity: 0.6)),
          const Positioned(bottom: 28, right: 26, child: _Sparkle(size: 1, opacity: 0.4)),
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
