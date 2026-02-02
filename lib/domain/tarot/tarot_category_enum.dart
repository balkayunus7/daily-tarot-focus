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

  final String value;
}
