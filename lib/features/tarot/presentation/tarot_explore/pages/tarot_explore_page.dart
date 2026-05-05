import 'dart:math';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_flow_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/date_time_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/explore_spread_card.dart';
part '../widgets/explore_daily_card_cooldown.dart';
part '../widgets/explore_feature_card.dart';
part '../widgets/explore_header.dart';
part '../widgets/explore_paywall_card.dart';
part '../widgets/explore_ask_question_card.dart';
part '../widgets/explore_zodiac_card.dart';
part '../widgets/explore_compatibility_card.dart';
part '../widgets/explore_horoscope_card.dart';

class TarotExplorePage extends StatefulWidget {
  const TarotExplorePage({super.key});

  @override
  State<TarotExplorePage> createState() => _TarotExplorePageState();
}

class _TarotExplorePageState extends State<TarotExplorePage> {
  late final ValueNotifier<int> selected;

  @override
  void initState() {
    selected = ValueNotifier(0);
    super.initState();
  }

  @override
  void dispose() {
    selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Sp.large.padAllR,
          child: ValueListenableBuilder(
            valueListenable: selected,
            builder: (_, selectedIndex, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ExploreHeader(),
                  Sp.large.heightBox,
                  _ExploreTabSwitch(
                    selectedIndex: selectedIndex,
                    onTabChanged: (i) => selected.value = i,
                  ),
                  Sp.large.heightBox,
                  if (selectedIndex == 0) ...[
                    const ExploreAskQuestionCard(),
                    Sp.medium.heightBox,
                    const ExploreSpreadCard(),
                    Sp.large.heightBox,
                    Text(LocaleKeys.explore_page_spiritual_guide.tr(), style: m15w600(context)),
                    Sp.medium.heightBox,
                    Row(
                      children: [
                        const Expanded(child: ExploreDailyCardWithCooldown()),
                        Sp.medium.widthBox,
                        Expanded(
                          child: ExploreFeatureCard(
                            title: LocaleKeys.explore_page_deck.tr(),
                            imageWidget: const _SacredDecksIllustration(),
                            onTap: () => context.push(AppRoutes.tarotDeck),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const ExploreHoroscopeCard(),
                    Sp.large.heightBox,
                    Text(LocaleKeys.compat_page_section_label.tr(), style: m15w600(context)),
                    Sp.medium.heightBox,
                    Row(
                      children: [
                        const Expanded(child: ExploreZodiacCard()),
                        Sp.medium.widthBox,
                        const Expanded(child: ExploreCompatibilityCard()),
                      ],
                    ),
                  ],
                  Sp.large.heightBox,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ExploreTabSwitch extends StatelessWidget {
  const _ExploreTabSwitch({required this.selectedIndex, required this.onTabChanged});
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: colors.borderSecondary, width: 0.5),
      ),
      child: Row(
        children: [
          _TabItem(
            label: LocaleKeys.explore_page_tab_tarot.tr(),
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          _TabItem(
            label: LocaleKeys.explore_page_tab_horoscope.tr(),
            isSelected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.label, required this.isSelected, required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      colors: [colors.gradientStart, colors.gradientEnd],
                    )
                    : null,
            borderRadius: BorderRadius.circular(100),
            boxShadow: isSelected ? colors.primary.mediumShadow : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: m13w600(context).copyWith(
              color: isSelected ? colors.textOnPrimary : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
