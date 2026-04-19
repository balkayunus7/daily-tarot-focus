import 'package:mobile_boilerplate/common_dependencies.dart';

typedef FetchSpreadsResponse = FetchSpreadsResponseModel;

class FetchSpreadsResponseModel with EquatableMixin {
  const FetchSpreadsResponseModel({required this.spreadCategories});

  factory FetchSpreadsResponseModel.fromMap(Map<String, dynamic> map) {
    return FetchSpreadsResponseModel(
      spreadCategories: KtList.from(
        map.entries.map((e) => TarotSpreadCategoryModel.fromMap(e.value as Map<String, dynamic>)),
      ),
    );
  }

  final KtList<TarotSpreadCategoryModel> spreadCategories;

  @override
  List<Object?> get props => [spreadCategories];
}

//////// DATA MODEL //////////
class TarotSpreadCategoryModel {
  const TarotSpreadCategoryModel({
    required this.id,
    required this.title,
    required this.spreads,
  });

  factory TarotSpreadCategoryModel.fromMap(Map<String, dynamic> map) {
    return TarotSpreadCategoryModel(
      id: map['id'] as String,
      title: map['title'] as String,
      spreads:
          (map['spreads'] as List<dynamic>)
              .map((e) => TarotSpreadModel.fromMap(e as Map<String, dynamic>))
              .toImmutableList(),
    );
  }

  factory TarotSpreadCategoryModel.fromJson(Map<String, dynamic> json) =>
      TarotSpreadCategoryModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'spreads': spreads.asList().map((e) => e.toMap()).toList(),
    };
  }

  Map<String, dynamic> toJson() => toMap();

  final String id;
  final String title;
  final KtList<TarotSpreadModel> spreads;
}

class TarotSpreadModel {
  const TarotSpreadModel({
    required this.id,
    required this.title,
    required this.description,
    required this.cardCount,
    required this.layoutType,
    required this.positions,
  });

  factory TarotSpreadModel.fromMap(Map<String, dynamic> map) {
    return TarotSpreadModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      cardCount: map['card_count'] as int,
      layoutType: map['layout_type'] as String,
      positions:
          (map['positions'] as List<dynamic>)
              .map((e) => TarotSpreadPositionModel.fromMap(e as Map<String, dynamic>))
              .toImmutableList(),
    );
  }

  factory TarotSpreadModel.fromJson(Map<String, dynamic> json) => TarotSpreadModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'card_count': cardCount,
      'layout_type': layoutType,
      'positions': positions.asList().map((e) => e.toMap()).toList(),
    };
  }

  Map<String, dynamic> toJson() => toMap();

  final String id;
  final String title;
  final String description;
  final int cardCount;
  final String layoutType;
  final KtList<TarotSpreadPositionModel> positions;
}

class TarotSpreadPositionModel {
  const TarotSpreadPositionModel({
    required this.col,
    required this.row,
    required this.index,
    required this.title,
    required this.meaning,
  });

  factory TarotSpreadPositionModel.fromMap(Map<String, dynamic> map) {
    return TarotSpreadPositionModel(
      col: map['col'] as int,
      row: map['row'] as int,
      index: map['index'] as int,
      title: map['title'] as String,
      meaning: map['meaning'] as String,
    );
  }

  factory TarotSpreadPositionModel.fromJson(Map<String, dynamic> json) =>
      TarotSpreadPositionModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'col': col,
      'row': row,
      'index': index,
      'title': title,
      'meaning': meaning,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  final int col;
  final int row;
  final int index;
  final String title;
  final String meaning;
}
