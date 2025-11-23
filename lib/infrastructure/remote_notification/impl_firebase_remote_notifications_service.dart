import 'package:daily_tarot_focus/domain/remote_notification/remote_notification_message.dart';
import 'package:mobile_core/domain/remote_notification/remote_notification.dart';
import 'package:mobile_core/infrastructure/remote_notification/firebase_notifications_service.dart';
import 'package:mobile_core/infrastructure_dependencies.dart' as fm;

class ImplFirebaseRemoteNotificationsService
    extends FirebaseNotificationsService {
  ImplFirebaseRemoteNotificationsService(
    super.firebaseMessaging,
    super.firebaseMessagingOnNotification,
    super.firebaseMessagingOnNotificationOpenedApp,
  );

  @override
  RemoteNotification fromRemoteMessage(fm.RemoteMessage message) {
    final type = message.data['type'];
    final id = message.messageId ?? '';
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';

    switch (type) {
      default:
        return RemoteNotificationDefault(
          id: id,
          body: body,
          title: title,
        );
    }
  }

  @override
  bool isNotificationsEqual(fm.RemoteMessage a, fm.RemoteMessage b) {
    return a.messageId == b.messageId;
  }
}
