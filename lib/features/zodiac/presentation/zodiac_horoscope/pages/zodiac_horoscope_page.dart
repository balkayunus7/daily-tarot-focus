import 'package:daily_tarot_focus/core/util/locale_extensions.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac_bloc.dart';
import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac_state.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_horoscope_request_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_horoscope_response_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/horoscope_period_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/horoscope_category_tile.dart';
part '../widgets/horoscope_critical_days_card.dart';
part '../widgets/horoscope_general_card.dart';
part '../widgets/horoscope_header.dart';
part '../widgets/horoscope_shimmer.dart';
part '../widgets/horoscope_stats_grid.dart';
part '../widgets/horoscope_tips_card.dart';
part '../widgets/horoscope_error_card.dart';
part '../helpers/zodiac_horoscope_page_mixin.dart';
part '../helpers/zodiac_horoscope_page_scope.dart';

class ZodiacHoroscopeArgs {
  const ZodiacHoroscopeArgs({required this.sign, this.initialIndex = 0});
  final ZodiacSign sign;
  final int initialIndex;
}

class ZodiacHoroscopePage extends StatefulWidget {
  const ZodiacHoroscopePage({
    required this.sign,
    this.initialIndex = 0,
    super.key,
  });
  final ZodiacSign sign;
  final int initialIndex;

  @override
  State<ZodiacHoroscopePage> createState() => _ZodiacHoroscopePageState();
}

class _ZodiacHoroscopePageState extends State<ZodiacHoroscopePage>
    with TickerProviderStateMixin, ZodiacHoroscopePageMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ZodiacHoroscopePageScope(
      state: this,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              TarotAppBar(
                title: LocaleKeys.horoscope_page_title.tr(),
                titleStyle: m18w700(context),
              ),
              HoroscopeHeader(sign: widget.sign),
              Sp.xsmall.heightBox,
              TabBar(
                controller: tabController,
                indicatorColor: colors.textPrimary,
                indicatorWeight: 2.5,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: colors.textPrimary,
                unselectedLabelColor: colors.textSecondary.withValues(
                  alpha: 0.45,
                ),
                labelStyle: m15w700(context),
                unselectedLabelStyle: m13w500(context),
                dividerColor: colors.border,
                tabs:
                    HoroscopePeriod.values
                        .map((p) => Tab(text: p.tabLabel))
                        .toList(),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children:
                      HoroscopePeriod.values.map((period) {
                        return _HoroscopeTabContent(
                          sign: widget.sign,
                          period: period,
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoroscopeTabContent extends StatelessWidget {
  const _HoroscopeTabContent({required this.sign, required this.period});
  final ZodiacSign sign;
  final HoroscopePeriod period;

  @override
  Widget build(BuildContext context) {
    final cacheKey =
        '${sign.name}_${period.name}_${context.currentLocaleLanguage.value}';

    return BlocBuilder<ZodiacBloc, ZodiacState>(
      buildWhen: (p, c) {
        final key =
            '${sign.name}_${period.name}_${context.currentLocaleLanguage.value}';
        return p.isGeneratingHoroscope != c.isGeneratingHoroscope ||
            p.horoscopeCache[key] != c.horoscopeCache[key] ||
            p.fetchHoroscopeFailureOrResult != c.fetchHoroscopeFailureOrResult;
      },
      builder: (context, state) {
        final cached = state.horoscopeCache[cacheKey];
        final response = cached?.response;

        if (response == null &&
            !state.isGeneratingHoroscope &&
            state.hasGeneratedHoroscopeFailed) {
          return Center(child: HoroscopeErrorCard(period: period));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            Sp.screen.w,
            Sp.large.h,
            Sp.screen.w,
            Sp.xxxlarge.h + MediaQuery.of(context).padding.bottom,
          ),
          child: Builder(
            builder: (context) {
              if (response == null) return HoroscopeShimmer(period: period);
              return _HoroscopeContent(
                sign: sign,
                period: period,
                response: response,
              );
            },
          ),
        );
      },
    );
  }
}

class _HoroscopeContent extends StatelessWidget {
  const _HoroscopeContent({
    required this.sign,
    required this.period,
    required this.response,
  });
  final ZodiacSign sign;
  final HoroscopePeriod period;
  final HoroscopeResponseModel response;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GeneralCard(text: response.generalText),
        Sp.medium.heightBox,
        StatsGrid(categories: response.categories),
        Sp.medium.heightBox,
        ...response.categories.map(
          (cat) => Padding(
            padding: EdgeInsets.only(bottom: Sp.small.h),
            child: HoroscopeCategoryTile(category: cat),
          ),
        ),
        Sp.small.heightBox,
        TipsCard(period: period, tips: response.tips),
        Sp.medium.heightBox,
        CriticalDaysCard(criticalDays: response.criticalDays),
      ],
    );
  }
}
