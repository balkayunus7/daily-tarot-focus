part of '../pages/tarot_reading_detail_page.dart';

class CardsTab extends StatelessWidget {
  const CardsTab({required this.cards, required this.spread, super.key});
  final List<TarotSelectedReadingCard> cards;
  final TarotSpreadModel? spread;

  @override
  Widget build(BuildContext context) {
    final sorted = [...cards]..sort((a, b) => a.positionIndex.compareTo(b.positionIndex));
    return ListView(
      padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.large.h, Sp.screen.w, Sp.xxxlarge.h),
      children: [
        if (spread != null) ...[
          _SpreadInfoCard(spread: spread!),
          Sp.medium.heightBox,
        ],
        for (final card in sorted) ...[
          _CardsCardRow(card: card),
          Sp.small.heightBox,
        ],
      ],
    );
  }
}

class _SpreadInfoCard extends StatelessWidget {
  const _SpreadInfoCard({required this.spread});
  final TarotSpreadModel spread;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Sp.large.w, vertical: Sp.large.h),
      decoration: BoxDecoration(
        color: colors.textSecondary.withValues(alpha: 0.06),
        borderRadius: Sp.large.radiusR,
      ),
      child: Column(
        children: [
          SpreadLayoutPreview(
            positions: spread.positions.asList(),
            showIndex: true,
            cardWidth: 48,
            cardHeight: 72,
            spacing: 6,
          ),
          Sp.medium.heightBox,
          Text(
            LocaleKeys.tarot_reading_spread_label.tr(),
            style: m10w500(context).copyWith(color: colors.textSecondary, letterSpacing: 2),
          ),
          Sp.tiny.heightBox,
          Text(spread.title, style: m18w700(context), textAlign: TextAlign.center),
          if (spread.description.isNotEmpty) ...[
            Sp.small.heightBox,
            Text('• • •', style: m12w400(context).copyWith(color: colors.textSecondary)),
            Sp.small.heightBox,
            Text(
              spread.description,
              style: m12w400(context).copyWith(color: colors.textSecondary, height: 1.55),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _CardsCardRow extends StatelessWidget {
  const _CardsCardRow({required this.card});
  final TarotSelectedReadingCard card;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.all(Sp.medium.w),
      decoration: BoxDecoration(
        color: colors.textSecondary.withValues(alpha: 0.06),
        borderRadius: Sp.large.radiusR,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: 8.radiusR,
            child: Transform.rotate(
              angle: card.isReversed ? math.pi : 0,
              child: CustomCacheNetworkImage(
                imageUrl: card.card.imageUrl,
                width: 48.w,
                height: 78.w,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Sp.medium.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${LocaleKeys.tarot_reading_card_label.tr(args: ['${card.positionIndex}'])} - ${card.card.name}',
                  style: m12w600(context).copyWith(color: colors.textSecondary),
                ),
                Sp.xsmall.heightBox,
                Text(card.position.question, style: m12w400(context).copyWith(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
