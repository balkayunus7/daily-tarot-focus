import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_career_page.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_relationship_page.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_step_zodiac_page.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/splash_page.dart';
import 'package:daily_tarot_focus/features/core/home/home_page.dart';
import 'package:daily_tarot_focus/features/core/settings/settings_page.dart';
import 'package:daily_tarot_focus/features/core/subscription/pages/tarot_subscription_paywall_page.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_daily/page/tarot_daily_detail_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_deck/pages/tarot_deck_detail_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_deck/pages/tarot_deck_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/pages/tarot_question_step1_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/pages/tarot_question_step2_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/pages/tarot_question_step3_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/pages/tarot_reading_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/pages/tarot_reveal_detail_page.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/pages/tarot_reveal_page.dart';
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
          child: const PopScope(canPop: false, child: RegisterStepZodiacPage()),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.registerStepRelationship,
      name: AppRoutes.registerStepRelationship,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const PopScope(canPop: false, child: RegisterStepRelationshipPage()),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.registerStepCareer,
      name: AppRoutes.registerStepCareer,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const PopScope(canPop: false, child: RegisterStepCareerPage()),
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
        return MaterialPage(
          key: state.pageKey,
          child: const TarotRevealPage(),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.tarotRevealDetail}/:tarotId',
      name: AppRoutes.tarotRevealDetail,
      pageBuilder: (context, state) {
        final extraTarot = state.extra as TarotCardModel?;
        if (extraTarot != null) {
          return MaterialPage(
            key: state.pageKey,
            child: TarotRevealDetailPage(tarot: extraTarot),
          );
        }

        final tarotId = state.pathParameters['tarotId'];
        final cubit = context.read<TarotLocalizationCubit>();
        final tarot = tarotId != null ? cubit.getByTitle(tarotId) : cubit.getRandomCard();

        return MaterialPage(
          key: state.pageKey,
          child: TarotRevealDetailPage(
            tarot: tarot ?? cubit.state.allCards.first,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tarotDeck,
      name: AppRoutes.tarotDeck,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const TarotDeckPage(),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.tarotDeckDetail}/:tarotId',
      name: AppRoutes.tarotDeckDetail,
      pageBuilder: (context, state) {
        final tarotId = state.pathParameters['tarotId'] ?? '';

        return MaterialPage(
          key: state.pageKey,
          child: TarotDeckDetailPage(tarotId: tarotId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tarotQuestionStep1,
      name: AppRoutes.tarotQuestionStep1,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const TarotQuestionStep1Page(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tarotQuestionStep2,
      name: AppRoutes.tarotQuestionStep2,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const TarotQuestionStep2Page(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tarotQuestionStep3,
      name: AppRoutes.tarotQuestionStep3,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const TarotQuestionStep3Page(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tarotReading,
      name: AppRoutes.tarotReading,
      pageBuilder: (context, state) {
        final questionData = state.extra! as TarotQuestionData;

        return MaterialPage(
          key: state.pageKey,
          child: PopScope(canPop: false, child: TarotReadingPage(questionData: questionData)),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.tarotDailyDetail,
      name: AppRoutes.tarotDailyDetail,
      pageBuilder: (context, state) {
        final tarot = state.extra! as TarotCardModel;
        return MaterialPage(
          key: state.pageKey,
          child: TarotDailyDetailPage(tarot: tarot),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.subscriptionPaywall,
      name: AppRoutes.subscriptionPaywall,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const TarotSubscriptionPaywallPage(),
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
