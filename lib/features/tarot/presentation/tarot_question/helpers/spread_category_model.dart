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
    required this.title,
    required this.icon,
    required this.type,
  });
  final String title;
  final TarotAppAssets icon;
  final SpreadCategoryType type;
}

const List<SpreadCategoryItem> mockSpreadCategories = [
  SpreadCategoryItem(
    title: '3 Kart Açılımları',
    icon: TarotAppAssets.cardsThree,
    type: SpreadCategoryType.threeCards,
  ),
  SpreadCategoryItem(
    title: 'Hafta, Ay ve Ay Evreleri',
    icon: TarotAppAssets.moonStars,
    type: SpreadCategoryType.timeAndMoon,
  ),
  SpreadCategoryItem(
    title: 'Aşk & İlişkiler',
    icon: TarotAppAssets.heartHalf,
    type: SpreadCategoryType.loveAndRelationships,
  ),
  SpreadCategoryItem(
    title: 'Finans',
    icon: TarotAppAssets.handCoins,
    type: SpreadCategoryType.finance,
  ),
  SpreadCategoryItem(
    title: 'Kariyer & İş',
    icon: TarotAppAssets.chartLine,
    type: SpreadCategoryType.career,
  ),
  SpreadCategoryItem(
    title: 'Sağlık',
    icon: TarotAppAssets.asclepius,
    type: SpreadCategoryType.health,
  ),
  SpreadCategoryItem(
    title: 'Çocuk, Hamilelik & Annelik',
    icon: TarotAppAssets.babyIcon,
    type: SpreadCategoryType.familyAndMaternity,
  ),
];
