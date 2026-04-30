part of '../pages/tarot_explore_page.dart';

class ExploreThreeCardFlowCard extends StatelessWidget {
  const ExploreThreeCardFlowCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: () async {
        context.read<TarotBloc>().addSetFlowType(flowType: TarotFlowType.threeCard);
        await context.push(AppRoutes.tarotQuestionStep1);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.gradientStart, colors.gradientEnd],
          ),
          borderRadius: Sp.large.radiusR,
          border: Border.all(color: colors.border, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: Sp.large.radiusR,
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _CosmicBackgroundPainter())),
              Padding(
                padding: Sp.large.padAllR,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.explore_page_ask_question_title.tr(),
                          style: m16w600(context).copyWith(color: colors.textOnPrimary),
                        ),
                        Sp.tiny.heightBox,
                        Text(
                          LocaleKeys.explore_page_tarot_reading_desc.tr(),
                          style: m12w400(context).copyWith(
                            color: colors.textOnPrimary.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IgnorePointer(
                      child: UnconstrainedBox(
                        alignment: Alignment.centerLeft,
                        child: FancyButton(
                          height: 36.h,
                          padding: Sp.small.padXR,
                          onTap: () {},
                          backgroundColor: colors.buttonOnGradient,
                          text: LocaleKeys.explore_page_ask_question_button.tr(),
                          textStyle: m12w600(context).copyWith(color: colors.textOnPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CosmicBackgroundPainter extends CustomPainter {
  static const _stars = [
    [0.62, 0.08],
    [0.72, 0.22],
    [0.80, 0.12],
    [0.90, 0.30],
    [0.68, 0.48],
    [0.85, 0.55],
    [0.76, 0.70],
    [0.95, 0.18],
    [0.64, 0.82],
    [0.88, 0.75],
    [0.57, 0.38],
    [0.93, 0.90],
    [0.75, 0.92],
    [0.60, 0.60],
    [0.70, 0.42],
    [0.98, 0.65],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final haloPaint = Paint()..color = const Color(0x26FFFFFF);
    final corePaint = Paint()..color = const Color(0xCCFFFFFF);

    for (final pos in _stars) {
      final center = Offset(size.width * pos[0], size.height * pos[1]);
      canvas
        ..drawCircle(center, 2.5, haloPaint)
        ..drawCircle(center, 1, corePaint);
    }

    // Bokeh glow spots
    final glowPaint =
        Paint()
          ..color = const Color(0x14FFFFFF)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    const bokeh = [
      [0.78, 0.25],
      [0.88, 0.65],
      [0.65, 0.80],
    ];
    for (final pos in bokeh) {
      canvas.drawCircle(Offset(size.width * pos[0], size.height * pos[1]), 10, glowPaint);
    }

    // Decorative crescent arc on the right
    final arcPaint =
        Paint()
          ..color = const Color(0x1AFFFFFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.85, size.height * 0.5),
        width: size.height * 0.75,
        height: size.height * 0.75,
      ),
      -1.2,
      2.4,
      false,
      arcPaint,
    );

    // Second concentric arc (thinner, more transparent)
    final arcPaint2 =
        Paint()
          ..color = const Color(0x0DFFFFFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.85, size.height * 0.5),
        width: size.height * 1.1,
        height: size.height * 1.1,
      ),
      -1,
      2,
      false,
      arcPaint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
