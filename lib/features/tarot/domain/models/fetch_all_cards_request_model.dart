import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef FetchAllCardsRequest = FetchAllCardsRequestModel;

class FetchAllCardsRequestModel {
  const FetchAllCardsRequestModel({required this.session});
  final AuthSession session;
}
