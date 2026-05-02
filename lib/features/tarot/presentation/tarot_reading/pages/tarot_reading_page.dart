import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_saved_readings_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_saved_readings_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/helpers/reading_page_date_range_sheet.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/helpers/reading_page_mixin.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/helpers/reading_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/reading_list_item.dart';
part '../widgets/reading_header.dart';
part '../widgets/reading_date_range_badge.dart';

class TarotReadingPage extends StatefulWidget {
  const TarotReadingPage({super.key, this.onNavbarTap});
  final VoidCallback? onNavbarTap;

  @override
  State<TarotReadingPage> createState() => _TarotReadingPageState();
}

class _TarotReadingPageState extends State<TarotReadingPage>
    with ReadingPageMixin, ReadingPageDateRangeSheet {
  @override
  Widget build(BuildContext context) {
    return ReadingPageScope(
      state: this,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const ReadingHeader(),
              ValueListenableBuilder(
                valueListenable: selectedFilter,
                builder: (context, filter, _) {
                  return ValueListenableBuilder(
                    valueListenable: customDateRange,
                    builder: (context, range, _) {
                      if (filter == TarotReadingDateFilter.allTime) {
                        return const SizedBox.shrink();
                      }
                      return const ReadingDateRangeBadge();
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
                            if (state.isFetchingSavedReadings) {
                              return Center(
                                child: SpinKitFadingCircle(
                                  color: context.colors.primary,
                                  size: 32,
                                ),
                              );
                            }
                            if (state.hasFetchSavedReadingsFailed) {
                              return _EmptyOrErrorWidget(
                                message: LocaleKeys.tarot_daily_error_desc.tr(),
                                onTap: () {
                                  final session = context.read<AuthCubit>().state.sessionOrCrash;
                                  context.read<TarotBloc>().addFetchSavedReadingsRequested(
                                    request: FetchSavedReadingsRequest(session: session),
                                  );
                                },
                              );
                            }
                            if (state.hasFetchSavedReadingsSucceeded) {
                              final allReadings = state.savedReadingsOrEmpty.asList();
                              final readings = filteredReadings(
                                filter: filter,
                                allReadings: allReadings,
                                range: range,
                              );
                              if (readings.isEmpty) {
                                return _EmptyOrErrorWidget(
                                  message: LocaleKeys.tarot_daily_empty_desc.tr(),
                                  onTap: () => widget.onNavbarTap?.call(),
                                );
                              }
                              return ListView.builder(
                                padding: Sp.medium.padVR,
                                itemCount: readings.length,
                                itemBuilder: (context, index) {
                                  return ReadingListItem(
                                    reading: readings[index],
                                    isFirst: index == 0,
                                    isLast: index == readings.length - 1,
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
      ),
    );
  }
}

class _EmptyOrErrorWidget extends StatelessWidget {
  const _EmptyOrErrorWidget({required this.message, required this.onTap});
  final String message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FancyButton(
          onTap: onTap,
          text: message,
          width: 160.w,
          height: 40.h,
          textStyle: m10w600(context).copyWith(color: context.colors.textOnPrimary),
        ),
        Sp.xxlarge.heightBox,
        CustomCacheNetworkImage(
          imageUrl: TarotAppAssets.emptyHttp,
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.3,
        ),
      ],
    );
  }
}
