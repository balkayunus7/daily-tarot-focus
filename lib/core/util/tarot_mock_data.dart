import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

/// Utility class for tarot-related mock data and constants.
/// Note: Actual tarot card data is now loaded from JSON files via TarotCardService.
class TarotMockData {
  static List<Map<String, String>> get navbarItems => [
    {'path': TarotAppAssets.explore.path, 'label': LocaleKeys.navbar_explore.tr()},
    {'path': TarotAppAssets.tarotIcon.path, 'label': LocaleKeys.navbar_readings.tr()},
    {'path': TarotAppAssets.settings.path, 'label': LocaleKeys.navbar_profile.tr()},
  ];

  static const String dailyTarotCardHeroTag = 'daily_tarot_card_hero';
}
