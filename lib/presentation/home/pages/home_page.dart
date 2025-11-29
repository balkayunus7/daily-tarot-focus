import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/haptic_feedback_helper.dart';
import 'package:daily_tarot_focus/presentation/home/widgets/home_bottom_navbar.dart';
import 'package:daily_tarot_focus/presentation/tarot/pages/tarot_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/presentation/routing/route_arguments.dart';
import 'package:mobile_boilerplate/presentation/routing/route_aware_analytics_mixin.dart';

class HomePageArguments extends RouteArguments {
  const HomePageArguments(super.context, {this.initialTabIndex = 0});
  final int initialTabIndex;

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), 'initial_tab_index': initialTabIndex};
  }
}

class HomePage extends StatefulWidget {
  const HomePage({required this.arguments, super.key});
  final HomePageArguments arguments;

  static void go(BuildContext context, {int initialTabIndex = 0}) {
    context.go(
      AppRoutes.home,
      extra: HomePageArguments(context, initialTabIndex: initialTabIndex),
    );
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [TarotPage(), TarotPage(), TarotPage()],
      ),
      bottomNavigationBar: SafeArea(
        child: HomeBottomNavbar(
          currentIndex: currentIndex,
          onTap: _onBottomNavigationBarTap,
        ),
      ),
    );
  }
}
