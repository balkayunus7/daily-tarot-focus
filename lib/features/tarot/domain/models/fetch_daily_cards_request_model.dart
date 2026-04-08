import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef FetchDailyCardsRequest = FetchDailyCardsRequestModel;

class FetchDailyCardsRequestModel {
  const FetchDailyCardsRequestModel({required this.session, required this.languageCode});

  final AuthSession session;
  final String languageCode;
}
