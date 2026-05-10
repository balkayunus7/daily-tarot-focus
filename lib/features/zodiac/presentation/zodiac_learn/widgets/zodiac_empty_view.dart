part of '../pages/zodiac_learn_page.dart';

class ZodiacEmptyView extends StatelessWidget {
  const ZodiacEmptyView({required this.type, super.key});
  final DiscoverZodiacType type;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = ZodiacLearnPageScope.of(context).state;

    Future<void> showBirthSheet(BuildContext context, ZodiacLearnPageMixin scope) {
      return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: context.colors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(Sp.xlarge.r)),
        ),
        builder: (_) {
          return BirthInputSheet(
            type: type,
            onSubmit: (date, time, latitude, longitude, zoneName) async {
              Navigator.of(context).pop();
              if (type.isRising) {
                await scope.calculateRising(
                  birthDate: date,
                  birthTime: time,
                  latitude: latitude!,
                  longitude: longitude!,
                  zoneName: zoneName,
                );
              } else {
                await scope.calculateMoon(birthDate: date, birthTime: time);
              }
            },
          );
        },
      );
    }

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
                type.isRising ? Icons.arrow_upward : Icons.nightlight_round,
                color: colors.primary,
                size: 36.sp,
              ),
            ),
            Sp.large.heightBox,
            Text(type.title, style: m18w600(context), textAlign: TextAlign.center),
            Sp.small.heightBox,
            Text(
              type.description,
              style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.6),
              textAlign: TextAlign.center,
            ),
            Sp.xlarge.heightBox,
            ValueListenableBuilder<bool>(
              valueListenable: scope.isCalculating,
              builder: (context, calculating, _) {
                return FancyButton(
                  text: LocaleKeys.zodiac_page_calculate.tr(),
                  width: 180.w,
                  height: 44.h,
                  isLoading: calculating,
                  isDisabled: calculating,
                  textStyle: m14w700(context).copyWith(color: colors.textOnPrimary),
                  onTap: () => unawaited(showBirthSheet(context, scope)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
