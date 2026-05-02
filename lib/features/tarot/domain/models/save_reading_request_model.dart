import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef SaveReadingRequest = SaveReadingRequestModel;

class SaveReadingRequestModel {
  const SaveReadingRequestModel({
    required this.session,
    required this.readingId,
    this.note,
  });

  final AuthSession session;
  final String readingId;
  final String? note;
}
