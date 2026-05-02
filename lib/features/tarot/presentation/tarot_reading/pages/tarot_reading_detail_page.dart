import 'dart:math' as math;

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_saved_readings_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reading_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/widgets/spread_layout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/detail_notes_tab.dart';
part '../widgets/detail_spread_tabs.dart';
part '../widgets/detail_cards_tab.dart';

class TarotReadingDetailPage extends StatelessWidget {
  const TarotReadingDetailPage({required this.reading, super.key});
  final SavedReadingModel reading;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TarotBloc, TarotState>(
      builder: (context, state) {
        final spread =
            state.spreadsOrEmpty
                .asList()
                .expand((cat) => cat.spreads.asList())
                .where((s) => s.id == reading.spreadId)
                .firstOrNull;

        final cards =
            reading.cardInterpretations
                .map((interp) {
                  final card = state.getById(interp.cardId);
                  if (card == null) return null;
                  final position =
                      spread?.positions
                          .asList()
                          .where((p) => p.index == interp.positionIndex)
                          .firstOrNull;
                  return TarotSelectedReadingCard(
                    positionIndex: interp.positionIndex,
                    card: card,
                    position:
                        position ??
                        TarotSpreadPositionModel(
                          col: 0,
                          row: 0,
                          index: interp.positionIndex,
                          title: '',
                          question: '',
                        ),
                    isReversed: interp.isReversed,
                  );
                })
                .whereType<TarotSelectedReadingCard>()
                .toList();

        return DefaultTabController(
          length: 3,
          child: _DetailScaffold(reading: reading, spread: spread, cards: cards),
        );
      },
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({
    required this.reading,
    required this.spread,
    required this.cards,
  });
  final SavedReadingModel reading;
  final TarotSpreadModel? spread;
  final List<TarotSelectedReadingCard> cards;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + Sp.xxxlarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TarotAppBar(
              backIcon: Icons.close,
              onBackIconTap: () => Navigator.of(context).pop(),
              titleWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Text(LocaleKeys.tarot_reading_title.tr(), style: m16w700(context))],
              ),
            ),
            TabBar(
              indicatorColor: colors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: colors.textPrimary,
              unselectedLabelColor: colors.textSecondary.withValues(alpha: 0.5),
              labelStyle: m11w500(context).copyWith(letterSpacing: 1),
              unselectedLabelStyle: m11w500(context).copyWith(letterSpacing: 1),
              tabs: [
                Tab(text: LocaleKeys.tarot_reading_tab_spread.tr()),
                Tab(text: LocaleKeys.tarot_reading_tab_cards.tr()),
                Tab(text: LocaleKeys.tarot_reading_tab_notes.tr()),
              ],
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          SpreadTab(reading: reading, cards: cards),
          CardsTab(cards: cards, spread: spread),
          NotesTab(note: reading.note),
        ],
      ),
    );
  }
}
