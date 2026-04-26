import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';

enum SpreadCategoryType {
  threeCards,
  timeAndMoon,
  loveAndRelationships,
  finance,
  career,
  health,
  familyAndMaternity,
}

class SpreadCategoryItem {
  const SpreadCategoryItem({
    required this.categoryId,
    required this.icon,
    required this.type,
  });
  final String categoryId;
  final TarotAppAssets icon;
  final SpreadCategoryType type;
}
