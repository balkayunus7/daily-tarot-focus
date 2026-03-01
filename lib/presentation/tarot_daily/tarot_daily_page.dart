import 'package:daily_tarot_focus/application/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/application/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';

class TarotDailyPage extends StatefulWidget {
  const TarotDailyPage({super.key});

  @override
  State<TarotDailyPage> createState() => _TarotDailyPageState();
}

class _TarotDailyPageState extends State<TarotDailyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: Spacing.largePadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daily Tarots', style: m18w700(context)),
                      Spacing.xsmallH,
                      Text(
                        'YOUR SPIRITUAL JOURNEY',
                        style: m10w600(context).copyWith(
                          color: context.colors.primary,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.filter_list, color: context.colors.primary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<TarotBloc, TarotState>(
                builder: (context, state) {
                  if (state.isFetchingDailyCards) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.hasFetchedDailyCardsFailed) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Kartlar yüklenemedi', style: m14w600(context)),
                          Spacing.mediumH,
                        ],
                      ),
                    );
                  }

                  if (state.hasFetchedDailyCardsSucceeded) {
                    final cards = state.dailyCardsOrEmpty;
                    if (cards.isEmpty()) {
                      return Center(child: Text('Henüz kart çekilmedi', style: m14w600(context)));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: cards.size,
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return _DailyCardListItem(
                          card: card,
                          isFirst: index == 0,
                          isLast: index == cards.size - 1,
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyCardListItem extends StatelessWidget {
  const _DailyCardListItem({required this.card, required this.isFirst, required this.isLast});
  final TarotCard card;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = context.colors.primary;

    return IntrinsicHeight(
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
                        child: Image.asset(card.imagePath, width: 56, fit: BoxFit.fitHeight),
                      ),
                    ),
                    Spacing.mediumW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(card.title, style: m14w700(context)),
                          Spacing.smallH,
                          if (card.uprightMeanings.isNotEmpty) ...[
                            Container(
                              padding: Spacing.smallPadding,
                              decoration: BoxDecoration(
                                border: Border.all(color: dotColor.withValues(alpha: 0.5)),
                                borderRadius: Spacing.xsmallBorderRadius,
                              ),
                              child: Text(
                                card.uprightMeanings.first,
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
    );
  }
}
