import 'package:daily_tarot_focus/features/core/home/helpers/home_page_mixin.dart';
import 'package:daily_tarot_focus/features/core/home/helpers/home_page_scope.dart';
import 'package:daily_tarot_focus/features/core/home/home_bottom_navbar.dart';
import 'package:daily_tarot_focus/features/core/settings/settings_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_explore/pages/tarot_explore_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/pages/tarot_reading_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/routing/route_arguments.dart';
import 'package:mobile_boilerplate/presentation/routing/route_aware_analytics_mixin.dart';

class HomePageArguments extends RouteArguments {
  HomePageArguments(super.context, {this.initialTabIndex = 0, this.forceUpdateKey});
  final int initialTabIndex;
  final String? forceUpdateKey;

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'initial_tab_index': initialTabIndex,
      'force_update_key': forceUpdateKey,
    };
  }
}

class HomePage extends StatefulWidget {
  const HomePage({required this.arguments, super.key});
  final HomePageArguments arguments;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with HomePageMixin, RouteAwareAnalyticsMixin, RouteAwareAnalyticsPageParamsMixin {
  @override
  Widget build(BuildContext context) {
    return HomePageScope(
      state: this,
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            const TarotExplorePage(),
            TarotReadingPage(onNavbarTap: () => onNavbarTap(0)),
            const SettingsPage(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: HomeBottomNavbar(currentIndex: currentIndex, onTap: onNavbarTap),
        ),
      ),
    );
  }
}
