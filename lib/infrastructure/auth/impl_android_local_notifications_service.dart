import 'dart:convert';

import 'package:mobile_boilerplate/domain/remote_notification/remote_notification.dart';
import 'package:mobile_boilerplate/infrastructure/remote_notification/local_notifications_index.dart';

class ImplAndroidLocalNotificationsService
    extends AndroidLocalNotificationsService {
  ImplAndroidLocalNotificationsService(
    super.localNotificationPlugin,
    super.detailsFactory,
    super.initializer,
  );

  @override
  String get channelName => 'Tarots_local_notifications';

  @override
  String jsonFromNotification(RemoteNotification notification) {
    return jsonEncode(notification.toMap());
  }

  @override
  RemoteNotification notificationFromJson(String jsonPayload) {
    throw UnimplementedError();
  }
}
