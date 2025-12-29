import 'dart:convert';

import 'package:daily_tarot_focus/domain/auth/remote_notification_message.dart';
import 'package:mobile_boilerplate/domain/remote_notification/remote_notification.dart';
import 'package:mobile_boilerplate/infrastructure/remote_notification/local_notifications_index.dart';

class ImplIOSLocalNotificationsService extends IOSLocalNotificationsService {
  ImplIOSLocalNotificationsService(
    super.localNotificationPlugin,
    super.detailsFactory,
    super.initializer,
    super._iosCommNotification,
  );

  @override
  String get channelName => 'Tarots_local_notifications';

  @override
  String jsonFromNotification(RemoteNotification notification) {
    return jsonEncode(notification.toMap());
  }

  @override
  RemoteNotification notificationFromJson(String jsonPayload) {
    final map = jsonDecode(jsonPayload) as Map<String, dynamic>;
    final type = map['type'] as String;
    final id = map['id'] as String;
    final body = map['body'] as String;
    final title = map['title'] as String;

    switch (type) {
      default:
        return RemoteNotificationDefault(id: id, body: body, title: title);
    }
  }
}
