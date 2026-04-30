import 'dart:math' as math;

import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_reading_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/widgets/spread_layout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

        return DefaultTabController(
          length: 3,
          child: _AnswerScaffold(
            response: response,
            spread: spread,
            cards: state.selectedReadingCards,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------

class _AnswerScaffold extends StatelessWidget {
  const _AnswerScaffold({
    required this.response,
    required this.spread,
    required this.cards,
  });

  final GenerateReadingResponse response;
  final TarotSpreadModel spread;
  final List<TarotSelectedReadingCard> cards;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: colors.textPrimary, size: 22.sp),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Yorumlamanız', style: m16w700(context)),
            Text(
              spread.title,
              style: m12w400(context).copyWith(color: colors.textSecondary),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Kaydet', style: m14w500(context)),
          ),
        ],
        bottom: TabBar(
          indicatorColor: colors.textPrimary,
          indicatorWeight: 2,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: colors.textPrimary,
          unselectedLabelColor: colors.textSecondary.withValues(alpha: 0.5),
          labelStyle: m11w500(context).copyWith(letterSpacing: 1.0),
          unselectedLabelStyle: m11w500(context).copyWith(letterSpacing: 1.0),
          tabs: const [
            Tab(text: 'AÇILIM'),
            Tab(text: 'KARTLAR'),
            Tab(text: 'NOTLAR'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          _AcilimTab(response: response, cards: cards, spread: spread),
          _KartlarTab(cards: cards, spread: spread),
          const _PlaceholderTab(icon: Icons.note_alt_outlined, label: 'Notlar yakında'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AÇILIM TAB
// ---------------------------------------------------------------------------

class _AcilimTab extends StatelessWidget {
  const _AcilimTab({
    required this.response,
    required this.cards,
    required this.spread,
  });

  final GenerateReadingResponse response;
  final List<TarotSelectedReadingCard> cards;
  final TarotSpreadModel spread;

  @override
  Widget build(BuildContext context) {
    final interpMap = {
      for (final i in response.cardInterpretations) i.positionIndex: i,
    };

    final sorted = [...cards]..sort((a, b) => a.positionIndex.compareTo(b.positionIndex));

    return ListView(
      padding: EdgeInsets.fromLTRB(
        Sp.screen.w,
        Sp.large.h,
        Sp.screen.w,
        Sp.xxxlarge.h,
      ),
      children: [
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
        _GeneralInterpretationSection(text: response.generalInterpretation),
      ],
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
        // Card image with position badge
        SizedBox(
          width: 80.w,
          height: 136.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: 8.radiusR,
                child: Transform.rotate(
                  angle: card.isReversed ? math.pi : 0,
                  child: CustomCacheNetworkImage(
                    imageUrl: card.card.imageUrl,
                    width: 80.w,
                    height: 128.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      color: colors.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.background, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${card.positionIndex}',
                      style: m10w700(context).copyWith(
                        color: colors.textOnPrimary,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Sp.medium.widthBox,
        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (card.position.title.isNotEmpty)
                Text(
                  card.position.title.toUpperCase(),
                  style: m10w500(context).copyWith(
                    color: colors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
              Sp.tiny.heightBox,
              Row(
                children: [
                  Expanded(
                    child: Text(card.card.name, style: m14w700(context)),
                  ),
                  Sp.xsmall.widthBox,
                  _ReversedBadge(isReversed: card.isReversed),
                ],
              ),
              Sp.xsmall.heightBox,
              Text(
                interpretation?.interpretation ??
                    (card.isReversed ? card.card.reversed.general : card.card.upright.general),
                style: m13w400(context).copyWith(
                  color: colors.textPrimary.withValues(alpha: 0.85),
                  height: 1.55,
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
    final colors = context.colors;
    final color = isReversed ? colors.primary : colors.secondary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: 4.radiusR,
      ),
      child: Text(
        isReversed ? 'Ters' : 'Düz',
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
              width: 3.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: 2.radiusR,
              ),
            ),
            Sp.xsmall.widthBox,
            Text('Genel Yorum', style: m16w700(context)),
          ],
        ),
        Sp.medium.heightBox,
        Text(
          text,
          style: m14w400(context).copyWith(
            color: colors.textPrimary.withValues(alpha: 0.85),
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// KARTLAR TAB
// ---------------------------------------------------------------------------

class _KartlarTab extends StatelessWidget {
  const _KartlarTab({required this.cards, required this.spread});

  final List<TarotSelectedReadingCard> cards;
  final TarotSpreadModel spread;

  @override
  Widget build(BuildContext context) {
    final sorted = [...cards]..sort((a, b) => a.positionIndex.compareTo(b.positionIndex));

    return ListView(
      padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.large.h, Sp.screen.w, Sp.xxxlarge.h),
      children: [
        // Spread info card with layout preview
        _SpreadInfoCard(spread: spread),
        Sp.medium.heightBox,
        // One card row per selected card
        for (final card in sorted) ...[
          _KartlarCardRow(card: card),
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
          // Layout preview
          SpreadLayoutPreview(
            positions: spread.positions.asList(),
            showIndex: true,
            cardWidth: 22,
            cardHeight: 34,
            spacing: 6,
          ),
          Sp.medium.heightBox,
          Text(
            'AÇILIM',
            style: m10w500(context).copyWith(
              color: colors.textSecondary,
              letterSpacing: 2.0,
            ),
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
              style: m13w400(context).copyWith(
                color: colors.textSecondary,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _KartlarCardRow extends StatelessWidget {
  const _KartlarCardRow({required this.card});
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Card image
          ClipRRect(
            borderRadius: 8.radiusR,
            child: Transform.rotate(
              angle: card.isReversed ? math.pi : 0,
              child: CustomCacheNetworkImage(
                imageUrl: card.card.imageUrl,
                width: 72.w,
                height: 108.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Sp.medium.widthBox,
          // Position info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kart ${card.positionIndex} - ${card.card.name}',
                  style: m12w400(context).copyWith(color: colors.textSecondary),
                ),
                Sp.xsmall.heightBox,
                Text(
                  card.position.question,
                  style: m15w600(context).copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// NOTLAR placeholder tab
// ---------------------------------------------------------------------------

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40.sp, color: colors.textSecondary.withValues(alpha: 0.4)),
          Sp.small.heightBox,
          Text(
            label,
            style: m14w400(context).copyWith(
              color: colors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
