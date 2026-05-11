part of '../pages/tarot_reading_page.dart';

class ReadingListItem extends StatelessWidget {
  const ReadingListItem({
    required this.reading,
    required this.isFirst,
    required this.isLast,
    super.key,
  });
  final SavedReadingModel reading;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final colors = context.colors;
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
                      Center(
                        child: SvgPicture.asset(
                          TarotAppAssets.tarotIcon.path,
                          colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                          width: 20,
                          height: 20,
                        ),
                      ),
                      Sp.tiny.heightBox,
                      Text(
                        reading.createdAt.dAmWithLastDays(context.locale),
                        style: m10w600(context).copyWith(color: primary, letterSpacing: 0.5),
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
                            Text(
                              LocaleKeys.tarot_reading_card_reading.tr(
                                args: ['${reading.cardInterpretations.length}'],
                              ),
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
