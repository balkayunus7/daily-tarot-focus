part of '../pages/numerology_result_page.dart';

class NumerologyResultHeader extends StatelessWidget {
  const NumerologyResultHeader({required this.result, super.key});
  final NumerologyResultModel result;

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd / $mm / ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final meaning = NumerologyMeaning.forNumber(result.lifePath);
    final isMaster = NumerologyCalculator.masterNumbers.contains(result.lifePath);

    return Column(
      children: [
        Text(
          LocaleKeys.numerology_page_header_label.tr(),
          style: m13w500(context).copyWith(
            color: colors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        Sp.tiny.heightBox,
        Text(
          _formatDate(result.birthDate),
          style: m18w700(context),
        ),
        Sp.large.heightBox,
        SizedBox(
          width: 200.r,
          height: 200.r,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _LifePathHaloPainter(
                    primary: colors.primary,
                    accent: colors.accent,
                  ),
                ),
              ),
              Container(
                width: 110.r,
                height: 110.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colors.gradientStart, colors.gradientEnd],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.45),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${result.lifePath}',
                  style: m24w700(context).copyWith(
                    fontSize: 56.sp,
                    color: colors.textOnPrimary,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        Sp.large.heightBox,
        Text(
          LocaleKeys.numerology_page_section_life_path.tr(),
          style: m11w500(context).copyWith(
            color: colors.textSecondary,
            letterSpacing: 1.4,
          ),
        ),
        Sp.tiny.heightBox,
        Text(meaning.titleKey.tr(), style: m18w700(context).copyWith(color: colors.success)),
        if (isMaster) ...[
          Sp.small.heightBox,
          FancyContainer(
            borderRadius: Sp.large,
            padding: EdgeInsets.symmetric(horizontal: Sp.medium.w, vertical: Sp.tiny.h),
            color: colors.accent.withValues(alpha: 0.18),
            border: Border.all(color: colors.accent.withValues(alpha: 0.4)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 14.sp, color: colors.accent),
                Sp.xsmall.widthBox,
                Text(
                  LocaleKeys.numerology_page_master_badge.tr(),
                  style: m11w500(context).copyWith(
                    color: colors.accent,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
        Sp.medium.heightBox,
        Padding(
          padding: Sp.medium.padHR,
          child: Text(
            meaning.descKey.tr(),
            style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.65),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _LifePathHaloPainter extends CustomPainter {
  const _LifePathHaloPainter({required this.primary, required this.accent});
  final Color primary;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.45;

    canvas
      ..drawCircle(
        center,
        radius,
        Paint()
          ..color = primary.withValues(alpha: 0.18)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      )
      ..drawCircle(
        center,
        radius * 0.82,
        Paint()
          ..color = accent.withValues(alpha: 0.14)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6,
      );

    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * pi / 180;
      final isMajor = i % 3 == 0;
      dotPaint.color = Colors.white.withValues(alpha: isMajor ? 0.7 : 0.32);
      canvas.drawCircle(
        Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle)),
        isMajor ? 2.0 : 1.0,
        dotPaint,
      );
    }

    final spokePaint =
        Paint()
          ..color = primary.withValues(alpha: 0.22)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.7;
    for (var i = 0; i < 8; i++) {
      final angle = (i * 45) * pi / 180;
      canvas.drawLine(
        Offset(
          center.dx + radius * 0.62 * cos(angle),
          center.dy + radius * 0.62 * sin(angle),
        ),
        Offset(
          center.dx + radius * 0.78 * cos(angle),
          center.dy + radius * 0.78 * sin(angle),
        ),
        spokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_LifePathHaloPainter old) => old.primary != primary || old.accent != accent;
}
