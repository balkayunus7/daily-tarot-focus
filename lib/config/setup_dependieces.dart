import 'dart:io';

import 'package:daily_tarot_focus/config/app_config.dart';
import 'package:daily_tarot_focus/config/env.config.dart';
import 'package:daily_tarot_focus/features/auth/bloc/register_cubit.dart';
import 'package:daily_tarot_focus/features/auth/data/impl_android_local_notifications_service.dart';
import 'package:daily_tarot_focus/features/auth/data/impl_auth_service.dart';
import 'package:daily_tarot_focus/features/auth/data/impl_firebase_remote_notifications_service.dart';
import 'package:daily_tarot_focus/features/auth/data/impl_ios_local_notifications_service.dart';
import 'package:daily_tarot_focus/features/auth/data/impl_user_repository.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_question/tarot_question_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/i_tarot_question_repository.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/impl_tarot_question_repository.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/impl_tarot_remote_data_source.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/tarot_repository.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot_localization/impl_tarot_localization_service.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot_localization/tarot_localization_repository.dart';
import 'package:mobile_boilerplate/application/analytics/analytics_cubit.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/application/color_theme/color_theme_bloc.dart';
import 'package:mobile_boilerplate/application/deep_link/deep_link_cubit.dart';
import 'package:mobile_boilerplate/application/launcher/launcher.dart';
import 'package:mobile_boilerplate/application/native_permissions/native_permissions_bloc.dart';
import 'package:mobile_boilerplate/application/network_time/network_time_provider.dart';
import 'package:mobile_boilerplate/application/purchases/purchases_bloc.dart';
import 'package:mobile_boilerplate/application/remote_notification/remote_notification_cubit.dart';
import 'package:mobile_boilerplate/application/remote_notification/remote_notification_token_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/rate_limiter.dart';
import 'package:mobile_boilerplate/infrastructure/analytics/impl_analytics_service.dart';
import 'package:mobile_boilerplate/infrastructure/app_tracking/impl_app_tracking_service.dart';
import 'package:mobile_boilerplate/infrastructure/auth/store_checker_service.dart';
import 'package:mobile_boilerplate/infrastructure/color_theme/shared_pref_color_theme_cache.dart';
import 'package:mobile_boilerplate/infrastructure/deep_link/impl_deep_link_service.dart';
import 'package:mobile_boilerplate/infrastructure/http/http_failure_handler.dart';
import 'package:mobile_boilerplate/infrastructure/launcher/impl_launcher_service.dart';
import 'package:mobile_boilerplate/infrastructure/network_time/ntp_network_time_service.dart';
import 'package:mobile_boilerplate/infrastructure/permission/camera_permission_service.dart';
import 'package:mobile_boilerplate/infrastructure/permission/fake_permission_service.dart';
import 'package:mobile_boilerplate/infrastructure/permission/gallery_permission_service.dart';
import 'package:mobile_boilerplate/infrastructure/permission/microphone_permission_service.dart';
import 'package:mobile_boilerplate/infrastructure/permission/notification_permission_service.dart';
import 'package:mobile_boilerplate/infrastructure/purchases/revenuecat_purchases_service.dart';
import 'package:mobile_boilerplate/infrastructure/remote_notification/firebase_notifications_service.dart';
import 'package:mobile_boilerplate/infrastructure/remote_notification/local_notifications_index.dart';
import 'package:mobile_boilerplate/infrastructure/sharing/impl_sharing_service.dart';
import 'package:mobile_boilerplate/infrastructure_dependencies.dart';
import 'package:mobile_boilerplate/wrapper/app_settings_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/clipboard_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/ntp_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/purchases_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/share_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/sign_in_with_apple_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/social_share_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/url_launcher_wrapper.dart';
import 'package:supabase/supabase.dart';

Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final envConfig = EnvConfig();
  getIt
    ..registerSingleton<SupabaseClient>(
      SupabaseClient(envConfig.supabaseUrl, envConfig.supabaseAnonKey),
    )
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    ..registerSingleton<Uuid>(const Uuid())
    ..registerSingleton<NtpWrapper>(NtpWrapper())
    ..registerSingleton<AppLinks>(AppLinks())
    ..registerSingleton<DeviceInfoPlugin>(DeviceInfoPlugin())
    ..registerSingleton<PackageInfo>(await PackageInfo.fromPlatform())
    ..registerSingleton<PurchasesWrapper>(PurchasesWrapper())
    ..registerSingleton<HttpFailureHandler>(const HttpFailureHandler())
    ..registerSingleton<RateLimiter>(
      RateLimiter(maxAttempts: 3, window: const Duration(seconds: 60)),
    )
    ..registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage())
    ..registerSingleton<GoogleSignIn>(GoogleSignIn())
    ..registerSingleton<SignInWithAppleWrapper>(SignInWithAppleWrapper())
    ..registerSingleton<UrlLauncherWrapper>(UrlLauncherWrapper())
    ..registerSingleton<AppSettingsWrapper>(AppSettingsWrapper())
    // Setup infrastructure dependencies
    ..registerSingleton<ImplLauncherService>(
      ImplLauncherService(
        getIt<UrlLauncherWrapper>(),
        getIt<AppSettingsWrapper>(),
      ),
    )
    ..registerSingleton<ImplAuthService>(
      ImplAuthService(
        getIt<SupabaseClient>(),
        getIt<FlutterSecureStorage>(),
        getIt<HttpFailureHandler>(),
        getIt<RateLimiter>(),
      ),
    )
    ..registerSingleton<ImplUserRepository>(
      ImplUserRepository(getIt<SupabaseClient>(), getIt<HttpFailureHandler>()),
    )
    ..registerSingleton<NtpNetworkTimeService>(
      NtpNetworkTimeService(getIt<SharedPreferences>(), getIt<NtpWrapper>()),
    )
    ..registerSingleton<SharedPrefColorThemeCache>(
      SharedPrefColorThemeCache(getIt<SharedPreferences>()),
    )
    ..registerSingleton<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin(),
    )
    ..registerSingleton<LocalNotificationsDetailsFactory>(
      const LocalNotificationsDetailsFactory(),
    )
    ..registerSingleton<LocalNotificationsServiceInitializer>(
      const LocalNotificationsServiceInitializer(),
    )
    ..registerSingleton<IosCommunicationNotification>(
      IosCommunicationNotification(),
    )
    ..registerSingleton<ImplAppTrackingService>(ImplAppTrackingService())
    ..registerSingleton<ImplAnalyticsService>(const ImplAnalyticsService())
    // Setup permission dependencies
    ..registerSingleton<RevenuecatPurchasesService>(
      RevenuecatPurchasesService(getIt<PurchasesWrapper>()),
    )
    ..registerSingleton<MicrophonePermissionService>(
      MicrophonePermissionService(Permission.microphone),
    )
    ..registerSingleton<NotificationPermissionService>(
      NotificationPermissionService(Permission.notification),
    )
    ..registerSingleton<CameraPermissionService>(
      CameraPermissionService(Permission.camera),
    )
    ..registerSingleton<GalleryPermissionService>(
      GalleryPermissionService(Permission.photos),
    )
    ..registerSingleton<FakePermissionService>(FakePermissionService())
    ..registerFactory<FirebaseNotificationsService>(
      () => ImplFirebaseRemoteNotificationsService(
        FirebaseMessaging.instance,
        FirebaseMessaging.onMessage,
        FirebaseMessaging.onMessageOpenedApp,
      ),
    )
    ..registerSingleton<Launcher>(Launcher(getIt<ImplLauncherService>()))
    ..registerSingleton<TarotAppConfig>(TarotAppConfig())
    ..registerSingleton<ImplIOSLocalNotificationsService>(
      ImplIOSLocalNotificationsService(
        getIt<FlutterLocalNotificationsPlugin>(),
        getIt<LocalNotificationsDetailsFactory>(),
        getIt<LocalNotificationsServiceInitializer>(),
        getIt<IosCommunicationNotification>(),
      ),
    )
    ..registerSingleton<ImplAndroidLocalNotificationsService>(
      ImplAndroidLocalNotificationsService(
        getIt<FlutterLocalNotificationsPlugin>(),
        getIt<LocalNotificationsDetailsFactory>(),
        getIt<LocalNotificationsServiceInitializer>(),
      ),
    )
    ..registerSingleton<ClipboardWrapper>(ClipboardWrapper())
    ..registerSingleton<ShareWrapper>(ShareWrapper())
    ..registerSingleton<SocialShareWrapper>(SocialShareWrapper())
    ..registerSingleton<ImplSharingService>(
      ImplSharingService(
        getIt<ClipboardWrapper>(),
        getIt<ShareWrapper>(),
        getIt<SocialShareWrapper>(),
      ),
    )
    ..registerSingleton<StoreCheckerService>(const StoreCheckerService())
    ..registerSingleton<ImplTarotLocalizationService>(
      ImplTarotLocalizationService(),
    )
    ..registerSingleton<ImplTarotRemoteDataSource>(
      ImplTarotRemoteDataSource(getIt<SupabaseClient>()),
    )
    ..registerSingleton<ImplTarotLocalizationRepository>(
      ImplTarotLocalizationRepository(getIt<ImplTarotLocalizationService>()),
    )
    ..registerSingleton<ImplTarotRepository>(
      ImplTarotRepository(getIt<ImplTarotRemoteDataSource>()),
    )
    ..registerSingleton<ITarotQuestionRepository>(ImplTarotQuestionRepository())
    // Setup application dependencies
    ..registerFactory<AuthCubit>(
      () => AuthCubit(
        getIt<ImplAuthService>(),
        getIt<ImplUserRepository>(),
        getIt<ImplAppTrackingService>(),
        getIt<StoreCheckerService>(),
      ),
    )
    ..registerFactory<AnalyticsCubit>(
      () => AnalyticsCubit(getIt<ImplAnalyticsService>()),
    )
    ..registerFactory<NetworkTimeProvider>(
      () => NetworkTimeProvider(getIt<NtpNetworkTimeService>()),
    )
    ..registerFactory<DeepLinkCubit>(
      () => DeepLinkCubit(getIt<ImplDeepLinkService>()),
    )
    ..registerFactory<ColorThemeBloc>(
      () => ColorThemeBloc(getIt<SharedPrefColorThemeCache>()),
    )
    ..registerFactory<NativePermissionBloc>(() {
      return NativePermissionBloc(
        getIt<NotificationPermissionService>(),
        getIt<GalleryPermissionService>(),
        getIt<CameraPermissionService>(),
        getIt<FakePermissionService>(),
      );
    })
    ..registerFactory<PurchasesBloc>(
      () => PurchasesBloc(getIt<RevenuecatPurchasesService>()),
    )
    ..registerFactory<RemoteNotificationTokenCubit>(
      () => RemoteNotificationTokenCubit(getIt<FirebaseNotificationsService>()),
    )
    ..registerFactory<RemoteNotificationCubit>(
      () => RemoteNotificationCubit(
        getIt<FirebaseNotificationsService>(),
        Platform.isIOS
            ? getIt<ImplIOSLocalNotificationsService>()
            : getIt<ImplAndroidLocalNotificationsService>(),
      ),
    )
    ..registerFactory<RegisterCubit>(
      () => RegisterCubit(getIt<ImplUserRepository>()),
    )
    ..registerFactory<TarotLocalizationCubit>(
      () => TarotLocalizationCubit(getIt<ImplTarotLocalizationRepository>()),
    )
    ..registerFactory<TarotQuestionBloc>(
      () => TarotQuestionBloc(getIt<ITarotQuestionRepository>()),
    )
    ..registerLazySingleton<TarotBloc>(
      () => TarotBloc(
        getIt<ImplTarotRepository>(),
        getIt<ImplTarotLocalizationRepository>(),
      ),
    );
}
