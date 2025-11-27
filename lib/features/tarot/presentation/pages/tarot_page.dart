import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/features/auth/domain/entities/tarot_user.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';

part '../widgets/tarot_greeting_header.dart';
part '../widgets/tarot_daily_card.dart';

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
              Text(
                'Ruhsal Rehberin',
                style: m16w500(context),
              ),
              Spacing.mediumH,
              const Row(
                children: [
                  Expanded(child: YesNoCardWidget()),
                  SizedBox(width: 16),
                  Expanded(child: TarotGuideCard()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TarotGuideCard extends StatelessWidget {
  const TarotGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 175,
        decoration: BoxDecoration(
          borderRadius: Spacing.defaultBorderRadius,
          border: Border.all(color: colors.borderSecondary, width: 0.5),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: Spacing.smallBorderRadius,
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.asset(
                      TarotAppAssets.guide.path,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: FancyContainer(
                      color: context.colors.primary,
                      borderRadius: Spacing.xlargeBorderRadius,
                      padding: Spacing.tinyPadding,
                      child: const Icon(
                        Icons.arrow_outward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Discover the meaning of the cards!',
                      style: m16w600(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YesNoCardWidget extends StatelessWidget {
  const YesNoCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      height: 175,
      decoration: BoxDecoration(
        borderRadius: Spacing.defaultBorderRadius,
        border: Border.all(color: colors.borderSecondary, width: 0.5),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: Spacing.smallBorderRadius,
                child: Opacity(
                  opacity: 0.6,
                  child: Image.asset(
                    TarotAppAssets.yesNoCard.path,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: Spacing.defaultPadding,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: FancyContainer(
                    color: context.colors.primary,
                    borderRadius: Spacing.xlargeBorderRadius,
                    padding: Spacing.tinyPadding,
                    child: const Icon(
                      Icons.arrow_outward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Yes/No Card',
                    style: m16w600(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
