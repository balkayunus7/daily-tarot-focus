import 'dart:math' as math;

import 'package:daily_tarot_focus/core/util/build_context_toast_ext.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_saved_readings_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reading_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/helpers/detail_page_mixin.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/helpers/detail_page_scope.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/widgets/spread_layout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/detail_notes_tab.dart';
part '../widgets/detail_spread_tabs.dart';
part '../widgets/detail_cards_tab.dart';

class TarotReadingDetailPage extends StatefulWidget {
  const TarotReadingDetailPage({required this.reading, super.key});
  final SavedReadingModel reading;

  @override
  State<TarotReadingDetailPage> createState() => _TarotReadingDetailPageState();
}

class _TarotReadingDetailPageState extends State<TarotReadingDetailPage> with DetailPageMixin {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDirty,
      builder: (context, dirty, child) {
        return PopScope(
          canPop: !dirty,
          onPopInvokedWithResult: (didPop, _) async {
            if (!didPop) await handleBackPress();
          },
          child: child!,
        );
      },
      child: DetailPageScope(
        state: this,
        child: MultiBlocListener(
          listeners: [
            BlocListener<TarotBloc, TarotState>(
              listenWhen: (prev, curr) {
                return (!prev.hasUpdateNoteSucceeded && curr.hasUpdateNoteSucceeded) ||
                    (!prev.hasUpdateNoteFailed && curr.hasUpdateNoteFailed);
              },
              listener: (context, state) {
                if (state.hasUpdateNoteSucceeded) {
                  context.showToastMessage(LocaleKeys.tarot_reading_update_success.tr());
                  onUpdateNoteSucceeded();
                } else if (state.hasUpdateNoteFailed) {
                  context.showErrorToastMessage(LocaleKeys.tarot_reading_update_error.tr());
                }
              },
            ),
            BlocListener<TarotBloc, TarotState>(
              listenWhen: (prev, curr) {
                return (!prev.hasDeleteReadingSucceeded && curr.hasDeleteReadingSucceeded) ||
                    (!prev.hasDeleteReadingFailed && curr.hasDeleteReadingFailed);
              },
              listener: (context, state) {
                if (state.hasDeleteReadingSucceeded) {
                  context
                    ..showToastMessage(LocaleKeys.tarot_reading_delete_success.tr())
                    ..pop();
                } else if (state.hasDeleteReadingFailed) {
                  context.showErrorToastMessage(LocaleKeys.tarot_reading_delete_error.tr());
                }
              },
            ),
          ],
          child: BlocBuilder<TarotBloc, TarotState>(
            buildWhen: (prev, curr) {
              return prev.spreadsOrEmpty != curr.spreadsOrEmpty ||
                  prev.fetchAllCardsFailureOrCards != curr.fetchAllCardsFailureOrCards;
            },
            builder: (context, state) {
              final spread = state.getSpreadById(widget.reading.spreadId);
              if (spread == null) {
                context
                  ..showErrorToastMessage("Error: Couldn't load spread, please try again.")
                  ..pop();
              }

              final cards =
                  widget.reading.cardInterpretations
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
                child: _DetailScaffold(reading: widget.reading, spread: spread!, cards: cards),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({required this.reading, required this.spread, required this.cards});
  final SavedReadingModel reading;
  final TarotSpreadModel spread;
  final List<TarotSelectedReadingCard> cards;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _DetailAppBar(),
            Expanded(
              child: TabBarView(
                children: [
                  SpreadTab(reading: reading, cards: cards),
                  CardsTab(cards: cards, spread: spread),
                  const NotesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailAppBar extends StatelessWidget {
  const _DetailAppBar();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = DetailPageScope.of(context).state;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TarotAppBar(
          title: LocaleKeys.tarot_reading_title.tr(),
          onBackIconTap: scope.handleBackPress,
          subsWidget: BlocBuilder<TarotBloc, TarotState>(
            buildWhen: (prev, curr) => prev.isDeletingReading != curr.isDeletingReading,
            builder: (context, state) {
              if (state.isDeletingReading) {
                return SizedBox(
                  width: 32.w,
                  height: 32.h,
                  child: Center(
                    child: SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary),
                    ),
                  ),
                );
              }
              return ScalingContainer(
                onTap: scope.onDeleteReading,
                child: Center(
                  child: FancyContainer(
                    width: 32.w,
                    height: 32.h,
                    borderRadius: 100,
                    color: context.colors.primary,
                    child: Icon(Icons.delete_outline, size: Sp.medium, color: colors.textOnPrimary),
                  ),
                ),
              );
            },
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
    );
  }
}
