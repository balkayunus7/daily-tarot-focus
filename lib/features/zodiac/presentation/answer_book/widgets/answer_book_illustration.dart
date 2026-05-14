part of '../pages/answer_book_page.dart';

class BookIllustration extends StatelessWidget {
  const BookIllustration({
    required this.flipValue,
    required this.hasCompletedFlipCycle,
    required this.settleProgress,
    required this.size,
    super.key,
  });
  final double flipValue;
  final bool hasCompletedFlipCycle;
  final double settleProgress;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CustomPaint(
      size: Size(size, size),
      painter: _BookPainter(
        primaryColor: colors.primary,
        secondaryColor: colors.secondary,
        accentColor: colors.accent,
        flipValue: flipValue,
        hasCompletedFlipCycle: hasCompletedFlipCycle,
        settleProgress: settleProgress,
      ),
    );
  }
}

class _BookPainter extends CustomPainter {
  const _BookPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.flipValue,
    required this.hasCompletedFlipCycle,
    required this.settleProgress,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final double flipValue;
  final bool hasCompletedFlipCycle;
  final double settleProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final bookW = size.width * 0.82;
    final bookH = size.height * 0.72;
    final bookLeft = cx - bookW / 2;
    final bookTop = cy - bookH / 2 + size.height * 0.04;

    const radius = Radius.circular(6);

