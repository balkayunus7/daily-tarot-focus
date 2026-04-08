import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/features/core/home/home_bottom_navbar.dart';
import 'package:daily_tarot_focus/features/core/settings/settings_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_daily/page/tarot_daily_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_explore/pages/tarot_explore_page.dart';
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
    with RouteAwareAnalyticsMixin, RouteAwareAnalyticsPageParamsMixin {
  late PageController pageController;
  int currentIndex = 0;

  Future<void> _onBottomNavigationBarTap(int index) async {
    await HapticFeedbackHelper.selectionClick();
    setState(() {
      currentIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();

    final initialTab = widget.arguments.initialTabIndex;
    pageController = PageController(initialPage: initialTab);
    currentIndex = initialTab;
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newArgs = widget.arguments;
    final oldArgs = oldWidget.arguments;

    var shouldJump = false;
    if (newArgs.forceUpdateKey != null && newArgs.forceUpdateKey != oldArgs.forceUpdateKey) {
      shouldJump = true;
    } else if (newArgs.initialTabIndex != oldArgs.initialTabIndex) {
      shouldJump = true;
    }

    if (shouldJump && currentIndex != newArgs.initialTabIndex) {
      setState(() {
        currentIndex = newArgs.initialTabIndex;
      });
      if (pageController.hasClients) {
        pageController.jumpToPage(currentIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [TarotExplorePage(), TarotDailyPage(), SettingsPage()],
      ),
      bottomNavigationBar: SafeArea(
        child: HomeBottomNavbar(currentIndex: currentIndex, onTap: _onBottomNavigationBarTap),
      ),
    );
  }
}
