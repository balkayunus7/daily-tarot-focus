import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_daily/helpers/daily_calendar_page_mixin.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_daily/helpers/daily_calendar_page_scope.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_daily/pages/tarot_daily_calendar_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/app_colors.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/daily_calendar_hero.dart';
part '../widgets/daily_calendar_preview.dart';
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
          onBackIconTap: context.canPop() ? null : () => context.go(AppRoutes.tarotExplore),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Sp.xsmall.heightBox,
              const _CalendarHero(),
              Sp.small.heightBox,
              const _WeekdayRow(),
              Sp.xsmall.heightBox,
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
              Sp.xsmall.heightBox,
              const _SelectedDayPreview(),
              Sp.xsmall.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();

  @override
  Widget build(BuildContext context) {
    final days = DailyCalendarPageScope.of(context).state.daysLabels;
    return Padding(
      padding: Sp.large.padHR,
      child: Row(
        children:
            days.map((day) {
              return Expanded(
                child: Text(
                  day,
                  style: m11w500(context).copyWith(color: context.colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
      ),
    );
  }
}
