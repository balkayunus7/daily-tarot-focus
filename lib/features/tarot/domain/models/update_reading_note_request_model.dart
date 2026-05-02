import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef UpdateReadingNoteRequest = UpdateReadingNoteRequestModel;

class UpdateReadingNoteRequestModel {
  const UpdateReadingNoteRequestModel({
    required this.session,
    required this.readingId,
    this.note,
  });

  Map<String, dynamic> toMap() => {
    'reading_id': readingId,
    'note': note,
  };

  final AuthSession session;
  final String readingId;
  final String? note;
}
