import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef RecordDailyCardRequest = RecordDailyCardRequestModel;

class RecordDailyCardRequestModel {
  const RecordDailyCardRequestModel({
    required this.session,
    required this.cardId,
    required this.languageCode,
  });

  final AuthSession session;
  final String cardId;
  final String languageCode;
}
