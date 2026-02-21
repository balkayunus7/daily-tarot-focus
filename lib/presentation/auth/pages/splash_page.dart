import 'dart:io';

import 'package:daily_tarot_focus/application/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/application/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/application/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user.dart';
import 'package:daily_tarot_focus/presentation/auth/widgets/splash_view.dart';
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
    final authCubit = context.read<AuthCubit>();
    final tarotLocalCubit = context.read<TarotLocalizationCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final langCode = Localizations.localeOf(context).languageCode;
      await tarotLocalCubit.loadCards(langCode);

      Future.delayed(const Duration(seconds: 1), () async {
        if (!mounted) return;
        await authCubit.initialize(requestAttAuth: Platform.isIOS);
      });
    });
  }

  Future<void> routeOnAuthenticated() async {
    final authState = context.read<AuthCubit>().state;
    final user = authState.userOrCrash;
    if (user is! TarotUser) return;

    if (user.isProfileComplete) {
      context.go(AppRoutes.tarotExplore);
    } else {
      context.go(AppRoutes.registerStepZodiac);
    }
  }

  Future<void> _fetchDailyCards() async {
    final authState = context.read<AuthCubit>().state;
    final langCode = Localizations.localeOf(context).languageCode;

    context.read<TarotBloc>().addDailyCardsFetched(
      session: authState.sessionOrCrash,
      languageCode: langCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<TarotBloc, TarotState>(
            listenWhen: (previous, current) {
              return previous.hasFetchedDailyCards != current.hasFetchedDailyCards;
            },
            listener: (context, state) async {
              await routeOnAuthenticated();
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) {
              return current.isAuthenticated && (previous.isInitial || !previous.isAuthenticated);
            },
            listener: (context, state) async {
              await _fetchDailyCards();
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
        child: TarotSplashView(
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
