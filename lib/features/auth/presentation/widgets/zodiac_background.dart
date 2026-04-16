part of '../pages/register_step_zodiac_page.dart';

class ZodiacBackground extends StatelessWidget {
  const ZodiacBackground({super.key});

  static const _starCount = 70;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Pre-computed star data based on a fixed seed for consistent static visual.
    final stars = List<_StarData>.generate(_starCount, (i) {
      final rng = math.Random(i * 31 + 7);
      return _StarData(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        size: rng.nextDouble() * 2 + 0.6,
        minOpacity: rng.nextDouble() * 0.2 + 0.1,
        maxOpacity: rng.nextDouble() * 0.5 + 0.4,
        phaseOffset: rng.nextDouble() * math.pi * 2,
        speed: rng.nextDouble() * 0.4 + 0.2,
      );
    });

    return CustomPaint(
      size: Size.infinite,
      painter: _ZodiacBackgroundPainter(
        stars: stars,
        primaryColor: colors.primary,
        secondaryColor: colors.secondary,
        accentColor: colors.accent,
      ),
    );
  }
}

class _StarData {
  const _StarData({
    required this.x,
    required this.y,
    required this.size,
    required this.minOpacity,
    required this.maxOpacity,
    required this.phaseOffset,
    required this.speed,
  });
  final double x;
  final double y;
  final double size;
  final double minOpacity;
  final double maxOpacity;
  final double phaseOffset;
  final double speed;
}

class _ZodiacBackgroundPainter extends CustomPainter {
  const _ZodiacBackgroundPainter({
    required this.stars,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  });

  final List<_StarData> stars;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..style = PaintingStyle.fill;
    for (final s in stars) {
      starPaint.color = secondaryColor;
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.size / 2,
        starPaint,
      );
    }

    // 2. Orbital arcs (faint ellipses)
    final arcPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height * 0.5);

    arcPaint.color = secondaryColor;
    _drawRotatedEllipse(
      canvas,
      center,
      size.width * 0.82,
      size.height * 0.21,
      -25 * math.pi / 180,
      arcPaint,
    );

    arcPaint.color = accentColor;
    _drawRotatedEllipse(
      canvas,
      center,
      size.width * 0.72,
      size.height * 0.17,
      15 * math.pi / 180,
      arcPaint,
    );

    // 3. Crescent moon (top-right)
    _drawCrescent(canvas, size);

    // 4. Constellation cluster (top-right)
    _drawConstellation(canvas, size);
  }

  void _drawRotatedEllipse(
    Canvas canvas,
    Offset center,
    double rx,
    double ry,
    double angle,
    Paint paint,
  ) {
    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..rotate(angle);
    final rect = Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2);
    canvas
      ..drawOval(rect, paint)
      ..restore();
  }

  void _drawCrescent(Canvas canvas, Size size) {
    final cx = size.width * 0.87;
    final cy = size.height * 0.06;
    final r = size.width * 0.10;

    // Crescent arc highlight
    final crescentPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = secondaryColor;
    final path =
        Path()
          ..moveTo(cx - r * 0.5, cy - r * 0.55)
          ..quadraticBezierTo(cx - r * 0.95, cy, cx - r * 0.5, cy + r * 0.55);
    canvas.drawPath(path, crescentPaint);
  }

  void _drawConstellation(Canvas canvas, Size size) {
    final nodes = [
      Offset(size.width * 0.74, size.height * 0.165),
      Offset(size.width * 0.78, size.height * 0.150),
      Offset(size.width * 0.83, size.height * 0.170),
      Offset(size.width * 0.80, size.height * 0.188),
    ];

    final linePaint =
        Paint()
          ..color = primaryColor
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;
    for (var i = 0; i < nodes.length - 1; i++) {
      canvas.drawLine(nodes[i], nodes[i + 1], linePaint);
    }

    final dotPaint =
        Paint()
          ..color = primaryColor
          ..style = PaintingStyle.fill;
    for (final node in nodes) {
      canvas.drawCircle(node, 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ZodiacBackgroundPainter old) => true;
}
