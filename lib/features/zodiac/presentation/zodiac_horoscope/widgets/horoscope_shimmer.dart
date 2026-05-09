part of '../pages/zodiac_horoscope_page.dart';

class HoroscopeShimmer extends StatelessWidget {
  const HoroscopeShimmer({required this.period, super.key});
  final HoroscopePeriod period;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final baseColor = colors.textSecondary.withValues(alpha: 0.18);
    final highlightColor = colors.textSecondary.withValues(alpha: 0.55);
    final scope = ZodiacHoroscopePageScope.of(context).state;

    Widget sBox({required double width, required double height, double radius = 8}) =>
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FancyContainer(
          width: double.infinity,
          padding: Sp.medium.padAllR,
          borderRadius: Sp.large,
          color: colors.textSecondary.withValues(alpha: 0.05),
          border: Border.all(color: colors.border),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('✨ ', style: m16w700(context)),
                  sBox(width: 80.w, height: 16.h, radius: 4),
                ],
              ),
              Sp.medium.heightBox,
              sBox(width: double.infinity, height: 13.h, radius: 4),
              Sp.xsmall.heightBox,
              sBox(width: double.infinity, height: 13.h, radius: 4),
              Sp.xsmall.heightBox,
              sBox(width: double.infinity, height: 13.h, radius: 4),
              Sp.xsmall.heightBox,
              sBox(width: 180.w, height: 13.h, radius: 4),
            ],
          ),
        ),
        Sp.medium.heightBox,
        FancyContainer(
          width: double.infinity,
          padding: Sp.medium.padAllR,
          borderRadius: Sp.large,
          color: colors.textSecondary.withValues(alpha: 0.05),
          border: Border.all(color: colors.border),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _shimmerStatCell(context, scope.cats[0], sBox)),
                  Container(width: 1, height: 60.h, color: colors.border),
                  Expanded(child: _shimmerStatCell(context, scope.cats[1], sBox)),
                  Container(width: 1, height: 60.h, color: colors.border),
                  Expanded(child: _shimmerStatCell(context, scope.cats[2], sBox)),
                ],
              ),
              Container(height: 1, color: colors.border),
              Row(
                children: [
                  Expanded(child: _shimmerStatCell(context, scope.cats[3], sBox)),
                  Container(width: 1, height: 60.h, color: colors.border),
                  Expanded(child: _shimmerStatCell(context, scope.cats[4], sBox)),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        ),
        Sp.medium.heightBox,
        ...scope.cats.map(
          (cat) => Padding(
            padding: EdgeInsets.only(bottom: Sp.small.h),
            child: FancyContainer(
              width: double.infinity,
              borderRadius: Sp.large,
              color: colors.textSecondary.withValues(alpha: 0.05),
              border: Border.all(color: colors.border),
              child: Padding(
                padding: Sp.medium.padAllR,
                child: Row(
                  children: [
                    Text('${cat.$1} ', style: m16w700(context)),
                    Sp.tiny.widthBox,
                    Expanded(child: sBox(width: 120.w, height: 16.h, radius: 4)),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colors.textSecondary,
                      size: 22.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Sp.small.heightBox,
        FancyContainer(
          width: double.infinity,
          padding: Sp.medium.padAllR,
          borderRadius: Sp.large,
          color: colors.textSecondary.withValues(alpha: 0.05),
          border: Border.all(color: colors.border),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('👑 ', style: m16w700(context)),
                  Sp.xsmall.widthBox,
                  Expanded(child: sBox(width: double.infinity, height: 32.h, radius: 6)),
                ],
              ),
              Sp.medium.heightBox,
              Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sBox(width: double.infinity, height: 12.h, radius: 4),
                      Sp.xsmall.heightBox,
                      sBox(width: double.infinity, height: 12.h, radius: 4),
                      Sp.xsmall.heightBox,
                      sBox(width: 200.w, height: 12.h, radius: 4),
                      Sp.xlarge.heightBox,
                      sBox(width: double.infinity, height: 12.h, radius: 4),
                      Sp.xsmall.heightBox,
                      sBox(width: 160.w, height: 12.h, radius: 4),
                    ],
                  ),
                  Builder(
                    builder: (context) {
                      final colors = context.colors;
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sp.xlarge.w,
                          vertical: Sp.small.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.textPrimary,
                          borderRadius: Sp.xxxlarge.radiusR,
                        ),
                        child: Text(
                          LocaleKeys.horoscope_page_ai_button_label,
                          style: m14w700(context).copyWith(color: colors.textOnPrimary),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Sp.medium.heightBox,
        FancyContainer(
          width: double.infinity,
          padding: Sp.medium.padAllR,
          borderRadius: Sp.large,
          color: colors.textSecondary.withValues(alpha: 0.05),
          border: Border.all(color: colors.border),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sBox(width: 160.w, height: 16.h, radius: 4),
              Sp.medium.heightBox,
              Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  Sp.xsmall.widthBox,
                  Expanded(child: sBox(width: double.infinity, height: 13.h, radius: 4)),
                ],
              ),
              Sp.xsmall.heightBox,
              Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE05A5A),
                    ),
                  ),
                  Sp.xsmall.widthBox,
                  Expanded(child: sBox(width: double.infinity, height: 13.h, radius: 4)),
                ],
              ),
            ],
          ),
        ),
        Sp.medium.heightBox,
        FancyContainer(
          width: double.infinity,
          padding: Sp.medium.padAllR,
          borderRadius: Sp.large,
          color: colors.textSecondary.withValues(alpha: 0.05),
          border: Border.all(color: colors.border),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sBox(width: 120.w, height: 16.h, radius: 4),
              Sp.medium.heightBox,
              Row(
                children: [
                  Icon(Icons.trending_down_rounded, color: const Color(0xFF5A9EE0), size: 18.sp),
                  Sp.xsmall.widthBox,
                  Expanded(child: sBox(width: double.infinity, height: 13.h, radius: 4)),
                ],
              ),
              Sp.small.heightBox,
              Row(
                children: [
                  Icon(Icons.trending_up_rounded, color: const Color(0xFFE05A5A), size: 18.sp),
                  Sp.xsmall.widthBox,
                  Expanded(child: sBox(width: double.infinity, height: 13.h, radius: 4)),
                ],
              ),
            ],
          ),
        ),
        Sp.medium.heightBox,
        FancyContainer(
          width: double.infinity,
          padding: Sp.medium.padAllR,
          borderRadius: Sp.large,
          color: colors.textSecondary.withValues(alpha: 0.05),
          border: Border.all(color: colors.border),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sBox(width: 200.w, height: 16.h, radius: 4),
                    Sp.medium.heightBox,
                    sBox(width: 140.w, height: 36.h, radius: Sp.large),
                  ],
                ),
              ),
              Text('🔔', style: TextStyle(fontSize: 48.sp)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shimmerStatCell(
    BuildContext context,
    (String, String) cat,
    Widget Function({required double width, required double height, double radius}) sBox,
  ) {
    return Padding(
      padding: Sp.small.padAllR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${cat.$1} ', style: m13w500(context)),
              Expanded(
                child: Text(
                  cat.$2.tr(),
                  style: m11w500(context).copyWith(color: context.colors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Sp.xsmall.heightBox,
          sBox(width: 36.w, height: 16.h, radius: 4),
          Sp.xsmall.heightBox,
          sBox(width: double.infinity, height: 5.h, radius: 3),
        ],
      ),
    );
  }
}
