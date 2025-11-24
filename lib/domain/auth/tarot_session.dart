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
      userId: map['id'],
      idToken: map['session'],
      isNewUser: map['is_new_user'],
      provider: AuthProvider.fromKey(map['provider']),
    );
  }

  @override
  TarotSession copyWith({bool? isNewUser}) {
    return TarotSession(
      userId: userId,
      idToken: idToken,
      isNewUser: isNewUser ?? this.isNewUser,
      provider: provider,
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

  @override
  Map<String, String> get headers => {
    'user-id': userId,
    'user-session': idToken,
    'content-type': 'application/json; charset=utf-8',
  };
}
