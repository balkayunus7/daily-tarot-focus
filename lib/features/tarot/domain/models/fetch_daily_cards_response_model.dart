import 'package:mobile_boilerplate/common_dependencies.dart';

class FetchDailyCardsResponseModel with EquatableMixin {
  const FetchDailyCardsResponseModel({
    required this.records,
  });

  factory FetchDailyCardsResponseModel.fromList(List<dynamic> list) {
    return FetchDailyCardsResponseModel(
      records: KtList.from(
        list.map((item) => DailyCardModel.fromMap(item as Map<String, dynamic>)),
      ),
    );
  }

  final KtList<DailyCardModel> records;

  List<Map<String, dynamic>> toMap() {
    return records.asList().map((record) => record.toMap()).toList();
  }

  FetchDailyCardsResponseModel copyWith({
    KtList<DailyCardModel>? records,
  }) {
    return FetchDailyCardsResponseModel(
      records: records ?? this.records,
    );
  }

  @override
  List<Object?> get props => [records];
}

typedef FetchDailyCardsResponse = FetchDailyCardsResponseModel;

class DailyCardModel with EquatableMixin {
  const DailyCardModel({
    required this.cardId,
    required this.date,
  });

  factory DailyCardModel.fromMap(Map<String, dynamic> map) {
    return DailyCardModel(
      cardId: map['card_id'] as String,
      date: DateTime.parse(map['created_at'] as String),
    );
  }

  final String cardId;
  final DateTime date;

  Map<String, dynamic> toMap() {
    return {
      'card_id': cardId,
      'created_at': date.toIso8601String(),
    };
  }

  DailyCardModel copyWith({
    String? cardId,
    DateTime? date,
  }) {
    return DailyCardModel(
      cardId: cardId ?? this.cardId,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [cardId, date];
}
