import 'dart:io';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/features/auth/presentation/widgets/splash_view.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
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
      Future.delayed(const Duration(seconds: 1), () async {
        if (!mounted) return;
        final authCubit = context.read<AuthCubit>();
        await authCubit.initialize(requestAttAuth: Platform.isIOS);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<TarotBloc, TarotState>(
            listenWhen: (previous, current) {
              return (previous.hasFetchedDailyCardsSucceeded !=
                  current.hasFetchedDailyCardsSucceeded);
            },
            listener: (context, state) {
              context.go(AppRoutes.tarotExplore);
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) {
              return current.isAuthenticated && (previous.isInitial || !previous.isAuthenticated);
            },
            listener: (context, state) async {
              final authState = context.read<AuthCubit>().state;
              context.read<TarotBloc>().addFetchDailyCardsRequested(
                request: FetchDailyCardsRequest(session: authState.sessionOrCrash),
              );
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) {
              return previous.isInitial && !current.isInitial && !current.isAuthenticated;
            },
            listener: (context, state) async {
              await context.read<AuthCubit>().signInAnonymously();
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
