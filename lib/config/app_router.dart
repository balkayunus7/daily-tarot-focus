import 'package:daily_tarot_focus/application/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:daily_tarot_focus/presentation/auth/pages/register_step_birthdate_page.dart';
import 'package:daily_tarot_focus/presentation/auth/pages/register_step_relationship_page.dart';
import 'package:daily_tarot_focus/presentation/auth/pages/register_step_zodiac_page.dart';
import 'package:daily_tarot_focus/presentation/auth/pages/splash_page.dart';
import 'package:daily_tarot_focus/presentation/home/pages/home_page.dart';
import 'package:daily_tarot_focus/presentation/settings/pages/settings_page.dart';
import 'package:daily_tarot_focus/presentation/tarot_library/pages/tarot_library_detail_page.dart';
import 'package:daily_tarot_focus/presentation/tarot_library/pages/tarot_library_page.dart';
import 'package:daily_tarot_focus/presentation/tarot_question/pages/tarot_question_page.dart';
import 'package:daily_tarot_focus/presentation/tarot_reveal/pages/tarot_reveal_detail_page.dart';
import 'package:daily_tarot_focus/presentation/tarot_reveal/pages/tarot_reveal_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) return null;

    final authCubit = navigatorContext.read<AuthCubit>();
    final authState = authCubit.state;
    final location = state.matchedLocation;
    final isPublicRoute = AppRoutes.publicRoutes.contains(location);
    final isRegisterRoute = AppRoutes.registerRoutes.contains(location);

    if (authState.isInitial) return null;

    if (!authState.isAuthenticated && !isPublicRoute) {
      return AppRoutes.splash;
    }

    if (authState.isAuthenticated && !isPublicRoute && !isRegisterRoute) {
      final user = authState.userOrCrash;
      if (user is TarotUser && !user.isProfileComplete) {
        return AppRoutes.registerStepZodiac;
      }
    }

    if (authState.isAuthenticated && isPublicRoute) {
      final user = authState.userOrCrash;
      if (user is TarotUser && user.isProfileComplete) {
        return AppRoutes.tarotExplore;
      }
    }

    return null;
  },
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
      path: '${AppRoutes.tarotRevealDetail}/:tarotId',
      name: AppRoutes.tarotRevealDetail,
      pageBuilder: (context, state) {
        // Try to get tarot from extra first, fallback to cubit lookup
        final extraTarot = state.extra as TarotCard?;
        if (extraTarot != null) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: TarotRevealDetailPage(tarot: extraTarot),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return child;
            },
          );
        }

        final tarotId = state.pathParameters['tarotId'];
        final cubit = context.read<TarotLocalizationCubit>();
        final tarot = tarotId != null ? cubit.getByTitle(tarotId) : cubit.getRandomCard();

        return CustomTransitionPage(
          key: state.pageKey,
          child: TarotRevealDetailPage(
            tarot: tarot ?? cubit.state.allCards.first,
          ),
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
          child: const TarotDataPage(),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.tarotLibraryDetail}/:tarotId',
      name: AppRoutes.tarotLibraryDetail,
      pageBuilder: (context, state) {
        final tarotId = state.pathParameters['tarotId'] ?? '';

        return MaterialPage(
          key: state.pageKey,
          child: TarotDataDetailPage(tarotId: tarotId),
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
    GoRoute(
      path: AppRoutes.settings,
      name: AppRoutes.settings,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const SettingsPage(),
        );
      },
    ),
  ],
);
