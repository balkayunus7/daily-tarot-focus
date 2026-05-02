part of '../pages/tarot_reading_page.dart';

class ReadingListItem extends StatelessWidget {
  const ReadingListItem({
    required this.reading,
    required this.isFirst,
    required this.isLast,
  });
  final SavedReadingModel reading;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final colors = context.colors;
    final cardCount = reading.cardInterpretations.length;
    final preview =
        reading.generalInterpretation.length > 80
            ? '${reading.generalInterpretation.substring(0, 80)}...'
            : reading.generalInterpretation;

    return ScalingContainer(
      onTap: () => context.push(AppRoutes.tarotSavedReadingDetail, extra: reading),
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
                        primary.withValues(alpha: isFirst ? 1.0 : 0.6),
                        primary.withValues(alpha: isLast ? 0.0 : 0.6),
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
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$cardCount',
                          style: m12w600(context).copyWith(color: primary),
                        ),
                      ),
                      Sp.tiny.heightBox,
                      Text(
                        reading.createdAt.dAmWithLastDays(context.locale),
                        style: m9w700(context).copyWith(color: primary, letterSpacing: 0.3),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: Sp.large.padHVR(Sp.small),
                child: FancyContainer(
                  color: primary.withValues(alpha: 0.05),
                  padding: Sp.medium.padAllR,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (reading.question != null && reading.question!.isNotEmpty)
                              Text(
                                reading.question!,
                                style: m13w500(context).copyWith(color: primary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            else
                              Text(
                                '$cardCount Card Reading',
                                style: m13w500(context).copyWith(color: primary),
                              ),
                            Sp.xsmall.heightBox,
                            Text(
                              preview,
                              style: m11w400(context).copyWith(
                                color: colors.textSecondary,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Sp.xsmall.widthBox,
                      Icon(Icons.chevron_right, color: colors.secondary, size: 20),
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
