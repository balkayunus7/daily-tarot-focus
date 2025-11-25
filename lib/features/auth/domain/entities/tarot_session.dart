import 'package:mobile_boilerplate/domain/auth/session.dart';

class TarotSession extends Session {
  const TarotSession({
    required super.userId,
    required super.idToken,
    required super.isNewUser,
    required super.provider,
  });
}
