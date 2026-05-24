import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/core/subscription/premium_override_service.dart';
import 'package:daily_tarot_focus/features/tarot/data/daily_spread_usage_service.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/pages/tarot_spread_step6_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';

mixin Step6PageMixin on State<TarotSpreadStep6Page> {
  final ValueNotifier<bool> isReadingReady = ValueNotifier(false);

  @override
  void dispose() {
    isReadingReady.dispose();
    super.dispose();
  }

  Future<void> onStartReading() async {
    final authState = context.read<AuthCubit>().state;
    final user = authState.userOrCrash as TarotUser;
    final now = context.networkNow();
    final isPremium = PremiumOverrideService.isPremium(
      user: user,
      networkTime: now,
    );
    final count = await DailySpreadUsageService.getCount(
      userId: user.userId,
      date: now,
    );
    final limit = DailySpreadUsageService.limitFor(isPremium: isPremium);

    if (!mounted) return;
    if (count >= limit) {
      if (isPremium) {
        await _showDailyLimitSheet();
      } else {
        unawaited(context.push(AppRoutes.subscriptionPaywall));
      }
      return;
    }

    await context.pushNamed(AppRoutes.tarotReadingLoading);
  }

  Future<void> _showDailyLimitSheet() {
    final colors = context.colors;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            padding: EdgeInsets.fromLTRB(
              Sp.screen.w,
              Sp.large.h,
              Sp.screen.w,
              Sp.screen.h,
            ),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: Sp.xlarge.radiusR,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomCacheNetworkImage(
                  imageUrl: TarotAppAssets.emptyHttp,
                  fit: BoxFit.contain,
                  height: 150.h,
                ),
                Sp.medium.heightBox,
                Text(
                  LocaleKeys.tarot_question_daily_limit_title.tr(),
                  style: m20w700(context),
                  textAlign: TextAlign.center,
                ),
                Sp.small.heightBox,
                Text(
                  LocaleKeys.tarot_question_daily_limit_desc.tr(),
                  style: m13w500(context).copyWith(
                    color: colors.textSecondary,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                Sp.large.heightBox,
                FancyButton(
                  onTap: () => Navigator.of(sheetContext).pop(),
                  text: LocaleKeys.tarot_question_daily_limit_button.tr(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
