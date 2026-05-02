import 'package:mobile_boilerplate/common_dependencies.dart';

typedef SaveReadingResponse = SaveReadingResponseModel;

class SaveReadingResponseModel with EquatableMixin {
  const SaveReadingResponseModel({required this.id});

  factory SaveReadingResponseModel.fromMap(Map<String, dynamic> map) {
    return SaveReadingResponseModel(id: map['id'] as String? ?? '');
  }

  final String id;

  @override
  List<Object?> get props => [id];
}