    // Shadow
    final shadowPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bookLeft + 8, bookTop + 12, bookW, bookH),
        radius,
      ),
      shadowPaint,
    );

    // Left page (cover)
    final leftRect = Rect.fromLTWH(bookLeft, bookTop, bookW / 2, bookH);
    final leftGrad =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(primaryColor, Colors.black, 0.3)!,
              Color.lerp(secondaryColor, Colors.black, 0.1)!,
            ],
          ).createShader(leftRect);

    canvas.drawRRect(
      RRect.fromRectAndCorners(leftRect, topLeft: radius, bottomLeft: radius),
      leftGrad,
    );

    // Right page (pages)
    final rightRect = Rect.fromLTWH(
      bookLeft + bookW / 2,
      bookTop,
      bookW / 2,
      bookH,
    );
    final pageColor = Color.lerp(Colors.white, const Color(0xFFF5EFE6), 0.7)!;
    final rightGrad =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [pageColor.withValues(alpha: 0.85), pageColor],
          ).createShader(rightRect);

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rightRect,
        topRight: radius,
        bottomRight: radius,
      ),
      rightGrad,
    );

    // Spine
    final spinePaint =
        Paint()
          ..color = Color.lerp(primaryColor, Colors.black, 0.5)!
          ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(cx - 4, bookTop, 8, bookH),
      spinePaint,
    );

    // Left cover ornament (star/sparkle shape)
    _drawCoverOrnament(
      canvas,
      Offset(bookLeft + bookW / 4, bookTop + bookH / 2),
      bookH * 0.18,
    );

    if (settleProgress == 0) {
      _drawFlippingPages(canvas, bookLeft, bookTop, bookW, bookH, radius);
    } else {
      _drawSettlingPages(
        canvas,
        bookLeft,
        bookTop,
        bookW,
        bookH,
        radius,
      );
    }
  }

  void _drawSettlingPages(
    Canvas canvas,
    double bookLeft,
    double bookTop,
    double bookW,
    double bookH,
    Radius radius,
  ) {
    _drawSettledPages(canvas, bookLeft, bookTop, bookW, bookH, radius);
    if (settleProgress < 1) {
      _drawClosingLeafPage(canvas, bookLeft, bookTop, bookW, bookH, radius);
    }
  }

  void _drawSettledPages(
    Canvas canvas,
    double bookLeft,
    double bookTop,
    double bookW,
    double bookH,
    Radius radius,
  ) {
    final cx = bookLeft + bookW / 2;
    final pageW = bookW / 2;
    final pageRect = Rect.fromLTWH(cx, bookTop, pageW, bookH);

    final pagePaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [
              Color(0xFFE6D7BD),
              Color(0xFFF8F0E3),
              Color(0xFFF2E6D3),
            ],
          ).createShader(pageRect);

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        pageRect,
        topRight: radius,
        bottomRight: radius,
      ),
      pagePaint,
    );

    final creasePaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.08)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawRect(Rect.fromLTWH(cx, bookTop, 5, bookH), creasePaint);

    final linePaint =
        Paint()
          ..color = Colors.grey.withValues(alpha: 0.18)
          ..strokeWidth = 0.6;
    for (var j = 1; j <= 5; j++) {
      final y = bookTop + bookH * (j / 6.5);
      final marginH = pageW * 0.12;
      canvas.drawLine(
        Offset(cx + marginH, y),
        Offset(cx + pageW - marginH, y),
        linePaint,
      );
    }
  }

  void _drawClosingLeafPage(
    Canvas canvas,
    double bookLeft,
    double bookTop,
    double bookW,
    double bookH,
    Radius radius,
  ) {
    final cx = bookLeft + bookW / 2;
    final pageW = bookW / 2;
    final pivotY = bookTop + bookH / 2;
    final eased = Curves.easeOutCubic.transform(settleProgress);
    final angle = (1 - eased) * pi / 2;

    canvas.save();

    final matrix =
        Matrix4.identity()
          ..setEntry(3, 2, 0.0018)
          ..translate(cx, pivotY)
          ..rotateY(angle)
          ..translate(-cx, -pivotY);
    canvas.transform(matrix.storage);

    final brightness = 0.86 + eased * 0.14;
    final leafColor =
        Color.lerp(
          const Color(0xFFE0CFB3),
          const Color(0xFFF8F0E3),
          brightness,
        )!;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(cx, bookTop, pageW, bookH),
        topRight: radius,
        bottomRight: radius,
      ),
      Paint()..color = leafColor,
    );

    final shadowOpacity = (1 - eased) * 0.18;
    if (shadowOpacity > 0) {
      canvas.drawRect(
        Rect.fromLTWH(cx, bookTop, pageW * 0.08, bookH),
        Paint()
          ..color = Colors.black.withValues(alpha: shadowOpacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    final lineOpacity = 0.16 + eased * 0.08;
    final linePaint =
        Paint()
          ..color = Colors.grey.withValues(alpha: lineOpacity)
          ..strokeWidth = 0.6;
    for (var j = 1; j <= 5; j++) {
      final y = bookTop + bookH * (j / 6.5);
      final marginH = pageW * 0.12;
      canvas.drawLine(
        Offset(cx + marginH, y),
        Offset(cx + pageW - marginH, y),
        linePaint,
      );
    }

    canvas.restore();
  }

  void _drawCoverOrnament(Canvas canvas, Offset center, double r) {
    final paint =
        Paint()
          ..color = accentColor.withValues(alpha: 0.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;

    // Simple 6-pointed star
    for (var i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final outer = Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      );
      final inner = Offset(
        center.dx + r * 0.4 * cos(angle + pi / 6),
        center.dy + r * 0.4 * sin(angle + pi / 6),
      );
      canvas
        ..drawLine(center, outer, paint)
        ..drawLine(outer, inner, paint..strokeWidth = 0.8);
    }

    canvas.drawCircle(
      center,
      r * 0.18,
      Paint()
        ..color = accentColor.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawFlippingPages(
    Canvas canvas,
    double bookLeft,
    double bookTop,
    double bookW,
    double bookH,
    Radius radius,
  ) {
    final cx = bookLeft + bookW / 2;
    final pageW = bookW / 2;
    const unreadColor = Color(0xFFF0E8D8);

    if (hasCompletedFlipCycle) {
      _drawCompletedLeftPageStack(
        canvas,
        bookLeft,
        bookTop,
        bookW,
        bookH,
        radius,
      );
    }

    // Sağ taraf: henüz çevrilmemiş sayfa yığını (kalınlık hissi)
    for (var i = 3; i >= 1; i--) {
      final dx = i * 0.8;
      final dy = i * 0.4;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(cx + dx, bookTop + dy, pageW - dx, bookH - dy * 2),
          topRight: radius,
          bottomRight: radius,
        ),
        Paint()..color = unreadColor.withValues(alpha: 0.35 - i * 0.05),
      );
    }

    final pageProgresses =
        <double>[0, 0.22, 0.44].map((delay) {
          final raw = ((flipValue - delay) / 0.56).clamp(0.0, 1.0);
          return Curves.easeInOutCubic.transform(raw);
        }).toList();

    final pivotY = bookTop + bookH / 2;

    final leftPages =
        pageProgresses.where((p) => p >= 0.5).toList()
          ..sort((a, b) => b.compareTo(a));
    final rightPages =
        pageProgresses.where((p) => p < 0.5).toList()
          ..sort((a, b) => a.compareTo(b));

    for (final progress in leftPages) {
      _drawSingleFlipPage(
        canvas,
        cx,
        pivotY,
        bookTop,
        pageW,
        bookH,
        progress,
        radius,
      );
    }
    for (final progress in rightPages) {
      _drawSingleFlipPage(
        canvas,
        cx,
        pivotY,
        bookTop,
        pageW,
        bookH,
        progress,
        radius,
      );
    }
  }

  void _drawCompletedLeftPageStack(
    Canvas canvas,
    double bookLeft,
    double bookTop,
    double bookW,
    double bookH,
    Radius radius,
  ) {
    final pageW = bookW / 2;

    for (var i = 3; i >= 0; i--) {
      final dx = i * 0.7;
      final dy = i * 0.35;
      final rect = Rect.fromLTWH(
        bookLeft + dx,
        bookTop + dy,
        pageW - dx,
        bookH - dy * 2,
      );
      final color =
          Color.lerp(
            const Color(0xFFE2D2B7),
            const Color(0xFFF6ECDD),
            0.55 + i * 0.08,
          )!;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: radius,
          bottomLeft: radius,
        ),
        Paint()..color = color,
      );

      if (i == 0) {
        final linePaint =
            Paint()
              ..color = Colors.grey.withValues(alpha: 0.20)
              ..strokeWidth = 0.6;
        for (var j = 1; j <= 4; j++) {
          final y = rect.top + rect.height * (j / 5.5);
          final marginH = rect.width * 0.10;
          canvas.drawLine(
            Offset(rect.left + marginH, y),
            Offset(rect.right - marginH, y),
            linePaint,
          );
        }
      }
    }
  }

  void _drawSingleFlipPage(
    Canvas canvas,
    double cx,
    double pivotY,
    double bookTop,
    double pageW,
    double bookH,
    double phase,
    Radius radius,
  ) {
    final angle = phase * pi; // 0 → π (gerçek 180° dönüş)
    final isFront = phase < 0.5;

    canvas.save();

    // Spine (cx, pivotY) etrafında Y ekseninde 3D perspektifli dönüş
    // pivotY kitabın dikey merkezinde — perspektif distorsiyonu üst+alt simetrik
    final matrix =
        Matrix4.identity()
          ..setEntry(3, 2, 0.0018)
          ..translate(cx, pivotY)
          ..rotateY(angle)
          ..translate(-cx, -pivotY);
    canvas.transform(matrix.storage);

    // Sayfa rengi: ön yüz açık, arka yüz biraz daha koyu
    final basePage =
        isFront ? const Color(0xFFF5EFE6) : const Color(0xFFE4D6BC);
    // Açıyla hafif gölgelenme — düz konumda parlak, açılı konumda hafif koyu
    final brightness = 0.82 + cos(angle).abs() * 0.18;
    final pageColor =
        Color.lerp(const Color(0xFF6B5840), basePage, brightness)!;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(cx, bookTop, pageW, bookH),
        topRight: radius,
        bottomRight: radius,
      ),
      Paint()..color = pageColor,
    );

    // Ön yüzdeyken yazı çizgileri — düz olduğunda görünür, açılınca silikleşir
    if (isFront) {
      final visibility = cos(angle).clamp(0.0, 1.0);
      if (visibility > 0.25) {
        final linePaint =
            Paint()
              ..color = Colors.grey.withValues(alpha: 0.22 * visibility)
              ..strokeWidth = 0.6;
        for (var j = 1; j <= 4; j++) {
          final y = bookTop + bookH * (j / 5.5);
          final marginH = pageW * 0.08;
          canvas.drawLine(
            Offset(cx + marginH, y),
            Offset(cx + pageW - marginH, y),
            linePaint,
          );
        }
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_BookPainter old) =>
      old.flipValue != flipValue ||
      old.hasCompletedFlipCycle != hasCompletedFlipCycle ||
      old.settleProgress != settleProgress ||
      old.primaryColor != primaryColor;
}
