import 'package:daily_tarot_focus/features/tarot/domain/models/generate_daily_pick_response_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

typedef FetchDailyCardsResponse = FetchDailyCardsResponseModel;

class FetchDailyCardsResponseModel with EquatableMixin {
  const FetchDailyCardsResponseModel({required this.records});

  factory FetchDailyCardsResponseModel.fromMap(Map<String, dynamic> map) {
    final rawRecords = map['records'];
    if (rawRecords is List<dynamic>) {
      return FetchDailyCardsResponseModel(
        records: KtList.from(
          rawRecords.map(
            (e) => DailyCardModel.fromMap(e as Map<String, dynamic>),
          ),
        ),
      );
    }

    return FetchDailyCardsResponseModel(
      records: KtList.from(
        map.entries.map(
          (e) => DailyCardModel.fromMap(e.value as Map<String, dynamic>),
        ),
      ),
    );
  }

  final KtList<DailyCardModel> records;

  List<Map<String, dynamic>> toMap() {
    return records.asList().map((record) => record.toMap()).toList();
  }

  FetchDailyCardsResponseModel copyWith({KtList<DailyCardModel>? records}) {
    return FetchDailyCardsResponseModel(
      records: records ?? this.records,
    );
  }

  @override
  List<Object?> get props => [records];
}

//////// DATA MODEL //////////
class DailyCardModel with EquatableMixin {
  const DailyCardModel({
    required this.cardId,
    required this.date,
    this.isReversed = false,
    this.dailyAdvice,
    this.categories = const [],
    this.locale,
  });

  factory DailyCardModel.fromMap(Map<String, dynamic> map) {
    return DailyCardModel(
      cardId: map['card_id'] as String,
      date: DateTime.parse(map['created_at'] as String),
      isReversed: map['is_reversed'] as bool? ?? false,
      dailyAdvice: map['daily_advice'] as String?,
      categories:
          (map['categories'] as List<dynamic>?)
              ?.map(
                (e) => DailyPickCategoryInsight.fromSavedMap(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      locale: map['locale'] as String?,
    );
  }

  final String cardId;
  final DateTime date;
  final bool isReversed;
  final String? dailyAdvice;
  final List<DailyPickCategoryInsight> categories;
  final String? locale;

  Map<String, dynamic> toMap() {
    return {
      'card_id': cardId,
      'created_at': date.toIso8601String(),
      'is_reversed': isReversed,
      if (dailyAdvice != null) 'daily_advice': dailyAdvice,
      'categories':
          categories
              .map(
                (category) => {
                  'label_key': category.labelKey,
                  'description': category.description,
                },
              )
              .toList(),
      if (locale != null) 'locale': locale,
    };
  }

  DailyCardModel copyWith({
    String? cardId,
    DateTime? date,
    bool? isReversed,
    String? dailyAdvice,
    List<DailyPickCategoryInsight>? categories,
    String? locale,
  }) {
    return DailyCardModel(
      cardId: cardId ?? this.cardId,
      date: date ?? this.date,
      isReversed: isReversed ?? this.isReversed,
      dailyAdvice: dailyAdvice ?? this.dailyAdvice,
      categories: categories ?? this.categories,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [
    cardId,
    date,
    isReversed,
    dailyAdvice,
    categories,
    locale,
  ];
}
