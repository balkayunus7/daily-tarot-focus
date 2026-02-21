import 'package:mobile_boilerplate/common_dependencies.dart';

class DailyTarotRecord with EquatableMixin {
  const DailyTarotRecord({
    required this.cardId,
    required this.date,
  });

  factory DailyTarotRecord.fromMap(Map<String, dynamic> map) {
    return DailyTarotRecord(
      cardId: map['card_id'] as String,
      date: DateTime.parse(map['created_at'] as String),
    );
  }

  final String cardId;
  final DateTime date;

  @override
  List<Object?> get props => [cardId, date];
}
