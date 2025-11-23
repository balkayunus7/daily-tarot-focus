import 'package:daily_tarot_focus/domain/remote_notification/remote_notification_message.dart';
import 'package:daily_tarot_focus/restartable_app.dart';
import 'package:flutter/material.dart';
import 'package:mobile_core/application/auth/auth_cubit.dart';
import 'package:mobile_core/application/remote_notification/remote_notification_cubit.dart';
import 'package:mobile_core/application/remote_notification/remote_notification_token_cubit.dart';
import 'package:mobile_core/common_dependencies.dart';
import 'package:mobile_core/domain/remote_notification/remote_notification.dart';
import 'package:mobile_core/presentation/routing/route_arguments.dart';
import 'package:mobile_core/presentation/routing/route_aware_analytics_mixin.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeRemoteNotification();
    });
  }

  void initializeRemoteNotification() {
    final remoteNotifCubit = context.read<RemoteNotificationCubit>();
    final remoteNotifTokenCubit = context.read<RemoteNotificationTokenCubit>();
    remoteNotifCubit.clearBadges();
    remoteNotifCubit.initialize();
    remoteNotifTokenCubit.initialize();
  }

  Future<void> _onRemoteNotificationArrived(
    RemoteNotification notification,
  ) async {
    switch (notification) {
      case RemoteNotificationDefault _:
        await pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) {
            return previous.isAuthenticated && !current.isAuthenticated;
          },
          listener: (context, _) {
            RestartableApp.restartApp(context);
          },
        ),
        BlocListener<RemoteNotificationCubit, RemoteNotificationState>(
          listener: (context, state) {
            switch (state) {
              case RemoteNotificationInitialized _:
                if (state.hasInitialNotification) {
                  _onRemoteNotificationArrived(
                    state.initialNotificationOrCrash,
                  );
                }
              case RemoteNotificationPressed _:
                _onRemoteNotificationArrived(state.notification);
              case RemoteNotificationReceived _:
              case RemoteNotificationInitial _:
            }
          },
        ),
        BlocListener<
          RemoteNotificationTokenCubit,
          RemoteNotificationTokenState
        >(
          listener: (context, state) {
            if (!state.hasToken) return;
            context.read<AuthCubit>().setFcmToken(token: state.tokenOrCrash);
          },
        ),
      ],
      child: HomePage(arguments: HomePageArguments(context, initialTabIndex: 0),),
    );
  }
}
