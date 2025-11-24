import 'dart:io';

import 'package:daily_tarot_focus/presentation/core/constants/tarot_app_assets.dart';
import 'package:daily_tarot_focus/presentation/core/constants/tarot_app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/routing/route_aware_analytics_mixin.dart';
import 'package:daily_tarot_focus/presentation/home/home_page.dart';
import 'package:daily_tarot_focus/presentation/splash/splash_view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static const route = 'splash_page';
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with RouteAwareAnalyticsMixin, RouteAwareAnalyticsPageParamsMixin {
  @override
  void initState() {
    final authCubit = context.read<AuthCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        authCubit.initialize(requestAttAuth: Platform.isIOS);
      });
    });

    super.initState();
  }

  void routeHomePageOrOnboarding() {
    final authCubit = context.read<AuthCubit>();
    final session = authCubit.state.sessionOrCrash;
    final isNewUser = session.isNewUser;

    HomePage.pushReplacement(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) {
              return previous.isInitial && current.isAuthenticated;
            },
            listener: (context, state) {
              routeHomePageOrOnboarding();
            },
          ),
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) {
            final shouldSignIn =
                previous.isInitial &&
                !current.isAuthenticated &&
                !current.isInitial &&
                current.failOrUserOption.isNone();
            return shouldSignIn;
          },
          listener: (context, state) {
            context.read<AuthCubit>().signInAnonymously();
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) {
            return !previous.isAuthenticated && current.isAuthenticated;
          },
          listener: (context, state) {
            Navigator.of(context).pushReplacementNamed('home');
          },
        ),
        ],
        child: TarotsSplashView(
          logo: ClipRRect(
            borderRadius: Spacing.circularBorderRadius,
            child: Image.asset(
              TarotAppAssets.appLogo.path,
              width: 120,
              height: 120,
            ),
          ),
        ),
      ),
    );
  }
}
