import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_birthdate_page.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_relationship_page.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_zodiac_page.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/splash_page.dart';
import 'package:daily_tarot_focus/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: SplashPage.route,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RegisterStep1ZodiacPage.route,
      name: RegisterStep1ZodiacPage.route,
      builder: (context, state) => const RegisterStep1ZodiacPage(),
    ),
    GoRoute(
      path: RegisterStep2RelationshipPage.route,
      name: RegisterStep2RelationshipPage.route,
      builder: (context, state) => const RegisterStep2RelationshipPage(),
    ),
    GoRoute(
      path: RegisterStep3BirthdatePage.route,
      name: RegisterStep3BirthdatePage.route,
      builder: (context, state) => const RegisterStep3BirthdatePage(),
    ),
    GoRoute(
      path: '/home',
      name: HomePage.route,
      builder: (context, state) {
        final args = state.extra as HomePageArguments?;
        return HomePage(arguments: args ?? HomePageArguments(context));
      },
    ),
  ],
);
