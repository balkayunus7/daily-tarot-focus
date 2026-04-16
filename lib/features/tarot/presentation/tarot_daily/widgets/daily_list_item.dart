part of '../page/tarot_daily_page.dart';

class _DailyCardListItem extends StatelessWidget {
  const _DailyCardListItem({required this.card, required this.isFirst, required this.isLast});
  final TarotCardModel card;
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
            Sp.medium.widthBox,
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
                Sp.small.widthBox,
                SizedBox(
                  width: 45.w,
                  child: Column(
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
                      Sp.tiny.heightBox,
                      if (card.savedAt != null) ...[
                        Text(
                          card.savedAt!.dAmWithLastDays(context.locale),
                          style: m10w600(context).copyWith(color: dotColor, letterSpacing: 0.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: Sp.large.padHVR(Sp.medium),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: Sp.medium.radiusR,
                    border: Border.all(color: context.colors.border),
                  ),
                  padding: Sp.screen.padAllR,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: dotColor.withValues(alpha: 0.5)),
                          borderRadius: Sp.xsmall.radiusR,
                        ),
                        child: ClipRRect(
                          borderRadius: Sp.xsmall.radiusR,
                          child: Image.asset(
                            card.imagePath,
                            width: 56,
                            height: 80,
                            fit: BoxFit.fill,
                            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded || frame != null) {
                                return child;
                              }
                              return SizedBox(
                                width: 56.w,
                                height: 80.h,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: dotColor.withValues(alpha: 0.1),
                                    borderRadius: Sp.xsmall.radiusR,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 16.w,
                                      height: 16.h,
                                      child: SpinKitFadingCircle(
                                        color: dotColor.withValues(alpha: 0.4),
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Sp.medium.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(card.name, style: m14w700(context)),
                            Sp.small.heightBox,
                            if (card.uprightKeywords.isNotEmpty) ...[
                              Container(
                                padding: Sp.small.padAllR,
                                decoration: BoxDecoration(
                                  border: Border.all(color: dotColor.withValues(alpha: 0.5)),
                                  borderRadius: Sp.xsmall.radiusR,
                                ),
                                child: Text(
                                  card.uprightKeywords.take(3).join(' • '),
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
                      Sp.tiny.widthBox,
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
