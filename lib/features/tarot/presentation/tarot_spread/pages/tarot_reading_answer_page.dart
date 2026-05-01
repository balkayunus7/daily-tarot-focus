import 'dart:math' as math;

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reading_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/widgets/spread_layout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotReadingAnswerPage extends StatelessWidget {
  const TarotReadingAnswerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TarotBloc, TarotState>(
      builder: (context, state) {
        final response = state.generateReadingResponseOrNull;
        final spread = state.selectedSpread;
        if (response == null || spread == null) return const SizedBox.shrink();

        return PopScope(
          canPop: false,
          child: DefaultTabController(
            length: 3,
            child: _AnswerScaffold(
              response: response,
              spread: spread,
              cards: state.selectedReadingCards,
              question: state.selectedQuestion,
            ),
          ),
        );
      },
    );
  }
}

class _AnswerScaffold extends StatelessWidget {
  const _AnswerScaffold({
    required this.response,
    required this.spread,
    required this.cards,
    required this.question,
  });
  final GenerateReadingResponse response;
  final TarotSpreadModel spread;
  final List<TarotSelectedReadingCard> cards;
  final String? question;

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
              onBackIconTap: () => context.go(AppRoutes.tarotExplore),
              titleWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Text(LocaleKeys.tarot_reading_title.tr(), style: m16w700(context))],
              ),
              subsWidget: TextButton(
                onPressed: () {},
                child: Text(LocaleKeys.tarot_reading_save.tr(), style: m14w500(context)),
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
          _SpreadTab(response: response, cards: cards, spread: spread, question: question),
          _CardsTab(cards: cards, spread: spread),
          const _NotesTab(),
        ],
      ),
    );
  }
}

class _SpreadTab extends StatelessWidget {
  const _SpreadTab({
    required this.response,
    required this.cards,
    required this.spread,
    required this.question,
  });
  final GenerateReadingResponse response;
  final List<TarotSelectedReadingCard> cards;
  final TarotSpreadModel spread;
  final String? question;

  @override
  Widget build(BuildContext context) {
    final interpMap = {for (final i in response.cardInterpretations) i.positionIndex: i};
    final sorted = [...cards]..sort((a, b) => a.positionIndex.compareTo(b.positionIndex));

    return ListView(
      padding: EdgeInsets.fromLTRB(
        Sp.screen.w,
        Sp.large.h,
        Sp.screen.w,
        Sp.xxxlarge.h,
      ),
      children: [
        if (question != null && question!.isNotEmpty) ...[
          _QuestionSection(question: question!),
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
          else ...[
            SizedBox(height: Sp.xxlarge.h),
          ],
        ],
        _GeneralInterpretationSection(text: response.generalInterpretation),
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
  const _CardInterpretationItem({
    required this.card,
    required this.interpretation,
  });
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
                style: m12w400(context).copyWith(
                  color: colors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
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
          style: m13w400(context).copyWith(
            color: colors.textPrimary.withValues(alpha: 0.85),
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _CardsTab extends StatelessWidget {
  const _CardsTab({required this.cards, required this.spread});
  final List<TarotSelectedReadingCard> cards;
  final TarotSpreadModel spread;

  @override
  Widget build(BuildContext context) {
    final sorted = [...cards]..sort((a, b) => a.positionIndex.compareTo(b.positionIndex));

    return ListView(
      padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.large.h, Sp.screen.w, Sp.xxxlarge.h),
      children: [
        _SpreadInfoCard(spread: spread),
        Sp.medium.heightBox,
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
          Text(
            spread.title,
            style: m18w700(context),
            textAlign: TextAlign.center,
          ),
          if (spread.description.isNotEmpty) ...[
            Sp.small.heightBox,
            Text(
              '• • •',
              style: m12w400(context).copyWith(color: colors.textSecondary),
            ),
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
                Text(
                  card.position.question,
                  style: m12w400(context).copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesTab extends StatefulWidget {
  const _NotesTab();
  @override
  State<_NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<_NotesTab> with AutomaticKeepAliveClientMixin {
  final _controller = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.large.h, Sp.screen.w, Sp.xxxlarge.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(Sp.large.w),
            decoration: BoxDecoration(
              color: colors.textSecondary.withValues(alpha: 0.06),
              borderRadius: Sp.large.radiusR,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.tarot_reading_notes_title.tr(),
                  style: m14w700(context),
                ),
                TextField(
                  controller: _controller,
                  minLines: 10,
                  maxLines: 10,
                  maxLength: 360,
                  textAlignVertical: TextAlignVertical.top,
                  style: m14w400(context).copyWith(
                    color: colors.textPrimary.withValues(alpha: 0.85),
                    height: 1.7,
                  ),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.tarot_reading_notes_placeholder.tr(),
                    hintStyle: m13w400(context).copyWith(
                      color: colors.textSecondary.withValues(alpha: 0.4),
                    ),
                    counterStyle: m11w400(context).copyWith(
                      color: colors.textSecondary.withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
