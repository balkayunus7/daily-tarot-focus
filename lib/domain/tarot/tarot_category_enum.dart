enum TarotCategory {
  majorArcana('Major Arcana'),
  cups('Cups'),
  wands('Wands'),
  swords('Swords'),
  pentacles('Pentacles');

  const TarotCategory(this.value);

  factory TarotCategory.fromString(String value) => TarotCategory.values.firstWhere((e) => e.value == value);

  final String value;
}
