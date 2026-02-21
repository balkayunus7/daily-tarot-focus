import 'package:daily_tarot_focus/application/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/application/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
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
      appBar: const TarotAppBar(title: 'Daily Tarots', showBackIcon: false),
      body: BlocBuilder<TarotBloc, TarotState>(
        builder: (context, state) {
          if (state.isFetchingDailyCards) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.hasFetchedDailyCardsFailed) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Kartlar yüklenemedi'),
                  Spacing.mediumH,
                ],
              ),
            );
          }

          if (state.hasFetchedDailyCardsSucceeded) {
            final cards = state.dailyCardsOrEmpty;
            if (cards.isEmpty()) {
              return const Center(child: Text('Henüz kart çekilmedi'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingConsts.medium,
                vertical: SpacingConsts.small,
              ),
              itemCount: cards.size,
              itemBuilder: (context, index) {
                final card = cards[index];
                return _DailyCardListItem(card: card);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _DailyCardListItem extends StatelessWidget {
  const _DailyCardListItem({required this.card});
  final TarotCard card;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: SpacingConsts.small),
      color: context.colors.surface.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: Spacing.smallBorderRadius,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SpacingConsts.medium,
          vertical: SpacingConsts.xsmall,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            card.imagePath,
            width: 48,
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(card.title, style: m16w600(context)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card.savedAt != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  card.savedAt!.yyyyMMdd,
                  style: m12w400(context).copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            Text(
              card.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: m12w400(context).copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
