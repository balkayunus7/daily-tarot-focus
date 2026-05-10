part of '../pages/zodiac_horoscope_page.dart';

class TipsCard extends StatelessWidget {
  const TipsCard({required this.period, required this.tips, super.key});
  final HoroscopePeriod period;
  final List<HoroscopeTipModel> tips;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.horoscope_page_tips_title.tr(args: [period.periodWord]),
            style: m16w700(context),
          ),
          Sp.medium.heightBox,
          ...tips.map(
            (tip) => Padding(
              padding: EdgeInsets.only(bottom: Sp.small.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 10.w,
                    height: 10.h,
                    margin: EdgeInsets.only(top: Sp.xsmall.h),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tip.isAdvice ? colors.success : colors.error,
                    ),
                  ),
                  Sp.xsmall.widthBox,
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${tip.isAdvice ? LocaleKeys.horoscope_page_advice_label.tr() : LocaleKeys.horoscope_page_warning_label.tr()}: ',
                            style: m13w600(context).copyWith(
                              color: tip.isAdvice ? colors.success : colors.error,
                            ),
                          ),
                          TextSpan(
                            text: tip.text,
                            style: m13w400(context).copyWith(
                              color: colors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
