import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef DeleteReadingRequest = DeleteReadingRequestModel;

class DeleteReadingRequestModel {
  const DeleteReadingRequestModel({
    required this.session,
    required this.readingId,
  });

  Map<String, dynamic> toMap() => {'reading_id': readingId};

  final AuthSession session;
  final String readingId;
}
