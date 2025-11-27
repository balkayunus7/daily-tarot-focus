import 'package:daily_tarot_focus/features/auth/domain/entities/remote_notification_message.dart';
import 'package:mobile_boilerplate/domain/remote_notification/remote_notification.dart';
import 'package:mobile_boilerplate/infrastructure/remote_notification/firebase_notifications_service.dart';
import 'package:mobile_boilerplate/infrastructure_dependencies.dart' as fm;

class ImplFirebaseRemoteNotificationsService
    extends FirebaseNotificationsService {
  ImplFirebaseRemoteNotificationsService(
    super._firebaseMessaging,
    super._firebaseMessagingOnNotification,
    super._firebaseMessagingOnNotificationOpenedApp,
  );

  @override
  RemoteNotification fromRemoteMessage(fm.RemoteMessage message) {
    final id = message.messageId ?? '';
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';

    return RemoteNotificationDefault(
      id: id,
      body: body,
      title: title,
    );
  }

  @override
  bool isNotificationsEqual(fm.RemoteMessage a, fm.RemoteMessage b) {
    return a.messageId == b.messageId;
  }
}
