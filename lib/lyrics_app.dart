import 'package:daily_tarot_focus/presentation/core/constants/lyrics_app_colors.dart';
import 'package:daily_tarot_focus/presentation/home/home_page.dart';
import 'package:daily_tarot_focus/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/analytics/analytics_cubit.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/application/color_theme/color_theme_bloc.dart';
import 'package:mobile_boilerplate/application/launcher/launcher.dart';
import 'package:mobile_boilerplate/application/native_permissions/native_permissions_bloc.dart';
import 'package:mobile_boilerplate/application/network_time/network_time_provider.dart';
import 'package:mobile_boilerplate/application/purchases/purchases_bloc.dart';
import 'package:mobile_boilerplate/application/remote_notification/remote_notification_cubit.dart';
import 'package:mobile_boilerplate/application/remote_notification/remote_notification_token_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/core_app.dart';

class LyricsApp extends StatelessWidget {
  const LyricsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ColorThemeBloc>()..addStarted()),
        BlocProvider(create: (_) => getIt<AnalyticsCubit>()),
        BlocProvider(create: (_) => getIt<RemoteNotificationCubit>()),
        BlocProvider(create: (_) => getIt<RemoteNotificationTokenCubit>()),
        BlocProvider(create: (_) => getIt<NativePermissionBloc>()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<PurchasesBloc>()),
        BlocProvider(create: (_) => getIt<AnalyticsCubit>()),
        Provider<Launcher>(create: (_) => getIt<Launcher>()),
        Provider<NetworkTimeProvider>(
          create: (_) => getIt<NetworkTimeProvider>(),
        ),
      ],
      child: CoreApp(
        darkColors: LyricsAppColorsDark(),
        lightColors: LyricsAppColorsLight(),
        onGenerateRoute: onGenerateRoute,
        initialRoute: SplashPage.route,
        fontFamily: 'Geist',
        supportedLocales: [const Locale('en')],
      ),
    );
  }
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashPage.route:
      return MaterialPageRoute(builder: (context) => SplashPage());
    case HomePage.route:
      return MaterialPageRoute(
        builder:
            (context) =>
                HomePage(arguments: settings.arguments as HomePageArguments),
      );
    default:
      return null;
  }
}
