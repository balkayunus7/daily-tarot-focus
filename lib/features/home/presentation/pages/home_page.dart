import 'package:flutter/material.dart';
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
  const HomePage({super.key, required this.arguments});
  static const route = 'home';
  final HomePageArguments arguments;

  static Future<dynamic> pushReplacement(
    BuildContext context, {
    int initialTabIndex = 0,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false,
      arguments: HomePageArguments(context, initialTabIndex: initialTabIndex),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with RouteAwareAnalyticsMixin, RouteAwareAnalyticsPageParamsMixin {
  late PageController pageController;
  int currentIndex = 0;

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
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}
