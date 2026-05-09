part of '../pages/tarot_reading_page.dart';

class ReadingHeader extends StatelessWidget {
  const ReadingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ReadingPageScope.of(context).state;
    final colors = context.colors;

    return Padding(
      padding: Sp.large.padAllR,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocaleKeys.tarot_daily_title.tr(), style: m20w700(context)),
              Sp.xsmall.heightBox,
              Text(
                LocaleKeys.tarot_daily_subtitle.tr(),
                style: m10w600(context).copyWith(color: colors.primary, letterSpacing: 1.5),
              ),
            ],
          ),
          ScalingContainer(
            onTap: () async {
              await DateRangeSheet.showFilterBottomSheet(
                context: context,
                selectedFilter: scope.selectedFilter,
                customDateRange: scope.customDateRange,
                updateFilter: scope.updateFilter,
              );
            },
            child: FancyContainer(
              width: Sp.xxxlarge.w,
              height: Sp.xxxlarge.h,
              borderRadius: 100,
              color: colors.primary.withValues(alpha: 0.5),
              child: Center(child: Icon(Icons.filter_list, color: colors.textOnPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}
