import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/glass_button.dart';
import 'package:daily_tarot_focus/core/widgets/glass_container.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';
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
      body: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) => current.isAuthenticated,
        builder: (context, state) {
          final networkTime = context.networkNow();
          final isPremium = state.userOrCrash.isSubscribed(networkTime: networkTime);

          return SafeArea(
            child: Padding(
              padding: Sp.large.padAllR,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ExploreHeader(),
                  Sp.large.heightBox,
                  const ExploreAskQuestionCard(),
                  Sp.large.heightBox,
                  if (!isPremium) ...[
                    const ExplorePaywallCard(),
                    Sp.large.heightBox,
                  ],
                  Text(LocaleKeys.explore_page_spiritual_guide.tr(), style: m16w500(context)),
                  Sp.medium.heightBox,
                  Row(
                    children: [
                      const Expanded(child: ExploreDailyCardWithCooldown()),
                      Sp.medium.widthBox,
                      Expanded(
                        child: ExploreFeatureCard(
                          title: LocaleKeys.explore_page_deck.tr(),
                          imagePath: TarotAppAssets.libraryHttp,
                          onTap: () => context.push(AppRoutes.tarotDeck),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
