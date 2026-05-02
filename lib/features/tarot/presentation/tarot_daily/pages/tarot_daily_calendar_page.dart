import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_daily/helpers/daily_calendar_page_mixin.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_daily/helpers/daily_calendar_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/daily_day_cell.dart';
part '../widgets/daily_day_grid.dart';

class TarotDailyCalendarPage extends StatefulWidget {
  const TarotDailyCalendarPage({super.key});

  @override
  State<TarotDailyCalendarPage> createState() => _TarotDailyCalendarPageState();
}

class _TarotDailyCalendarPageState extends State<TarotDailyCalendarPage>
    with DailyCalendarPageMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DailyCalendarPageScope(
      state: this,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: TarotAppBar(
          title: LocaleKeys.tarot_daily_calendar_title.tr(),
          backIcon: context.canPop() ? null : Icons.close,
          onBackIconTap: context.canPop()
              ? null
              : () => context.go(AppRoutes.tarotExplore),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Sp.small.heightBox,
              const _MonthSelector(),
              Sp.small.heightBox,
              const _TapHint(),
              Sp.xlarge.heightBox,
              const _WeekdayRow(),
              Sp.medium.heightBox,
              Expanded(
                child: BlocBuilder<TarotBloc, TarotState>(
                  builder: (context, state) {
                    final scope = DailyCalendarPageScope.of(context).state;
                    final cardMap = scope.buildCardMap(state.dailyCardsOrEmpty.asList());
                    return PageView.builder(
                      controller: scope.pageController,
                      onPageChanged: (page) {
                        scope.currentPage.value = page;
                      },
                      itemBuilder: (context, page) {
                        return DayGrid(month: scope.monthForPage(page), cardMap: cardMap);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TapHint extends StatelessWidget {
  const _TapHint();

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
            LocaleKeys.tarot_daily_calendar_tap_hint.tr(),
            style: m11w500(context).copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector();
  String _label(DateTime month) => DateFormat('MMMM yyyy').format(month);

  @override
  Widget build(BuildContext context) {
    final scope = DailyCalendarPageScope.of(context).state;
    final colors = context.colors;

    return ValueListenableBuilder<int>(
      valueListenable: scope.currentPage,
      builder: (context, page, _) {
        final prev = scope.monthForPage(page - 1);
        final current = scope.monthForPage(page);
        final next = scope.monthForPage(page + 1);

        return FancyContainer(
          margin: Sp.medium.padHR,
          padding: Sp.large.padSymR(v: Sp.small, h: Sp.medium),
          color: context.colors.primary,
          child: Row(
            children: [
              GestureDetector(
                onTap: scope.goToPrev,
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
                onTap: scope.goToNext,
                child: Padding(
                  padding: Sp.tiny.padAllR,
                  child: Icon(Icons.chevron_right, color: colors.textOnSecondary, size: 22),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();
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
