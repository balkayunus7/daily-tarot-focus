import 'package:mobile_boilerplate/domain/remote_notification/remote_notification.dart';

class RemoteNotificationDefault extends RemoteNotification {
  const RemoteNotificationDefault({
    required super.title,
    required super.body,
    required super.id,
  });

  factory RemoteNotificationDefault.fromMap(Map<String, dynamic> map) {
    return RemoteNotificationDefault(
      title: map['title'] as String,
      body: map['body'] as String,
      id: map['id'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {'title': title, 'body': body, 'id': id};
  }

  @override
  String get key => 'unknown';

  @override
  bool get showLocalNotification => true;

  @override
  String get type => 'unknown';
}
