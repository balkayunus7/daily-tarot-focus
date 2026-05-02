part of '../pages/tarot_reading_page.dart';

class ReadingDateRangeBadge extends StatelessWidget {
  const ReadingDateRangeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ReadingPageScope.of(context).state;
    return Padding(
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
                  scope.filterLabel,
                  style: m12w600(context).copyWith(color: context.colors.secondary),
                ),
                Sp.small.widthBox,
                GestureDetector(
                  onTap: scope.clearFilter,
                  child: Icon(Icons.close, size: 14, color: context.colors.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
