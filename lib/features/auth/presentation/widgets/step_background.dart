import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class StepBackground extends StatelessWidget {
  const StepBackground({super.key});
  static const _starCount = 100;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Pre-computed star data based on a fixed seed for consistent static visual.
    final stars = List<_StarData>.generate(_starCount, (i) {
      final rng = math.Random(i * 30);
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
        secondaryColor: colors.secondary.withValues(alpha: 0.2),
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

    // 3. Crescent moon (top-right)
    _drawCrescent(canvas, size);
    // 4. Constellation cluster (top-right)
    _drawConstellation(canvas, size);
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
