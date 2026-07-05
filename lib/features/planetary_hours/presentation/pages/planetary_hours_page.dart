import 'dart:async';

import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/util/user_location_codec.dart';
import 'package:daily_tarot_focus/core/widgets/city_picker_sheet.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_properties.dart';
import 'package:daily_tarot_focus/features/planetary_hours/data/planetary_location_service.dart';
import 'package:daily_tarot_focus/features/planetary_hours/domain/planetary_hour_calculator.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/birth_timezone_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../helpers/planetary_hours_page_mixin.dart';
part '../helpers/planetary_hours_page_scope.dart';
part '../helpers/planetary_ruler_ui.dart';
part '../widgets/planetary_current_hour_card.dart';
part '../widgets/planetary_empty_view.dart';
part '../widgets/planetary_hours_list.dart';
part '../widgets/planetary_info_row.dart';

class PlanetaryHoursPage extends StatefulWidget {
  const PlanetaryHoursPage({super.key});

  @override
  State<PlanetaryHoursPage> createState() => _PlanetaryHoursPageState();
}

class _PlanetaryHoursPageState extends State<PlanetaryHoursPage>
    with PlanetaryHoursPageMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PlanetaryHoursPageScope(
      state: this,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              TarotAppBar(
                title: LocaleKeys.planetary_page_title.tr(),
                titleStyle: m18w700(context),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: location,
                  builder: (context, loc, _) {
                    if (loc == null) return const PlanetaryEmptyView();
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        Sp.screen.w,
                        Sp.medium.h,
                        Sp.screen.w,
                        Sp.xxxlarge.h + MediaQuery.of(context).padding.bottom,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: schedule,
                        builder: (context, sched, _) {
                          if (sched == null) {
                            return Padding(
                              padding: EdgeInsets.only(top: Sp.xxxlarge.h),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const PlanetaryCurrentHourCard(),
                              Sp.large.heightBox,
                              PlanetaryInfoRow(schedule: sched),
                              Sp.large.heightBox,
                              Text(
                                LocaleKeys.planetary_page_day_hours.tr(),
                                style: m15w600(context),
                              ),
                              Sp.small.heightBox,
                              PlanetaryHoursList(
                                hours: sched.hours
                                    .where((h) => h.isDaylight)
                                    .toList(),
                              ),
                              Sp.large.heightBox,
                              Text(
                                LocaleKeys.planetary_page_night_hours.tr(),
                                style: m15w600(context),
                              ),
                              Sp.small.heightBox,
                              PlanetaryHoursList(
                                hours: sched.hours
                                    .where((h) => !h.isDaylight)
                                    .toList(),
                              ),
                              Sp.medium.heightBox,
                              Center(
                                child: Text(
                                  LocaleKeys.planetary_page_computed_note.tr(
                                    args: [loc.name],
                                  ),
                                  style: m11w400(context).copyWith(
                                    color: context.colors.textSecondary
                                        .withValues(alpha: 0.6),
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
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
