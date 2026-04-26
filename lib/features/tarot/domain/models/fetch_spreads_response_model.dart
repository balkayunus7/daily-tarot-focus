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

  FetchSpreadsResponse copyWith({required KtList<TarotSpreadCategoryModel>? spreadCategories}) {
    return FetchSpreadsResponse(
      spreadCategories: spreadCategories ?? this.spreadCategories,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'spreads': spreads.asList().map((e) => e.toMap()).toList(),
    };
  }

  TarotSpreadCategoryModel copyWith({
    String? id,
    String? title,
    KtList<TarotSpreadModel>? spreads,
  }) {
    return TarotSpreadCategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      spreads: spreads ?? this.spreads,
    );
  }

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
    required this.categoryId,
    required this.positions,
  });

  factory TarotSpreadModel.fromMap(Map<String, dynamic> map) {
    return TarotSpreadModel(
      id: map['id'] != null ? map['id'] as String : '',
      title: map['title'] != null ? map['title'] as String : '',
      description: map['description'] != null ? map['description'] as String : '',
      cardCount: map['card_count'] != null ? map['card_count'] as int : 0,
      layoutType: map['layout_type'] != null ? map['layout_type'] as String : '',
      categoryId: map['category_id'] != null ? map['category_id'] as String : '',
      positions:
          (map['positions'] as List<dynamic>?)
              ?.map((e) => TarotSpreadPositionModel.fromMap(e as Map<String, dynamic>))
              .toImmutableList() ??
          const KtList<TarotSpreadPositionModel>.empty(),
    );
  }

  TarotSpreadModel copyWith({
    String? id,
    String? title,
    String? description,
    int? cardCount,
    String? layoutType,
    String? categoryId,
    KtList<TarotSpreadPositionModel>? positions,
  }) {
    return TarotSpreadModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cardCount: cardCount ?? this.cardCount,
      layoutType: layoutType ?? this.layoutType,
      categoryId: categoryId ?? this.categoryId,
      positions: positions ?? this.positions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'card_count': cardCount,
      'layout_type': layoutType,
      'category_id': categoryId,
      'positions': positions.asList().map((e) => e.toMap()).toList(),
    };
  }

  final String id;
  final String title;
  final String description;
  final int cardCount;
  final String layoutType;
  final String categoryId;
  final KtList<TarotSpreadPositionModel> positions;
}

class TarotSpreadPositionModel {
  const TarotSpreadPositionModel({
    required this.col,
    required this.row,
    required this.index,
    required this.title,
    required this.question,
  });

  factory TarotSpreadPositionModel.fromMap(Map<String, dynamic> map) {
    return TarotSpreadPositionModel(
      col: map['col'] as int,
      row: map['row'] as int,
      index: map['index'] as int,
      title: map['title'] as String,
      question: map['question'] as String,
    );
  }

  final int col;
  final int row;
  final int index;
  final String title;
  final String question;

  TarotSpreadPositionModel copyWith({
    int? col,
    int? row,
    int? index,
    String? title,
    String? question,
  }) {
    return TarotSpreadPositionModel(
      col: col ?? this.col,
      row: row ?? this.row,
      index: index ?? this.index,
      title: title ?? this.title,
      question: question ?? this.question,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'col': col,
      'row': row,
      'index': index,
      'title': title,
      'question': question,
    };
  }
}
