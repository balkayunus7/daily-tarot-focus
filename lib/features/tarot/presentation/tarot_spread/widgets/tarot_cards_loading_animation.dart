import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotCardsLoadingAnimation extends StatefulWidget {
  const TarotCardsLoadingAnimation({this.size = 64, this.pulse = false, super.key});
  final double size;

  /// Nefes alıp veren scale animasyonu — splash gibi tek başına kullanımda true yap.
  final bool pulse;

  @override
  State<TarotCardsLoadingAnimation> createState() => _TarotCardsLoadingAnimationState();
}

class _TarotCardsLoadingAnimationState extends State<TarotCardsLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _drawController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    );
    unawaited(_drawController.repeat());

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _pulseAnim = Tween<double>(begin: 0.86, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.pulse) unawaited(_pulseController.repeat(reverse: true));
  }

  @override
  void dispose() {
    _drawController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colors.primary;
    return AnimatedBuilder(
      animation: Listenable.merge([_drawController, _pulseController]),
      builder: (context, _) {
        return Transform.scale(
          scale: widget.pulse ? _pulseAnim.value : 1.0,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _TarotCardsPainter(
              progress: _drawController.value,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

class _TarotCardsPainter extends CustomPainter {
  const _TarotCardsPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  static const double _c1OutlineStart = 0;
  static const double _c1OutlineEnd = 0.22;
  static const double _c2OutlineStart = 0.18;
  static const double _c2OutlineEnd = 0.42;
  static const double _c1SymbolStart = 0.38;
  static const double _c1SymbolEnd = 0.60;
  static const double _c2SymbolStart = 0.55;
  static const double _c2SymbolEnd = 0.78;
  static const double _fadeStart = 0.84;
  static const double _fadeEnd = 1;

  double _phase(double t, double start, double end) =>
      ((t - start) / (end - start)).clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    // Scale everything relative to a 200px reference canvas
    final s = size.width / 200.0;
    final cx = size.width / 2;
    final cy = size.height / 2;

    final fadeOut = _phase(progress, _fadeStart, _fadeEnd);
    final opacity = (1.0 - fadeOut).clamp(0.0, 1.0);

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = (2.2 * s).clamp(1.0, 3.0)
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    _drawCard(
      canvas: canvas,
      paint: paint,
      s: s,
      cx: cx - 30 * s,
      cy: cy + 6 * s,
      angle: -13 * math.pi / 180,
      outlineP: _phase(progress, _c1OutlineStart, _c1OutlineEnd),
      symbolP: _phase(progress, _c1SymbolStart, _c1SymbolEnd),
      opacity: opacity,
      symbol: _Symbol.eye,
    );

    _drawCard(
      canvas: canvas,
      paint: paint,
      s: s,
      cx: cx + 30 * s,
      cy: cy - 4 * s,
      angle: 8 * math.pi / 180,
      outlineP: _phase(progress, _c2OutlineStart, _c2OutlineEnd),
      symbolP: _phase(progress, _c2SymbolStart, _c2SymbolEnd),
      opacity: opacity,
      symbol: _Symbol.hexagram,
    );
  }

  void _drawCard({
    required Canvas canvas,
    required Paint paint,
    required double s,
    required double cx,
    required double cy,
    required double angle,
    required double outlineP,
    required double symbolP,
    required double opacity,
    required _Symbol symbol,
  }) {
    if (outlineP <= 0 && symbolP <= 0) return;

    canvas
      ..save()
      ..translate(cx, cy)
      ..rotate(angle);

    if (outlineP > 0) {
      final cardPath =
          Path()..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: 84 * s, height: 124 * s),
              Radius.circular(9 * s),
            ),
          );
      paint.color = color.withValues(alpha: opacity);
      canvas.drawPath(_trim(cardPath, outlineP), paint);
    }

    if (symbolP > 0) {
      final symPath = symbol == _Symbol.eye ? _eyePath(s) : _hexPath(s);
      paint.color = color.withValues(alpha: opacity * 0.82);
      canvas.drawPath(_trim(symPath, symbolP), paint);
    }

    canvas.restore();
  }

  Path _eyePath(double s) {
    final w = 44 * s;
    final h = 22 * s;
    final oy = 8 * s;
    final r = 8 * s;
    return Path()
      ..moveTo(-w / 2, oy)
      ..quadraticBezierTo(0, oy - h / 2, w / 2, oy)
      ..quadraticBezierTo(0, oy + h / 2, -w / 2, oy)
      ..addOval(Rect.fromCenter(center: Offset(0, oy), width: r * 2, height: r * 2));
  }

  Path _hexPath(double s) {
    final path = Path();
    final r = 26.0 * s;
    final up = List.generate(
      3,
      (i) => Offset(
        r * math.cos(-math.pi / 2 + i * 2 * math.pi / 3),
        r * math.sin(-math.pi / 2 + i * 2 * math.pi / 3),
      ),
    );
    path
      ..moveTo(up[0].dx, up[0].dy)
      ..lineTo(up[1].dx, up[1].dy)
      ..lineTo(up[2].dx, up[2].dy)
      ..close();
    final down = List.generate(
      3,
      (i) => Offset(
        r * math.cos(math.pi / 2 + i * 2 * math.pi / 3),
        r * math.sin(math.pi / 2 + i * 2 * math.pi / 3),
      ),
    );
    path
      ..moveTo(down[0].dx, down[0].dy)
      ..lineTo(down[1].dx, down[1].dy)
      ..lineTo(down[2].dx, down[2].dy)
      ..close();
    return path;
  }

  Path _trim(Path source, double progress) {
    if (progress <= 0) return Path();
    if (progress >= 1) return source;
    final result = Path();
    for (final metric in source.computeMetrics()) {
      final len = metric.length * progress;
      if (len > 0) result.addPath(metric.extractPath(0, len), Offset.zero);
    }
    return result;
  }

  @override
  bool shouldRepaint(_TarotCardsPainter old) => old.progress != progress || old.color != color;
}

enum _Symbol { eye, hexagram }
