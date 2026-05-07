import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:flutter/material.dart';

enum CompatGender {
  female('Female'),
  male('Male'),
  nonBinary('Non Binary');

  const CompatGender(this.value);

  factory CompatGender.fromString(String value) =>
      CompatGender.values.firstWhere((e) => e.value == value);

  String get emoji {
    return switch (this) {
      CompatGender.female => TarotAppAssets.female.path,
      CompatGender.male => TarotAppAssets.male.path,
      CompatGender.nonBinary => TarotAppAssets.nonBinary.path,
    };
  }

  final String value;

  bool get isFemale => this == CompatGender.female;
  bool get isMale => this == CompatGender.male;
  bool get isNonBinary => this == CompatGender.nonBinary;
}

class CompatibilityInputModel {
  const CompatibilityInputModel({
    required this.mySign,
    required this.myGender,
    required this.partnerSign,
    required this.partnerGender,
  });

  final ZodiacSign mySign;
  final CompatGender myGender;
  final ZodiacSign partnerSign;
  final CompatGender partnerGender;
}

class CompatibilityCategoryModel {
  const CompatibilityCategoryModel({
    required this.emoji,
    required this.labelKey,
    required this.score,
    required this.barColor,
    required this.description,
  });

  final String emoji;
  final String labelKey;
  final int score;
  final Color barColor;
  final String description;
}

class CompatibilityResult {
  const CompatibilityResult({
    required this.mySign,
    required this.partnerSign,
    required this.overallScore,
    required this.summary,
    required this.categories,
  });
  factory CompatibilityResult.calculate(ZodiacSign a, ZodiacSign b) {
    final bases = _elementBase(a.element, b.element);
    final mods = _modalityMod(a.modality, b.modality);
    final jit = _jitter(a, b);

    final raw = List.generate(5, (i) => (bases[i] + mods[i] + jit[i]).clamp(0, 100));
    final overall = (raw.reduce((x, y) => x + y) / 5).round();

    return CompatibilityResult(
      mySign: a,
      partnerSign: b,
      overallScore: overall,
      summary: _summary(a, b),
      categories: [
        CompatibilityCategoryModel(
          emoji: '⚡',
          labelKey: 'compat_page.category_sexuality',
          score: raw[0],
          barColor: const Color(0xFFE05A5A),
          description: _catDesc(raw[0], _sexDesc),
        ),
        CompatibilityCategoryModel(
          emoji: '🛡',
          labelKey: 'compat_page.category_trust',
          score: raw[1],
          barColor: const Color(0xFF5A82E0),
          description: _catDesc(raw[1], _trustDesc),
        ),
        CompatibilityCategoryModel(
          emoji: '💬',
          labelKey: 'compat_page.category_communication',
          score: raw[2],
          barColor: const Color(0xFF9B5AE0),
          description: _catDesc(raw[2], _commDesc),
        ),
        CompatibilityCategoryModel(
          emoji: '🔥',
          labelKey: 'compat_page.category_emotions',
          score: raw[3],
          barColor: const Color(0xFFE08A3A),
          description: _catDesc(raw[3], _emotDesc),
        ),
        CompatibilityCategoryModel(
          emoji: '🌱',
          labelKey: 'compat_page.category_values',
          score: raw[4],
          barColor: const Color(0xFF4CAF82),
          description: _catDesc(raw[4], _valDesc),
        ),
      ],
    );
  }

  final ZodiacSign mySign;
  final ZodiacSign partnerSign;
  final int overallScore;
  final String summary;
  final List<CompatibilityCategoryModel> categories;

  String get titleKey {
    if (overallScore >= 78) return 'compat_page.title_high';
    if (overallScore >= 62) return 'compat_page.title_medium';
    if (overallScore >= 45) return 'compat_page.title_low';
    return 'compat_page.title_very_low';
  }

  static List<int> _elementBase(ZodiacElement a, ZodiacElement b) {
    if (a == b) {
      return switch (a) {
        ZodiacElement.fire => [88, 62, 82, 80, 68],
        ZodiacElement.earth => [72, 90, 68, 72, 88],
        ZodiacElement.air => [68, 64, 94, 62, 72],
        ZodiacElement.water => [82, 72, 58, 94, 76],
      };
    }
    final idx = [a.index, b.index]..sort();
    return switch ('${idx[0]}-${idx[1]}') {
      '0-1' => [68, 76, 56, 52, 66],
      '0-2' => [86, 64, 90, 68, 70],
      '0-3' => [76, 48, 46, 78, 54],
      '1-2' => [52, 70, 82, 56, 62],
      '1-3' => [78, 82, 64, 88, 80],
      _ => [66, 60, 72, 74, 64],
    };
  }

  static List<int> _modalityMod(ZodiacModality a, ZodiacModality b) {
    if (a == b) {
      return switch (a) {
        ZodiacModality.cardinal => [3, -5, 0, 0, 0],
        ZodiacModality.fixed => [0, 5, -3, 0, 0],
        ZodiacModality.mutable => [0, 0, 5, 0, -3],
      };
    }
    final idx = [a.index, b.index]..sort();
    return switch ('${idx[0]}-${idx[1]}') {
      '0-1' => [0, 5, 0, 0, 0],
      '0-2' => [0, 0, 5, 0, 0],
      _ => [0, 0, 0, 5, 0],
    };
  }

  static List<int> _jitter(ZodiacSign a, ZodiacSign b) {
    final s = (a.index * 13 + b.index * 7) % 13;
    return [s * 3 % 13 - 6, s * 5 % 11 - 5, s * 7 % 13 - 6, s * 11 % 11 - 5, s * 9 % 13 - 6];
  }

