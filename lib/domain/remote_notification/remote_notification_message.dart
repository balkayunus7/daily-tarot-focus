import 'package:mobile_core/domain/remote_notification/remote_notification.dart';

class RemoteNotificationDefault extends RemoteNotification {
  const RemoteNotificationDefault({
    required super.title,
    required super.body,
    required super.id,
  });

  @override
  String get key => 'unknown';

  @override
  bool get showLocalNotification => true;

  @override
  String get type => 'unknown';
}
