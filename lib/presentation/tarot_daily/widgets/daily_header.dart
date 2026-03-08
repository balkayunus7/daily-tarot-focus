part of '../page/tarot_daily_page.dart';

class DailyHeader extends StatelessWidget {
  const DailyHeader({required this.showFilterSheet, super.key});
  final VoidCallback showFilterSheet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Spacing.largePadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocaleKeys.tarotDailyTitle.tr(), style: m20w700(context)),
              Spacing.xsmallH,
              Text(
                LocaleKeys.tarotDailySubtitle.tr(),
                style: m10w600(context).copyWith(
                  color: context.colors.primary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          ScalingContainer(
            onTap: showFilterSheet,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.colors.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.filter_list, color: context.colors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
