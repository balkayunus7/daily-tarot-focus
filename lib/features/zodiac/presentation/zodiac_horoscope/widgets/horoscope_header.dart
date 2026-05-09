part of '../pages/zodiac_horoscope_page.dart';

class HoroscopeHeader extends StatelessWidget {
  const HoroscopeHeader({required this.sign, super.key});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sp.screen.w, vertical: Sp.small.h),
      child: Row(
        children: [
          FancyContainer(
            borderRadius: Sp.huge,
            width: 64.w,
            height: 64.h,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.gradientStart, colors.gradientEnd],
            ),
            child: Center(
              child: SvgPicture.asset(
                sign.svgPath,
                width: 30.w,
                height: 30.h,
                colorFilter: ColorFilter.mode(colors.textOnPrimary, BlendMode.srcIn),
              ),
            ),
          ),
          Sp.medium.widthBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sign.localizedName, style: m24w700(context)),
              Sp.tiny.heightBox,
              Text(
                '(${sign.dateRangeKey.tr()})',
                style: m13w400(context).copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
