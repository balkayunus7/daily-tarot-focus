import 'dart:io';

import 'package:daily_tarot_focus/config/app_config.dart';
import 'package:daily_tarot_focus/infrastructure/auth/impl_auth_service.dart';
import 'package:daily_tarot_focus/infrastructure/auth/impl_user_repository.dart';
import 'package:daily_tarot_focus/infrastructure/remote_notification/impl_android_local_notifications_service.dart';
import 'package:daily_tarot_focus/infrastructure/remote_notification/impl_firebase_remote_notifications_service.dart';
import 'package:daily_tarot_focus/infrastructure/remote_notification/impl_ios_local_notifications_service.dart';
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
import 'package:mobile_boilerplate/wrapper/flutter_app_badger_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/ntp_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/purchases_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/share_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/sign_in_with_apple_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/social_share_wrapper.dart';
import 'package:mobile_boilerplate/wrapper/url_launcher_wrapper.dart';
import 'package:supabase/supabase.dart';
import 'package:daily_tarot_focus/config/env.config.dart';

Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final envConfig = EnvConfig();
  getIt.registerSingleton<SupabaseClient>(
    SupabaseClient(envConfig.supabaseUrl, envConfig.supabaseAnonKey),
  );

  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<Uuid>(Uuid());
  getIt.registerSingleton<NtpWrapper>(NtpWrapper());
  getIt.registerSingleton<AppLinks>(AppLinks());
  getIt.registerSingleton<DeviceInfoPlugin>(DeviceInfoPlugin());
  getIt.registerSingleton<PackageInfo>(await PackageInfo.fromPlatform());
  getIt.registerSingleton<PurchasesWrapper>(PurchasesWrapper());
  getIt.registerSingleton<HttpFailureHandler>(HttpFailureHandler());
  getIt.registerSingleton<GoogleSignIn>(GoogleSignIn());
  getIt.registerSingleton<SignInWithAppleWrapper>(SignInWithAppleWrapper());
  getIt.registerSingleton<UrlLauncherWrapper>(UrlLauncherWrapper());
  getIt.registerSingleton<AppSettingsWrapper>(AppSettingsWrapper());

  // Setup infrastructure dependencies
  getIt.registerSingleton<ImplLauncherService>(
    ImplLauncherService(
      getIt<UrlLauncherWrapper>(),
      getIt<AppSettingsWrapper>(),
    ),
  );

  getIt.registerSingleton<ImplAuthService>(
    ImplAuthService(
      getIt<SupabaseClient>(),
      getIt<SharedPreferences>(),
      getIt<HttpFailureHandler>(),
    ),
  );

  getIt.registerSingleton<ImplUserRepository>(
    ImplUserRepository(getIt<SupabaseClient>(), getIt<HttpFailureHandler>()),
  );
  getIt.registerSingleton<NtpNetworkTimeService>(
    NtpNetworkTimeService(getIt<SharedPreferences>(), getIt<NtpWrapper>()),
  );
  getIt.registerSingleton<SharedPrefColorThemeCache>(
    SharedPrefColorThemeCache(getIt<SharedPreferences>()),
  );

  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(
    FlutterLocalNotificationsPlugin(),
  );
  getIt.registerSingleton<FlutterAppBadgerWrapper>(FlutterAppBadgerWrapper());
  getIt.registerSingleton<LocalNotificationsDetailsFactory>(
    LocalNotificationsDetailsFactory(),
  );
  getIt.registerSingleton<LocalNotificationsServiceInitializer>(
    LocalNotificationsServiceInitializer(),
  );
  getIt.registerSingleton<IosCommunicationNotification>(
    IosCommunicationNotification(),
  );

  getIt.registerSingleton<ImplAppTrackingService>(
    ImplAppTrackingService(),
  );

  getIt.registerSingleton<ImplAnalyticsService>(
    const ImplAnalyticsService(),
  );

  // Setup permission dependencies
  getIt.registerSingleton<RevenuecatPurchasesService>(
    RevenuecatPurchasesService(getIt<PurchasesWrapper>()),
  );
  getIt.registerSingleton<MicrophonePermissionService>(
    MicrophonePermissionService(Permission.microphone),
  );

  getIt.registerSingleton<NotificationPermissionService>(
    NotificationPermissionService(Permission.notification),
  );

  getIt.registerSingleton<CameraPermissionService>(
    CameraPermissionService(Permission.camera),
  );

  getIt.registerSingleton<GalleryPermissionService>(
    GalleryPermissionService(Permission.photos),
  );

  getIt.registerSingleton<FakePermissionService>(FakePermissionService());

  getIt.registerFactory<FirebaseNotificationsService>(
    () => ImplFirebaseRemoteNotificationsService(
      FirebaseMessaging.instance,
      FirebaseMessaging.onMessage,
      FirebaseMessaging.onMessageOpenedApp,
    ),
  );

  getIt.registerSingleton<Launcher>(Launcher(getIt<ImplLauncherService>()));
  getIt.registerSingleton<LyricsAppConfig>(LyricsAppConfig());
  getIt.registerSingleton<ImplIOSLocalNotificationsService>(
    ImplIOSLocalNotificationsService(
      getIt<FlutterLocalNotificationsPlugin>(),
      getIt<FlutterAppBadgerWrapper>(),
      getIt<LocalNotificationsDetailsFactory>(),
      getIt<LocalNotificationsServiceInitializer>(),
      getIt<IosCommunicationNotification>(),
    ),
  );
  getIt.registerSingleton<ImplAndroidLocalNotificationsService>(
    ImplAndroidLocalNotificationsService(
      getIt<FlutterLocalNotificationsPlugin>(),
      getIt<FlutterAppBadgerWrapper>(),
      getIt<LocalNotificationsDetailsFactory>(),
      getIt<LocalNotificationsServiceInitializer>(),
    ),
  );

  getIt.registerSingleton<ClipboardWrapper>(ClipboardWrapper());
  getIt.registerSingleton<ShareWrapper>(ShareWrapper());
  getIt.registerSingleton<SocialShareWrapper>(SocialShareWrapper());

  getIt.registerSingleton<ImplSharingService>(
    ImplSharingService(
      getIt<ClipboardWrapper>(),
      getIt<ShareWrapper>(),
      getIt<SocialShareWrapper>(),
    ),
  );
  getIt.registerSingleton<StoreCheckerService>(StoreCheckerService());

  // Setup application dependencies
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      getIt<ImplAuthService>(),
      getIt<ImplUserRepository>(),
      getIt<ImplAppTrackingService>(),
      getIt<StoreCheckerService>(),
    ),
  );

  getIt.registerFactory<AnalyticsCubit>(
    () => AnalyticsCubit(getIt<ImplAnalyticsService>()),
  );
  getIt.registerFactory<NetworkTimeProvider>(
    () => NetworkTimeProvider(getIt<NtpNetworkTimeService>()),
  );
  getIt.registerFactory<DeepLinkCubit>(
    () => DeepLinkCubit(getIt<ImplDeepLinkService>()),
  );

  getIt.registerFactory<ColorThemeBloc>(
    () => ColorThemeBloc(getIt<SharedPrefColorThemeCache>()),
  );

  getIt.registerFactory<NativePermissionBloc>(() {
    return NativePermissionBloc(
      getIt<NotificationPermissionService>(),
      getIt<GalleryPermissionService>(),
      getIt<CameraPermissionService>(),
      getIt<FakePermissionService>(),
    );
  });

  getIt.registerFactory<PurchasesBloc>(
    () => PurchasesBloc(getIt<RevenuecatPurchasesService>()),
  );

  getIt.registerFactory<RemoteNotificationTokenCubit>(
    () => RemoteNotificationTokenCubit(getIt<FirebaseNotificationsService>()),
  );

  getIt.registerFactory<RemoteNotificationCubit>(
    () => RemoteNotificationCubit(
      getIt<FirebaseNotificationsService>(),
      Platform.isIOS
          ? getIt<ImplIOSLocalNotificationsService>()
          : getIt<ImplAndroidLocalNotificationsService>(),
    ),
  );
}
