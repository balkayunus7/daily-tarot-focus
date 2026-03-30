import 'dart:async';

import 'package:daily_tarot_focus/application/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/application/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/purchases/subscription_plan.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';
import 'package:mobile_boilerplate/presentation/routing/route_arguments.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/explore_ask_question_card.dart';
part '../widgets/explore_daily_card_cooldown.dart';
part '../widgets/explore_feature_card.dart';
part '../widgets/explore_header.dart';
part '../widgets/explore_paywall_card.dart';

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
              const ExploreHeader(),
              Spacing.largeH,
              const ExploreAskQuestionCard(),
              Spacing.largeH,
              const ExplorePaywallCard(),
              Spacing.largeH,
              Text(LocaleKeys.exploreSpiritualGuide.tr(), style: m16w500(context)),
              Spacing.mediumH,
              Row(
                children: [
                  const Expanded(child: ExploreDailyCardWithCooldown()),
                  Spacing.mediumW,
                  Expanded(
                    child: ExploreFeatureCard(
                      title: LocaleKeys.exploreLibrary.tr(),
                      imagePath: TarotAppAssets.library.path,
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
