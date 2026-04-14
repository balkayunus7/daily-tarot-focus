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

const List<SpreadCategoryItem> mockSpreadCategories = [
  SpreadCategoryItem(
    categoryId: 'cat_3_cards',
    icon: TarotAppAssets.cardsThree,
    type: SpreadCategoryType.threeCards,
  ),
  SpreadCategoryItem(
    categoryId: 'cat_lunar_phases',
    icon: TarotAppAssets.moonStars,
    type: SpreadCategoryType.timeAndMoon,
  ),
  SpreadCategoryItem(
    categoryId: 'cat_love_relationships',
    icon: TarotAppAssets.heartHalf,
    type: SpreadCategoryType.loveAndRelationships,
  ),
  SpreadCategoryItem(
    categoryId: 'cat_finance',
    icon: TarotAppAssets.handCoins,
    type: SpreadCategoryType.finance,
  ),
  SpreadCategoryItem(
    categoryId: 'cat_career_work',
    icon: TarotAppAssets.chartLine,
    type: SpreadCategoryType.career,
  ),
  SpreadCategoryItem(
    categoryId: 'cat_health',
    icon: TarotAppAssets.asclepius,
    type: SpreadCategoryType.health,
  ),
  SpreadCategoryItem(
    categoryId: 'cat_family_motherhood',
    icon: TarotAppAssets.babyIcon,
    type: SpreadCategoryType.familyAndMaternity,
  ),
];
