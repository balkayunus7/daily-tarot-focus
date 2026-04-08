import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

enum TarotCategory {
  majorArcana('Major Arcana'),
  cups('Cups'),
  wands('Wands'),
  swords('Swords'),
  pentacles('Pentacles');

  const TarotCategory(this.value);

  /// Creates a TarotCategory from a string.
  /// Accepts both enum names (e.g., 'majorArcana') and display values (e.g., 'Major Arcana')
  factory TarotCategory.fromString(String value) => TarotCategory.values.firstWhere(
    (e) => e.value == value || e.name == value,
    orElse: () => TarotCategory.majorArcana,
  );

  String get localizedName {
    switch (this) {
      case TarotCategory.majorArcana:
        return LocaleKeys.tarot_category_major_arcana.tr();
      case TarotCategory.cups:
        return LocaleKeys.tarot_category_cups.tr();
      case TarotCategory.wands:
        return LocaleKeys.tarot_category_wands.tr();
      case TarotCategory.swords:
        return LocaleKeys.tarot_category_swords.tr();
      case TarotCategory.pentacles:
        return LocaleKeys.tarot_category_pentacles.tr();
    }
  }

  final String value;
}
