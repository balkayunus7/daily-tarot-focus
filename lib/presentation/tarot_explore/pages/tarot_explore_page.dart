import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/decoration_extensions.dart';
import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/tarot_feature_card.dart';
part '../widgets/tarot_daily_card.dart';
part '../widgets/tarot_header.dart';
part '../widgets/tarot_paywall_card.dart';

class TarotExplorePage extends StatelessWidget {
  const TarotExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: Spacing.largePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TarotHeader(),
              Spacing.largeH,
              const TarotDailyCard(),
              Spacing.largeH,
              const TarotPaywallCard(),
              Spacing.largeH,
              Text(LocaleKeys.exploreSpiritualGuide.tr(), style: m16w500(context)),
              Spacing.mediumH,
              Row(
                children: [
                  Expanded(
                    child: TarotFeatureCard(
                      title: LocaleKeys.exploreYesNoCard.tr(),
                      imagePath: TarotAppAssets.yesNoCard.path,
                      onTap: () => context.push(AppRoutes.tarotQuestion),
                    ),
                  ),
                  Spacing.mediumW,
                  Expanded(
                    child: TarotFeatureCard(
                      title: LocaleKeys.exploreLibrary.tr(),
                      imagePath: TarotAppAssets.guide.path,
                      onTap: () => context.push(AppRoutes.tarotLibrary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
