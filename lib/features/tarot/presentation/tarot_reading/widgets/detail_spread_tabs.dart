part of '../pages/tarot_reading_detail_page.dart';

class SpreadTab extends StatelessWidget {
  const SpreadTab({required this.reading, required this.cards, super.key});
  final SavedReadingModel reading;
  final List<TarotSelectedReadingCard> cards;

  @override
  Widget build(BuildContext context) {
    final interpMap = {for (final i in reading.cardInterpretations) i.positionIndex: i};
    final sorted = [...cards]..sort((a, b) => a.positionIndex.compareTo(b.positionIndex));

    return ListView(
      padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.large.h, Sp.screen.w, Sp.xxxlarge.h),
      children: [
        if (reading.question != null && reading.question!.isNotEmpty) ...[
          _QuestionSection(question: reading.question!),
          SizedBox(height: Sp.large.h),
          Divider(height: 1, color: context.colors.textSecondary.withValues(alpha: 0.12)),
          SizedBox(height: Sp.large.h),
        ],
        for (int i = 0; i < sorted.length; i++) ...[
          _CardInterpretationItem(
            card: sorted[i],
            interpretation: interpMap[sorted[i].positionIndex],
          ),
          if (i < sorted.length - 1)
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sp.large.h),
              child: Divider(
                height: 1,
                color: context.colors.textSecondary.withValues(alpha: 0.12),
              ),
            )
          else
            SizedBox(height: Sp.xxlarge.h),
        ],
        _GeneralInterpretationSection(text: reading.generalInterpretation),
        Sp.huge.heightBox,
      ],
    );
  }
}

class _QuestionSection extends StatelessWidget {
  const _QuestionSection({required this.question});
  final String question;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: Sp.medium.radiusR,
        border: Border.all(color: colors.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.tarot_reading_your_question.tr().toUpperCase(),
            style: m10w600(context).copyWith(color: colors.primary, letterSpacing: 1.2),
          ),
          SizedBox(height: Sp.xsmall.h),
          Text(question, style: m13w400(context).copyWith(height: 1.4)),
        ],
      ),
    );
  }
}

class _CardInterpretationItem extends StatelessWidget {
  const _CardInterpretationItem({required this.card, required this.interpretation});
  final TarotSelectedReadingCard card;
  final CardInterpretationModel? interpretation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.w,
          height: 140.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: Sp.xsmall.radiusR,
                child: Transform.rotate(
                  angle: card.isReversed ? math.pi : 0,
                  child: CustomCacheNetworkImage(
                    imageUrl: card.card.imageUrl,
                    width: 80.w,
                    height: 140.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: -12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: Sp.xlarge,
                    height: Sp.xlarge,
                    decoration: BoxDecoration(
                      color: colors.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.background, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${card.positionIndex}',
                      style: m10w700(context).copyWith(color: colors.textOnPrimary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Sp.medium.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (card.position.title.isNotEmpty)
                Text(
                  card.position.title.toUpperCase(),
                  style: m10w500(context).copyWith(color: colors.textSecondary, letterSpacing: 1.2),
                ),
              Sp.tiny.heightBox,
              Row(
                children: [
                  Expanded(child: Text(card.card.name, style: m14w700(context))),
                  Sp.xsmall.widthBox,
                  _ReversedBadge(isReversed: card.isReversed),
                ],
              ),
              Sp.xsmall.heightBox,
              Text(
                interpretation?.interpretation ??
                    (card.isReversed ? card.card.reversed.general : card.card.upright.general),
                style: m12w400(context).copyWith(color: colors.textSecondary, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GeneralInterpretationSection extends StatelessWidget {
  const _GeneralInterpretationSection({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: Sp.tiny,
              height: Sp.large,
              decoration: BoxDecoration(color: colors.primary, borderRadius: Sp.tiny.radiusR),
            ),
            Sp.xsmall.widthBox,
            Text(LocaleKeys.tarot_reading_general_reading.tr(), style: m16w700(context)),
          ],
        ),
        Sp.small.heightBox,
        Text(
          text,
          style: m13w400(
            context,
          ).copyWith(color: colors.textPrimary.withValues(alpha: 0.85), height: 1.7),
        ),
      ],
    );
  }
}

class _ReversedBadge extends StatelessWidget {
  const _ReversedBadge({required this.isReversed});
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.primary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: 4.radiusR,
      ),
      child: Text(
        isReversed ? LocaleKeys.tarot_reading_reversed.tr() : LocaleKeys.tarot_reading_upright.tr(),
        style: m10w500(context).copyWith(color: color),
      ),
    );
  }
}
