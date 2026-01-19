import 'package:mobile_boilerplate/domain/auth/auth_provider.dart';
import 'package:mobile_boilerplate/domain/auth/session.dart';

class TarotSession extends Session {
  const TarotSession({
    required super.userId,
    required super.idToken,
    required super.isNewUser,
    required super.provider,
  });
  factory TarotSession.fromMap(Map<String, dynamic> map) {
    return TarotSession(
      userId: map['id'] as String,
      idToken: map['session'] as String,
      isNewUser: map['is_new_user'] as bool,
      provider: AuthProvider.fromKey(map['provider'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'session': idToken,
      'is_new_user': isNewUser,
      'provider': provider.name,
    };
  }
}
