part of '../pages/numerology_result_page.dart';

class NumerologyNumberCard extends StatelessWidget {
  const NumerologyNumberCard({
    required this.number,
    required this.sectionLabel,
    required this.sectionIntro,
    super.key,
  });

  final int number;
  final String sectionLabel;
  final String sectionIntro;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final meaning = NumerologyMeaning.forNumber(number);
    final isMaster = NumerologyCalculator.masterNumbers.contains(number);

    return FancyContainer(
      width: double.infinity,
      padding: Sp.large.padAllR,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colors.gradientStart, colors.gradientEnd],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.32),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: m18w700(context).copyWith(
                    fontSize: 28.sp,
                    color: colors.textOnPrimary,
                    height: 1,
                  ),
                ),
              ),
              Sp.medium.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sectionLabel,
                      style: m11w500(context).copyWith(
                        color: colors.textSecondary,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Sp.tiny.heightBox,
                    Text(meaning.titleKey.tr(), style: m16w700(context)),
                    if (isMaster) ...[
                      Sp.tiny.heightBox,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 12.sp, color: colors.accent),
                          Sp.xsmall.widthBox,
                          Text(
                            LocaleKeys.numerology_page_master_badge.tr(),
                            style: m10w500(context).copyWith(
                              color: colors.accent,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Sp.medium.heightBox,
          Container(height: 1, color: colors.border),
          Sp.medium.heightBox,
          Text(
            sectionIntro,
            style: m12w500(context).copyWith(color: colors.textSecondary.withValues(alpha: 0.85)),
          ),
          Sp.small.heightBox,
          Text(
            meaning.descKey.tr(),
            style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.65),
          ),
        ],
      ),
    );
  }
}
