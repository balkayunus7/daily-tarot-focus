import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_birthdate_page.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_relationship_page.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_zodiac_page.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/splash_page.dart';
import 'package:daily_tarot_focus/features/home/presentation/pages/home_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/pages/tarot/reveal_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/pages/tarot_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.registerStepZodiac,
      name: AppRoutes.registerStepZodiac,
      builder: (context, state) => const RegisterStepZodiacPage(),
    ),
    GoRoute(
      path: AppRoutes.registerStepRelationship,
      name: AppRoutes.registerStepRelationship,
      builder: (context, state) => const RegisterStepRelationshipPage(),
    ),
    GoRoute(
      path: AppRoutes.registerStepBirthdate,
      name: AppRoutes.registerStepBirthdate,
      builder: (context, state) => const RegisterStepBirthdatePage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) {
        final args = state.extra as HomePageArguments?;
        return HomePage(arguments: args ?? HomePageArguments(context));
      },
    ),
    GoRoute(
      path: AppRoutes.dailyTarotReveal,
      name: AppRoutes.dailyTarotReveal,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const TarotRevealPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tarotCardDetail,
      name: AppRoutes.tarotCardDetail,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const TarotDetailPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
      },
    ),
  ],
);
