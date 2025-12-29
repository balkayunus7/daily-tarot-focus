import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_datas.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_library.dart';
import 'package:daily_tarot_focus/presentation/auth/pages/register_step_birthdate_page.dart';
import 'package:daily_tarot_focus/presentation/auth/pages/register_step_relationship_page.dart';
import 'package:daily_tarot_focus/presentation/auth/pages/register_step_zodiac_page.dart';
import 'package:daily_tarot_focus/presentation/auth/pages/splash_page.dart';
import 'package:daily_tarot_focus/presentation/home/pages/home_page.dart';
import 'package:daily_tarot_focus/presentation/tarot/pages/tarot_library_detail_page.dart';
import 'package:daily_tarot_focus/presentation/tarot/pages/tarot_library_page.dart';
import 'package:daily_tarot_focus/presentation/tarot/pages/tarot_question_page.dart';
import 'package:daily_tarot_focus/presentation/tarot/pages/tarot_reveal_detail_page.dart';
import 'package:daily_tarot_focus/presentation/tarot/pages/tarot_reveal_page.dart';
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
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const SplashPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.registerStepZodiac,
      name: AppRoutes.registerStepZodiac,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const RegisterStepZodiacPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.registerStepRelationship,
      name: AppRoutes.registerStepRelationship,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const RegisterStepRelationshipPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.registerStepBirthdate,
      name: AppRoutes.registerStepBirthdate,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const RegisterStepBirthdatePage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tarotExplore,
      name: AppRoutes.tarotExplore,
      pageBuilder: (context, state) {
        final args = state.extra as HomePageArguments?;
        return MaterialPage(
          key: state.pageKey,
          child: HomePage(arguments: args ?? HomePageArguments(context)),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tarotReveal,
      name: AppRoutes.tarotReveal,
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
      path: AppRoutes.tarotRevealDetail,
      name: AppRoutes.tarotRevealDetail,
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final tarotMap = args?['tarot'] as Map<String, dynamic>?;
        final tarot = tarotMap != null
            ? TarotLibrary.fromMap(tarotMap)
            : TarotMockDatas.randomTarotLibraryCard;

        return CustomTransitionPage(
          key: state.pageKey,
          child: TarotRevealDetailPage(tarot: tarot),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tarotLibrary,
      name: AppRoutes.tarotLibrary,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const TarotLibraryPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tarotLibraryDetail,
      name: AppRoutes.tarotLibraryDetail,
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final tarotMap = args?['tarot'] as Map<String, dynamic>;
        final tarot = TarotLibrary.fromMap(tarotMap);
        final imagePath = args?['imagePath'] as String? ?? '';

        return MaterialPage(
          key: state.pageKey,
          child: TarotLibraryDetailPage(tarot: tarot, imagePath: imagePath),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tarotQuestion,
      name: AppRoutes.tarotQuestion,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const TarotQuestionPage(),
        );
      },
    ),
  ],
);
