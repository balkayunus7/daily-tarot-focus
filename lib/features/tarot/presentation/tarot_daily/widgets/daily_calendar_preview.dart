part of '../pages/tarot_daily_calendar_page.dart';

const double _previewLeadingWidth = 44;
const double _previewLeadingHeight = 64;

class _SelectedDayPreview extends StatelessWidget {
  const _SelectedDayPreview();

  @override
  Widget build(BuildContext context) {
    final scope = DailyCalendarPageScope.of(context).state;
    final colors = context.colors;

    return ValueListenableBuilder<DateTime>(
      valueListenable: scope.selectedDate,
      builder: (context, selected, _) {
        return BlocBuilder<TarotBloc, TarotState>(
          builder: (context, state) {
            final cardMap = scope.buildCardMap(
              state.dailyCardsOrEmpty.asList(),
            );
            final key = DateTime(selected.year, selected.month, selected.day);
            final card = cardMap[key];
            final tarotCard = card != null ? state.getById(card.cardId) : null;

            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final isToday = key.isAtSameMomentAs(today);
            final isFuture = key.isAfter(today);

            return Container(
              margin: Sp.medium.padHR,
              padding: Sp.medium.padSymR(v: Sp.small, h: Sp.medium),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: Sp.medium.radiusR,
                border: Border.all(
                  color: colors.borderSecondary.withValues(alpha: 0.35),
                  width: 0.8,
                ),
              ),
              child: _PreviewBody(
                date: key,
                isToday: isToday,
                isFuture: isFuture,
                card: card,
                tarotCard: tarotCard,
              ),
            );
          },
        );
      },
    );
  }
}

class _PreviewBody extends StatelessWidget {
  const _PreviewBody({
    required this.date,
    required this.isToday,
    required this.isFuture,
    required this.card,
    required this.tarotCard,
  });

  final DateTime date;
  final bool isToday;
  final bool isFuture;
  final DailyCardModel? card;
  final TarotCardModel? tarotCard;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = DailyCalendarPageScope.of(context).state;
    final dateLabel =
        isToday
            ? LocaleKeys.tarot_daily_calendar_selected_day_today.tr()
            : scope.dayLongLabel(date);

    if (card != null && tarotCard != null) {
      return _PreviewWithCard(
        dateLabel: dateLabel,
        card: card!,
        tarotCard: tarotCard!,
      );
    }

    final String message;
    final bool showDrawCard;
    if (isToday) {
      message = LocaleKeys.tarot_daily_calendar_no_card_today.tr();
      showDrawCard = true;
    } else if (isFuture) {
      message = LocaleKeys.tarot_daily_calendar_future_day.tr();
      showDrawCard = false;
    } else {
      message = LocaleKeys.tarot_daily_calendar_no_card_past.tr();
      showDrawCard = false;
    }

    return Row(
      children: [
        Container(
          width: _previewLeadingWidth,
          height: _previewLeadingHeight,
          decoration: BoxDecoration(
            borderRadius: Sp.xsmall.radiusR,
            color: colors.surfaceSecondary,
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.18),
              width: 0.8,
            ),
          ),
          child: Center(
            child: Icon(
              isFuture ? Icons.hourglass_empty_rounded : Icons.auto_awesome_outlined,
              size: 22,
              color: colors.primary.withValues(alpha: 0.45),
            ),
          ),
        ),
        Sp.medium.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateLabel,
                style: m13w600(context).copyWith(color: colors.textPrimary),
              ),
              Sp.tiny.heightBox,
              Text(
                message,
                style: m12w500(context).copyWith(color: colors.textSecondary),
              ),
              if (showDrawCard) ...[
                Sp.small.heightBox,
                const _DrawCardButton(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewWithCard extends StatelessWidget {
  const _PreviewWithCard({
    required this.dateLabel,
    required this.card,
    required this.tarotCard,
  });

  final String dateLabel;
  final DailyCardModel card;
  final TarotCardModel tarotCard;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap:
          () => unawaited(
            context.push(
              AppRoutes.tarotDailyDetail,
              extra: TarotDailyCalendarDetailArgs(
                tarot: tarotCard,
                dailyCard: card,
              ),
            ),
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: Sp.xsmall.radiusR,
            child: SizedBox(
              width: _previewLeadingWidth,
              height: _previewLeadingHeight,
              child: CustomCacheNetworkImage(
                imageUrl: tarotCard.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Sp.medium.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateLabel,
                  style: m11w500(context).copyWith(color: colors.textSecondary),
                ),
                Sp.tiny.heightBox,
                Text(
                  tarotCard.name,
                  style: m14w700(context).copyWith(color: colors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (tarotCard.uprightKeywords.isNotEmpty) ...[
                  Sp.tiny.heightBox,
                  Text(
                    tarotCard.uprightKeywords.take(3).join(' • '),
                    style: m11w500(context).copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                Sp.xsmall.heightBox,
              ],
            ),
          ),
          Row(
            children: [
              Text(
                LocaleKeys.tarot_daily_calendar_view_detail.tr(),
                style: m11w500(context).copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: colors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawCardButton extends StatelessWidget {
  const _DrawCardButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => unawaited(context.push(AppRoutes.tarotReveal)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Sp.medium.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.gradientStart, colors.gradientEnd],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.30),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 14,
              color: colors.textOnPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              LocaleKeys.tarot_daily_calendar_draw_card.tr(),
              style: m12w500(context).copyWith(
                color: colors.textOnPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
