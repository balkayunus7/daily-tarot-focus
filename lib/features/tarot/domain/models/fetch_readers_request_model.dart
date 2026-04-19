import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef FetchReadersRequest = FetchReadersRequestModel;

class FetchReadersRequestModel {
  const FetchReadersRequestModel({required this.session});
  final AuthSession session;
}
