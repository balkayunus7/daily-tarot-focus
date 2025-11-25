import 'package:daily_tarot_focus/features/auth/domain/entities/tarot_session.dart';
import 'package:mobile_boilerplate/domain/auth/auth_provider.dart';

class TarotSessionModel {
  final String id;
  final String session;
  final bool isNewUser;
  final String provider;

  const TarotSessionModel({
    required this.id,
    required this.session,
    required this.isNewUser,
    required this.provider,
  });

  factory TarotSessionModel.fromMap(Map<String, dynamic> map) {
    return TarotSessionModel(
      id: map['id'] as String,
      session: map['session'] as String,
      isNewUser: map['is_new_user'] as bool,
      provider: map['provider'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session': session,
      'is_new_user': isNewUser,
      'provider': provider,
    };
  }

  TarotSession toEntity() {
    return TarotSession(
      userId: id,
      idToken: session,
      isNewUser: isNewUser,
      provider: AuthProvider.fromKey(provider),
    );
  }

  factory TarotSessionModel.fromEntity(TarotSession entity) {
    return TarotSessionModel(
      id: entity.userId,
      session: entity.idToken,
      isNewUser: entity.isNewUser,
      provider: entity.provider.name,
    );
  }
}

