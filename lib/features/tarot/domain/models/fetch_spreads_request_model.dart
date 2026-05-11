import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef FetchSpreadsRequest = FetchSpreadsRequestModel;

class FetchSpreadsRequestModel {
  const FetchSpreadsRequestModel({required this.session, this.locale = 'en'});
  final AuthSession session;
  final String locale;
}
