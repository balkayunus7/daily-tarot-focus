part of '../page/tarot_daily_page.dart';

class _DailyCardListItem extends StatelessWidget {
  const _DailyCardListItem({required this.card, required this.isFirst, required this.isLast});
  final TarotCardModel card;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

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
                      if (card.savedAt != null) ...[
                        Text(
                          card.savedAt!.dAmWithLastDays(context.locale),
                          style: m10w600(context).copyWith(color: primary, letterSpacing: 0.5),
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
                padding: Sp.large.padHVR(Sp.small),
                child: GlassContainer(
                  borderRadius: Sp.medium,
                  glassColor: primary.withValues(alpha: 0.05),
                  borderColor: primary.withValues(alpha: 0.05),
                  padding: Sp.small.padAllR,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: primary.withValues(alpha: 0.3)),
                          borderRadius: Sp.tiny.radiusR,
                        ),
                        child: CustomCacheNetworkImage(
                          imageUrl: card.imageUrl,
                          fit: BoxFit.fitHeight,
                          width: 56.w,
                          height: 84.h,
                        ),
                      ),
                      Sp.medium.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(card.name, style: m14w700(context).copyWith(color: primary)),
                            Sp.small.heightBox,
                            if (card.uprightKeywords.isNotEmpty) ...[
                              Container(
                                padding: Sp.small.padAllR,
                                decoration: BoxDecoration(
                                  color: context.colors.accent.withValues(alpha: 0.5),
                                  borderRadius: Sp.small.radiusR,
                                ),
                                child: Text(
                                  card.uprightKeywords.take(3).join(' • '),
                                  style: m10w600(context).copyWith(
                                    color: context.colors.textOnSecondary,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Sp.xsmall.widthBox,
                      Icon(
                        Icons.chevron_right,
                        color: context.colors.secondary,
                        size: 20,
                      ),
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
