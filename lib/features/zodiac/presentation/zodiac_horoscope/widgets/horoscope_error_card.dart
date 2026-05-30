part of '../pages/zodiac_horoscope_page.dart';

class HoroscopeErrorCard extends StatelessWidget {
  const HoroscopeErrorCard({required this.period, super.key});
  final HoroscopePeriod period;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = ZodiacHoroscopePageScope.of(context).state;

    return Padding(
      padding: Sp.xlarge.padHR,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => scope.generateHoroscope(period),
            child: FancyContainer(
              width: 72.w,
              height: 72.h,
              borderRadius: 100,
              color: colors.error.withValues(alpha: 0.1),
              child: Icon(
                Icons.restart_alt_rounded,
                color: colors.error,
                size: 36.sp,
              ),
            ),
          ),
          Sp.large.heightBox,
          Text(
            LocaleKeys.horoscope_page_generation_error.tr(),
            style: m16w600(context),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
