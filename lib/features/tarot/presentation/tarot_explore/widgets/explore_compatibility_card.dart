part of '../pages/tarot_explore_page.dart';

class ExploreCompatibilityCard extends StatelessWidget {
  const ExploreCompatibilityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ExploreFeatureCard(
      title: LocaleKeys.compat_page_explore_card_title.tr(),
      imageWidget: const _CompatibilityIllustration(),
      onTap: () => context.push(AppRoutes.tarotCompatibilityInput),
    );
  }
}

class _CompatibilityIllustration extends StatelessWidget {
  const _CompatibilityIllustration();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
          const Positioned(top: 10, left: 14, child: _Sparkle(size: 2.5, opacity: 0.75)),
          const Positioned(top: 22, right: 18, child: _Sparkle(size: 1.5, opacity: 0.55)),
          const Positioned(bottom: 18, right: 12, child: _Sparkle(size: 2, opacity: 0.7)),
          const Positioned(bottom: 26, left: 10, child: _Sparkle(size: 1.5, opacity: 0.45)),
          const Positioned(top: 8, right: 36, child: _Sparkle(size: 1.5, opacity: 0.60)),
          const Positioned(bottom: 10, left: 32, child: _Sparkle(size: 1, opacity: 0.40)),
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
