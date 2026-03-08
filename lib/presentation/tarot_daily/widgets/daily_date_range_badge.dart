part of '../page/tarot_daily_page.dart';

class DateRangeBadge extends StatelessWidget {
  const DateRangeBadge({required this.filterLabel, required this.clearFilter, super.key});
  final String filterLabel;
  final VoidCallback clearFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingConsts.large),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.colors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.filter_list,
                      size: 14,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      filterLabel,
                      style: m12w600(
                        context,
                      ).copyWith(color: context.colors.primary),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: clearFilter,
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacing.mediumH,
      ],
    );
  }
}
