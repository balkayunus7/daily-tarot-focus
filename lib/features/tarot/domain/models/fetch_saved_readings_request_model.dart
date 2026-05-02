import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef FetchSavedReadingsRequest = FetchSavedReadingsRequestModel;

class FetchSavedReadingsRequestModel {
  const FetchSavedReadingsRequestModel({required this.session});
  final AuthSession session;
}
