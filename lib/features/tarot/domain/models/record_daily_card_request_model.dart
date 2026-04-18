import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef RecordDailyCardRequest = RecordDailyCardRequestModel;

class RecordDailyCardRequestModel {
  const RecordDailyCardRequestModel({
    required this.session,
    required this.cardId,
  });

  final AuthSession session;
  final String cardId;
}
