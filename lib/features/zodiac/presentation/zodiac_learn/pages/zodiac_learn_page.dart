import 'dart:async';

import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/astrology_helper.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/birth_timezone_resolver.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/zodiac_page_mixin.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/zodiac_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/zodiac_calculated_view.dart';
part '../widgets/zodiac_empty_view.dart';
part '../widgets/birth_input_sheet.dart';

class ZodiacLearnPage extends StatefulWidget {
  const ZodiacLearnPage({super.key});

  @override
  State<ZodiacLearnPage> createState() => _ZodiacLearnPageState();
}

class _ZodiacLearnPageState extends State<ZodiacLearnPage> with ZodiacLearnPageMixin {
  @override
  Widget build(BuildContext context) {
    return ZodiacLearnPageScope(
      state: this,
      child: const DefaultTabController(length: 3, child: _ZodiacScaffold()),
    );
  }
}

class _ZodiacScaffold extends StatelessWidget {
  const _ZodiacScaffold();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TarotAppBar(title: LocaleKeys.zodiac_page_title.tr(), titleStyle: m18w700(context)),
            TabBar(
              indicatorColor: colors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: colors.textPrimary,
              unselectedLabelColor: colors.textSecondary.withValues(alpha: 0.5),
              labelStyle: m13w600(context),
              unselectedLabelStyle: m13w600(context),
              tabs: [
                Tab(text: '☀ ${LocaleKeys.zodiac_page_tab_sun.tr()}'),
                Tab(text: '🌙 ${LocaleKeys.zodiac_page_tab_moon.tr()}'),
                Tab(text: '⬆ ${LocaleKeys.zodiac_page_tab_rising.tr()}'),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  _SunTab(),
                  _MoonTab(),
                  _RisingTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SunTab extends StatelessWidget {
  const _SunTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, current) => current.isAuthenticated,
      builder: (context, state) {
        final sign = (state.userOrCrash as TarotUser).zodiac;
        if (sign == null) return const SizedBox.shrink();
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.xlarge.h, Sp.screen.w, Sp.xxxlarge.h),
          child: ZodiacCalculatedView(sign: sign),
        );
      },
    );
  }
}

class _MoonTab extends StatelessWidget {
  const _MoonTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, current) => current.isAuthenticated,
      builder: (context, state) {
        final sign = (state.userOrCrash as TarotUser).moonSign;
        if (sign != null) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.xlarge.h, Sp.screen.w, Sp.xxxlarge.h),
            child: ZodiacCalculatedView(sign: sign),
          );
        }
        return const ZodiacEmptyView(type: DiscoverZodiacType.moon);
      },
    );
  }
}

class _RisingTab extends StatelessWidget {
  const _RisingTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, current) => current.isAuthenticated,
      builder: (context, state) {
        final sign = (state.userOrCrash as TarotUser).risingSign;
        if (sign != null) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.xlarge.h, Sp.screen.w, Sp.xxxlarge.h),
            child: ZodiacCalculatedView(sign: sign),
          );
        }
        return const ZodiacEmptyView(type: DiscoverZodiacType.rising);
      },
    );
  }
}