  static String _catDesc(int score, List<String> t) =>
      score >= 75
          ? t[0]
          : score >= 50
          ? t[1]
          : t[2];

  static String _summary(ZodiacSign a, ZodiacSign b) {
    if (a.element == b.element) {
      return switch (a.element) {
        ZodiacElement.fire => _fireFire,
        ZodiacElement.earth => _earthEarth,
        ZodiacElement.air => _airAir,
        ZodiacElement.water => _waterWater,
      };
    }
    final idx = [a.element.index, b.element.index]..sort();
    return switch ('${idx[0]}-${idx[1]}') {
      '0-1' => _fireEarth,
      '0-2' => _fireAir,
      '0-3' => _fireWater,
      '1-2' => _earthAir,
      '1-3' => _earthWater,
      _ => _airWater,
    };
  }

  static const _fireFire =
      "When two Fire signs come together, it creates a passionate and dynamic union. You easily understand each other because you share the same inner energy. This relationship hosts exciting, creative, and adventurous moments. Although egos may clash at times, this strong bond that feeds each other's fire rarely burns out.";
  static const _earthEarth =
      'When two Earth signs come together, it lays the groundwork for a reliable and long-lasting relationship. Your practical approaches and search for security bring you to a common ground. This partnership offers a patient, nurturing bond that deepens over time. Learning to trust each other only becomes easier with time.';
  static const _airAir =
      'When two Air signs come together, a relationship emerges where ideas and intellectual curiosity dance endlessly. You can talk, debate, and discover new perspectives with each other for hours. This union prioritizes freedom and mutual respect. Although emotional connection may sometimes require more effort, the shared mental harmony is unique.';
  static const _waterWater =
      "The union of two Water signs is the product of deep emotional understanding and an intuitive bond. You expect to be understood without words, and this often happens. This relationship is built on compassion, empathy, and spiritual integration. Your sensitivity may occasionally lead to conflict, but your emotional depth becomes each other's sanctuary.";
  static const _fireEarth =
      'When the passion of Fire meets the calmness of Earth, a unique relationship balanced by opposing energies emerges. Fire excites Earth, while Earth provides stability to Fire. If this balance can be managed, the two form a strong, complementary union. Although different paces and priorities may sometimes challenge harmony, understanding overcomes everything.';
  static const _fireAir =
      "When Fire's inspiring energy meets Air's intellect, a vibrant bond that pushes boundaries is born. You nurture, encourage, and motivate each other. Deep conversations and spontaneous adventures form the essence of this relationship. Although emotional rootedness may sometimes feel lacking, the shared passion bridges this gap.";
  static const _fireWater =
      'The encounter between Fire and Water signifies a relationship where strong attraction and deep differences intertwine. You both fascinate and challenge each other. While Fire gives clarity and courage to Water, Water seeks to add emotional depth to Fire. If you can manage this contrast with understanding, you can create a transformative union.';
  static const _earthAir =
      "The practical world of Earth and the intellectual flight of Air offer a different but complementary harmony. While Air enriches Earth with new ideas, Earth provides grounding and security to Air. Patience and compromise are highly important in this relationship. Each of your strengths offers an opportunity to fill the other's gaps.";
  static const _earthWater =
      "The union of Earth and Water forms one of astrology's most nurturing and enduring bonds. Earth provides direction and stability to Water, while Water adds emotional depth and intuition to Earth. This relationship is built on trust, loyalty, and a mature understanding of love. As you spend time together, your bond strengthens and takes root.";
  static const _airWater =
      'The rational world of Air and the emotional depth of Water create a fascinating but sometimes challenging balance. You have much to learn from each other: Air offers clarity and perspective to Water, while Water teaches empathy and inner intuition to Air. Although this relationship requires understanding and patience, it offers a unique bond that helps both sides grow.';

  static const _sexDesc = [
    'A strong physical and emotional intimacy is felt between you two. The energy specific to this area forms one of the most vibrant dimensions of your union.',
    'Physical harmony may sometimes require effort, but deep intimacy can be established through mutual interest and communication.',
    'You may have different needs in this area. Patience and open communication can turn this challenge into an opportunity.',
  ];
  static const _trustDesc = [
    'Trusting each other comes naturally. Trust is felt without needing promises; this is one of the solid foundations of your relationship.',
    'Building trust may take time. Consistency and transparency will solidify this foundation over time.',
    'You may need to be careful and patient in the area of trust. Small steps and honest communication can build this bridge.',
  ];
  static const _commDesc = [
    'Talking to each other is natural and fluent. Sharing thoughts provides a strong foundation for resolving disagreements.',
    'Communication may sometimes require effort, but when the right environment is created, deep understanding is possible.',
    'Your different communication styles may occasionally lead to misunderstandings. Listening and patience are key to overcoming this hurdle.',
  ];
  static const _emotDesc = [
    "Your emotional harmony is deep and inner. You possess a natural sensitivity to each other's moods and needs.",
    "Emotional communication may require practice. Recognizing each other's different emotional needs nurtures your relationship.",
    'Building an emotional bond may sometimes be challenging. Empathy and open expression can bridge the gap in this area.',
  ];
  static const _valDesc = [
    'Your life priorities and values largely overlap. This common ground forms the solid stones of long-term harmony.',
    'Although there may be some differences in values, this diversity offers an opportunity to learn from each other and grow.',
    'Fundamental differences in values may sometimes obscure your direction. Understanding and mutual respect can transform these differences into richness.',
  ];
}
