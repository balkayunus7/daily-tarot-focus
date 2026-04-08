import 'package:mobile_boilerplate/common_dependencies.dart';

class RecordDailyCardResponseModel with EquatableMixin {
  const RecordDailyCardResponseModel();

  factory RecordDailyCardResponseModel.fromMap() {
    return const RecordDailyCardResponseModel();
  }

  @override
  List<Object?> get props => [];
}

typedef RecordDailyCardResponse = RecordDailyCardResponseModel;
