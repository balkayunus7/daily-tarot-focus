import 'package:daily_tarot_focus/application/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/application/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';

import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:daily_tarot_focus/presentation/tarot_daily/helpers/daily_page_date_range_sheet.dart';
import 'package:daily_tarot_focus/presentation/tarot_daily/helpers/daily_page_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/daily_list_item.dart';
part '../widgets/daily_date_range_badge.dart';
part '../widgets/daily_header.dart';
part '../widgets/daily_retry_widget.dart';

class TarotDailyPage extends StatefulWidget {
  const TarotDailyPage({super.key});

  @override
  State<TarotDailyPage> createState() => _TarotDailyPageState();
}

class _TarotDailyPageState extends State<TarotDailyPage>
    with DailyPageMixin, DailyPageDateRangeSheet {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            DailyHeader(showFilterSheet: showFilterBottomSheet),
            ValueListenableBuilder(
              valueListenable: selectedFilter,
              builder: (context, filter, _) {
                return ValueListenableBuilder(
                  valueListenable: customDateRange,
                  builder: (context, range, _) {
                    if (filter == TarotDailyDateFilter.allTime) return const SizedBox.shrink();
                    return DateRangeBadge(filterLabel: filterLabel, clearFilter: clearFilter);
                  },
                );
              },
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: selectedFilter,
                builder: (context, filter, _) {
                  return ValueListenableBuilder(
                    valueListenable: customDateRange,
                    builder: (context, range, _) {
                      return BlocBuilder<TarotBloc, TarotState>(
                        builder: (context, state) {
                          if (state.isFetchingDailyCards) {
                            return Center(
                              child: SpinKitFadingCircle(color: context.colors.primary, size: 32),
                            );
                          }
                          if (state.hasFetchedDailyCardsFailed) {
                            return DailyEmptyWidget(
                              message: LocaleKeys.tarot_daily_error_desc.tr(),
                              onTap: () {
                                final session = context.read<AuthCubit>().state.sessionOrCrash;
                                final languageCode = context.locale.languageCode;
                                context.read<TarotBloc>().addDailyCardsFetched(
                                  session: session,
                                  languageCode: languageCode,
                                );
                              },
                            );
                          }
                          if (state.hasFetchedDailyCardsSucceeded) {
                            final allCards = state.dailyCardsOrEmpty.asList();
                            final cards = filteredCards(
                              filter: filter,
                              allCards: allCards,
                              range: range,
                            );

                            if (cards.isEmpty) {
                              return DailyEmptyWidget(
                                message: LocaleKeys.tarot_daily_empty_desc.tr(),
                                onTap: () => context.push(AppRoutes.tarotReveal),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              itemCount: cards.length,
                              itemBuilder: (context, index) {
                                final card = cards[index];
                                return _DailyCardListItem(
                                  card: card,
                                  isFirst: index == 0,
                                  isLast: index == cards.length - 1,
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
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
