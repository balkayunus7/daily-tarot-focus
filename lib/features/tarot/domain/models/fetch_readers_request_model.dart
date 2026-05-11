import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef FetchReadersRequest = FetchReadersRequestModel;

class FetchReadersRequestModel {
  const FetchReadersRequestModel({required this.session, this.locale = 'en'});
  final AuthSession session;
  final String locale;
}
