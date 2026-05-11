import 'dart:io';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/features/auth/presentation/widgets/splash_view.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/routing/route_aware_analytics_mixin.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with RouteAwareAnalyticsMixin, RouteAwareAnalyticsPageParamsMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final authCubit = context.read<AuthCubit>();
      await authCubit.initialize(requestAttAuth: Platform.isIOS);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<TarotBloc, TarotState>(
            listenWhen:
                (prev, curr) =>
                    prev.isSettingUpAccount &&
                    !curr.isSettingUpAccount &&
                    curr.hasAccountSetupCompleted,
            listener: (context, state) {
              context.go(AppRoutes.tarotExplore);
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) {
              return current.isAuthenticated && (previous.isInitial || !previous.isAuthenticated);
            },
            listener: (context, state) {
              final session = context.read<AuthCubit>().state.sessionOrCrash;
              context.read<TarotBloc>().addSetupAccountRequested(
                session: session,
                locale: context.locale.languageCode,
              );
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) {
              return previous.isInitial && !current.isInitial && !current.isAuthenticated;
            },
            listener: (context, state) async {
              final authCubit = context.read<AuthCubit>();
              await authCubit.signInAnonymously();
            },
          ),
        ],
        child: SplashView(
          logo: SizedBox(
            width: 150,
            height: 150,
            child: Lottie.asset(
              TarotAppAssets.tarot.path,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
            ),
          ),
        ),
      ),
    );
  }
}
