part of '../pages/planetary_hours_page.dart';

class PlanetaryEmptyView extends StatelessWidget {
  const PlanetaryEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = PlanetaryHoursPageScope.of(context).state;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sp.screen.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FancyContainer(
              width: 80.w,
              height: 80.h,
              borderRadius: 100,
              color: colors.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.location_on_outlined,
                color: colors.primary,
                size: 36.sp,
              ),
            ),
            Sp.large.heightBox,
            Text(
              LocaleKeys.planetary_page_empty_title.tr(),
              style: m18w600(context),
              textAlign: TextAlign.center,
            ),
            Sp.small.heightBox,
            Text(
              LocaleKeys.planetary_page_empty_desc.tr(),
              style: m13w400(
                context,
              ).copyWith(color: colors.textSecondary, height: 1.6),
              textAlign: TextAlign.center,
            ),
            Sp.xlarge.heightBox,
            FancyButton(
              text: LocaleKeys.planetary_page_select_city.tr(),
              width: 180.w,
              height: 44.h,
              textStyle: m14w700(
                context,
              ).copyWith(color: colors.textOnPrimary),
              onTap: () => unawaited(scope.pickCity()),
            ),
          ],
        ),
      ),
    );
  }
}
