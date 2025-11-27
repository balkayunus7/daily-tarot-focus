enum ZodiacSign {
  aries('Aries'),
  taurus('Taurus'),
  gemini('Gemini'),
  cancer('Cancer'),
  leo('Leo'),
  virgo('Virgo'),
  libra('Libra'),
  scorpio('Scorpio'),
  sagittarius('Sagittarius'),
  capricorn('Capricorn'),
  aquarius('Aquarius'),
  pisces('Pisces');

  const ZodiacSign(this.value);
  factory ZodiacSign.fromString(String value) =>
      ZodiacSign.values.firstWhere((e) => e.value == value);
      
  final String value;
}
