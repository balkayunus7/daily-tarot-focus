part of '../page/tarot_daily_page.dart';

class _DailyCardListItem extends StatelessWidget {
  const _DailyCardListItem({required this.card, required this.isFirst, required this.isLast});
  final TarotCard card;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = context.colors.primary;

    return ScalingContainer(
      onTap: () => context.push(AppRoutes.tarotDailyDetail, extra: card),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Spacing.mediumW,
            Row(
              children: [
                Container(
                  width: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        dotColor.withValues(alpha: isFirst ? 1.0 : 0.6),
                        dotColor.withValues(alpha: isLast ? 0.0 : 0.6),
                      ],
                    ),
                  ),
                ),
                Spacing.smallW,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        TarotAppAssets.tarotIcon.path,
                        colorFilter: ColorFilter.mode(dotColor, BlendMode.srcIn),
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Spacing.tinyH,
                    if (card.savedAt != null) ...[
                      Text(
                        card.savedAt!.dAmWithLastDays(context.locale),
                        style: m10w600(context).copyWith(color: dotColor, letterSpacing: 0.5),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: Spacing.hLargeVMediumPad,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: Spacing.defaultBorderRadius,
                    border: Border.all(color: context.colors.border),
                  ),
                  padding: Spacing.defaultPadding,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: dotColor.withValues(alpha: 0.5)),
                          borderRadius: Spacing.xsmallBorderRadius,
                        ),
                        child: ClipRRect(
                          borderRadius: Spacing.xsmallBorderRadius,
                          child: Image.asset(
                            card.imagePath,
                            width: 56,
                            height: 80,
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded || frame != null) {
                                return child;
                              }
                              return SizedBox(
                                width: 56,
                                height: 80,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: dotColor.withValues(alpha: 0.1),
                                    borderRadius: Spacing.xsmallBorderRadius,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: dotColor.withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Spacing.mediumW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(card.title, style: m14w700(context)),
                            Spacing.smallH,
                            if (card.motto.isNotEmpty) ...[
                              Container(
                                padding: Spacing.smallPadding,
                                decoration: BoxDecoration(
                                  border: Border.all(color: dotColor.withValues(alpha: 0.5)),
                                  borderRadius: Spacing.xsmallBorderRadius,
                                ),
                                child: Text(
                                  card.motto,
                                  style: m10w600(context).copyWith(
                                    color: dotColor,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Spacing.tinyW,
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
