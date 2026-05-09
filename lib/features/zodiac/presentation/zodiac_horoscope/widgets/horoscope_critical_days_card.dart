part of '../pages/zodiac_horoscope_page.dart';

class CriticalDaysCard extends StatelessWidget {
  const CriticalDaysCard({required this.criticalDays, super.key});
  final HoroscopeCriticalDaysModel criticalDays;

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
          Text(LocaleKeys.horoscope_page_critical_days_title.tr(), style: m16w700(context)),
          Sp.medium.heightBox,
          _DayRow(
            icon: Icons.trending_down_rounded,
            iconColor: const Color(0xFF5A9EE0),
            label: LocaleKeys.horoscope_page_challenging_label.tr(),
            value: criticalDays.challenging,
          ),
          Sp.small.heightBox,
          _DayRow(
            icon: Icons.trending_up_rounded,
            iconColor: const Color(0xFFE05A5A),
            label: LocaleKeys.horoscope_page_highlight_label.tr(),
            value: criticalDays.highlight,
          ),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18.sp),
        Sp.xsmall.widthBox,
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '$label: ', style: m13w600(context)),
                TextSpan(
                  text: value,
                  style: m13w400(context).copyWith(
                    color: context.colors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
