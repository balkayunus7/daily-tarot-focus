import 'dart:io';

import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/features/auth/domain/entities/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_zodiac_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/routing/route_aware_analytics_mixin.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/splash_view.dart';

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

  void routeToRegisterSteps() {
    final authState = context.read<AuthCubit>().state;
    final user = authState.userOrCrash;
    if (user is! TarotUser) return;
    context.goNamed(RegisterStep1ZodiacPage.route);
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
              routeToRegisterSteps();
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) {
              return previous.isInitial &&
                  !current.isInitial &&
                  !current.isAuthenticated;
            },
            listener: (context, state) {
              context.read<AuthCubit>().signInAnonymously();
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
