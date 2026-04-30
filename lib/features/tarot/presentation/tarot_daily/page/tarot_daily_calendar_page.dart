import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotDailyCalendarPage extends StatefulWidget {
  const TarotDailyCalendarPage({super.key});

  @override
  State<TarotDailyCalendarPage> createState() => _TarotDailyCalendarPageState();
}

class _TarotDailyCalendarPageState extends State<TarotDailyCalendarPage> {
  static const _initialPage = 1200;
  late final PageController _pageController;
  int _currentPage = _initialPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _monthForPage(int page) {
    final now = DateTime.now();
    return DateTime(now.year, now.month + (page - _initialPage));
  }

  Map<DateTime, TarotCardModel> _buildCardMap(List<TarotCardModel> cards) {
    final map = <DateTime, TarotCardModel>{};
    for (final card in cards) {
      if (card.savedAt != null) {
        final key = DateTime(card.savedAt!.year, card.savedAt!.month, card.savedAt!.day);
        map[key] = card;
      }
    }
    return map;
  }

  void _goToPrev() => _pageController.previousPage(
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeInOut,
  );

  void _goToNext() => _pageController.nextPage(
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const TarotAppBar(title: 'Daily History'),
      body: SafeArea(
        child: Column(
          children: [
            Sp.small.heightBox,
            _MonthSelector(
              currentPage: _currentPage,
              monthForPage: _monthForPage,
              onPrev: _goToPrev,
              onNext: _goToNext,
            ),
            Sp.small.heightBox,
            _TapHint(),
            Sp.xlarge.heightBox,
            _WeekdayRow(),
            Sp.medium.heightBox,
            Expanded(
              child: BlocBuilder<TarotBloc, TarotState>(
                builder: (context, state) {
                  final cardMap = _buildCardMap(state.dailyCardsOrEmpty.asList());
                  return PageView.builder(
                    controller: _pageController,
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    itemBuilder: (context, page) {
                      return _CalendarGrid(
                        month: _monthForPage(page),
                        cardMap: cardMap,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TapHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: Sp.large.padHR,
      child: Row(
        children: [
          Icon(Icons.touch_app_outlined, size: 13, color: colors.textSecondary),
          const SizedBox(width: 4),
          Text(
            'Kartlara tıklayarak detaylarını görebilirsin',
            style: m11w500(context).copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.currentPage,
    required this.monthForPage,
    required this.onPrev,
    required this.onNext,
  });
  final int currentPage;
  final DateTime Function(int) monthForPage;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  String _label(DateTime month) => DateFormat('MMMM yyyy').format(month);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final prev = monthForPage(currentPage - 1);
    final current = monthForPage(currentPage);
    final next = monthForPage(currentPage + 1);

    return FancyContainer(
      margin: Sp.medium.padHR,
      padding: Sp.large.padSymR(v: Sp.small, h: Sp.medium),
      color: context.colors.primary,
      child: Row(
        children: [
          GestureDetector(
            onTap: onPrev,
            child: Padding(
              padding: Sp.tiny.padAllR,
              child: Icon(Icons.chevron_left, color: colors.textOnSecondary, size: 22),
            ),
          ),
          Expanded(
            child: Opacity(
              opacity: 0.5,
              child: Text(
                _label(prev),
                style: m11w500(context).copyWith(color: colors.textOnSecondary),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _label(current),
              style: m15w700(context).copyWith(color: colors.textOnPrimary),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Opacity(
              opacity: 0.5,
              child: Text(
                _label(next),
                style: m11w500(context).copyWith(color: colors.textOnSecondary),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GestureDetector(
            onTap: onNext,
            child: Padding(
              padding: Sp.tiny.padAllR,
              child: Icon(Icons.chevron_right, color: colors.textOnSecondary, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Sp.large.padHR,
      child: Row(
        children:
            _days
                .map(
                  (day) => Expanded(
                    child: Text(
                      day,
                      style: m11w500(context).copyWith(color: context.colors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({required this.month, required this.cardMap});
  final DateTime month;
  final Map<DateTime, TarotCardModel> cardMap;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month);
    final startOffset = firstDay.weekday - 1;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final totalCells = startOffset + daysInMonth;

    return GridView.builder(
      padding: Sp.xlarge.padHR,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        childAspectRatio: 0.52,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final day = index - startOffset + 1;

        if (day < 1 || day > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(month.year, month.month, day);
        final card = cardMap[date];
        final isToday = _isToday(date);

        return _DayCell(date: date, card: card, isToday: isToday);
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.date, required this.card, required this.isToday});
  final DateTime date;
  final TarotCardModel? card;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasCard = card != null;
    final now = DateTime.now();
    final isPast = date.isBefore(DateTime(now.year, now.month, now.day)) && !isToday;
    const radius = BorderRadius.all(Radius.circular(8));

    return GestureDetector(
      onTap: hasCard ? () => context.push(AppRoutes.tarotDailyDetail, extra: card) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: radius,
                color:
                    hasCard
                        ? null
                        : isToday
                        ? colors.primary.withValues(alpha: 0.10)
                        : isPast
                        ? colors.primary.withValues(alpha: 0.04)
                        : Colors.transparent,
                border: Border.all(
                  color:
                      isToday
                          ? colors.primary
                          : hasCard
                          ? colors.primary.withValues(alpha: 0.55)
                          : isPast
                          ? colors.primary.withValues(alpha: 0.18)
                          : colors.borderSecondary.withValues(alpha: 0.22),
                  width:
                      isToday
                          ? 1.8
                          : hasCard
                          ? 1.2
                          : 0.7,
                ),
              ),
              child: ClipRRect(
                borderRadius: radius,
                child:
                    hasCard
                        ? CustomCacheNetworkImage(imageUrl: card!.imageUrl, fit: BoxFit.fitWidth)
                        : (isPast || isToday)
                        ? Center(
                          child: Text(
                            '✦',
                            style: m11w500(context).copyWith(
                              color: colors.primary.withValues(alpha: isToday ? 0.38 : 0.16),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ),
          Sp.tiny.heightBox,
          Text(
            '${date.day}',
            textAlign: TextAlign.center,
            style: m10w600(context).copyWith(
              color: isToday ? colors.primary : colors.textSecondary,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}
