import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/domain/auth/data/tarot_user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/tarot_greeting_header.dart';
part '../widgets/tarot_daily_card.dart';
part '../widgets/tarot_base_card.dart';
part '../widgets/tarot_paywall_card.dart';

class TarotPage extends StatelessWidget {
  const TarotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TarotGreetingHeader(),
              Spacing.largeH,
              const TarotDailyCard(),
              Spacing.largeH,
              const TarotPaywallCard(),
              Spacing.largeH,
              Text(
                'Ruhsal Rehberin',
                style: m16w500(context),
              ),
              Spacing.mediumH,
              Row(
                children: [
                  Expanded(
                    child: TarotBaseCard(
                      subtitle: 'Yes/No Card',
                      imagePath: TarotAppAssets.yesNoCard.path,
                      onTap: () {},
                    ),
                  ),
                  Spacing.mediumW,
                  Expanded(
                    child: TarotBaseCard(
                      subtitle: 'Guide Card',
                      imagePath: TarotAppAssets.guide.path,
                      onTap: () {},
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
