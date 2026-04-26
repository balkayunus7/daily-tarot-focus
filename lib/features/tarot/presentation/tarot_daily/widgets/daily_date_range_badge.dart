part of '../page/tarot_daily_page.dart';

class DateRangeBadge extends StatelessWidget {
  const DateRangeBadge({
    required this.filterLabel,
    required this.clearFilter,
    super.key,
  });
  final String filterLabel;
  final VoidCallback clearFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: Sp.large.padXR,
          child: Row(
            children: [
              FancyContainer(
                padding: Sp.small.padHVR(Sp.xsmall),
                color: context.colors.primary.withValues(alpha: 0.05),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.filter_list, size: 14, color: context.colors.secondary),
                    Sp.small.widthBox,
                    Text(
                      filterLabel,
                      style: m12w600(context).copyWith(color: context.colors.secondary),
                    ),
                    Sp.small.widthBox,
                    GestureDetector(
                      onTap: clearFilter,
                      child: Icon(Icons.close, size: 14, color: context.colors.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
