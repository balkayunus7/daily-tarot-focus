part of '../page/tarot_daily_page.dart';

class DailyHeader extends StatelessWidget {
  const DailyHeader({required this.showFilterSheet, super.key});
  final VoidCallback showFilterSheet;

  @override
  Widget build(BuildContext context) {
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
                style: m10w600(context).copyWith(color: context.colors.primary, letterSpacing: 1.5),
              ),
            ],
          ),
          ScalingContainer(
            onTap: showFilterSheet,
            child: FancyContainer(
              width: Sp.xxxlarge.w,
              height: Sp.xxxlarge.h,
              borderRadius: 100,
              color: context.colors.primary.withValues(alpha: 0.5),
              child: Center(child: Icon(Icons.filter_list, color: context.colors.textOnPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}
