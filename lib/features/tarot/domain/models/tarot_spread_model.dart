class TarotSpreadCategoryModel {
  const TarotSpreadCategoryModel({
    required this.categoryId,
    required this.title,
    required this.spreads,
  });

  factory TarotSpreadCategoryModel.fromJson(Map<String, dynamic> json) {
    return TarotSpreadCategoryModel(
      categoryId: json['category_id'] as String,
      title: json['title'] as String,
      spreads:
          (json['spreads'] as List<dynamic>)
              .map((e) => TarotSpreadModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  final String categoryId;
  final String title;
  final List<TarotSpreadModel> spreads;
}

class TarotSpreadModel {
  const TarotSpreadModel({
    required this.id,
    required this.domain,
    required this.title,
    required this.description,
    required this.cardCount,
    required this.positions,
  });

  factory TarotSpreadModel.fromJson(Map<String, dynamic> json) {
    return TarotSpreadModel(
      id: json['id'] as String,
      domain: json['domain'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      cardCount: json['cardCount'] as int,
      positions:
          (json['positions'] as List<dynamic>)
              .map((e) => TarotSpreadPositionModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  final String id;
  final String domain;
  final String title;
  final String description;
  final int cardCount;
  final List<TarotSpreadPositionModel> positions;
}

class TarotSpreadPositionModel {
  const TarotSpreadPositionModel({
    required this.index,
    required this.title,
    required this.meaning,
  });

  factory TarotSpreadPositionModel.fromJson(Map<String, dynamic> json) {
    return TarotSpreadPositionModel(
      index: json['index'] as int,
      title: json['title'] as String,
      meaning: json['meaning'] as String,
    );
  }

  final int index;
  final String title;
  final String meaning;
}
