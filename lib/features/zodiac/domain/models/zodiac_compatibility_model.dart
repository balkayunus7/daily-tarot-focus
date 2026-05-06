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

  static CompatibilityResult calculate(ZodiacSign a, ZodiacSign b) {
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
      'İki ateş işaretinin bir araya gelmesi, tutkulu ve dinamik bir beraberlik yaratır. Birbirinizi kolayca anlarsınız çünkü aynı içsel enerjiyi paylaşırsınız. Bu ilişki; heyecan, yaratıcılık ve macera dolu anlara ev sahipliği yapar. Zaman zaman egolar çatışsa da, birbirinizin ateşini besleyen bu güçlü bağ nadiren söner.';
  static const _earthEarth =
      'İki Toprak işaretinin bir araya gelmesi, güvenilir ve uzun ömürlü bir ilişkinin zeminini oluşturur. Pratik yaklaşımlarınız ve güvenlik arayışlarınız sizi ortak bir zemine getirir. Bu birliktelik sabırlı, besleyici ve zaman içinde derinleşen bir bağ sunar. Birbirinize güvenmeyi öğrenmek yalnızca zamanla daha kolay hale gelir.';
  static const _airAir =
      'İki Hava işareti bir araya geldiğinde, fikir ve entelektüel merakın sonsuz dans ettiği bir ilişki ortaya çıkar. Birbirinizle saatlerce konuşabilir, tartışabilir ve yeni perspektifler keşfedebilirsiniz. Bu beraberlik özgürlük ve karşılıklı saygıyı ön planda tutar. Bazen duygusal bağ için daha fazla çaba gerekse de, paylaşılan zihinsel uyum eşsizdir.';
  static const _waterWater =
      'İki Su işaretinin beraberliği, derin duygusal anlayış ve sezgisel bir bağın ürünüdür. Birbirinizin söylenmeden anlaşılmasını bekler ve çoğu zaman bu gerçekleşir. Bu ilişki; şefkat, empati ve ruhsal bütünleşme üzerine kuruludur. Hassasiyetiniz zaman zaman çatışmaya sürükleyebilir, ancak duygusal derinliğiniz birbirinizin sığınağı olur.';
  static const _fireEarth =
      "Ateş'in tutkusu ile Toprak'ın sakinliği buluştuğunda, zıt enerjilerin dengelediği eşsiz bir ilişki ortaya çıkar. Ateş, Toprak'ı heyecanlandırır; Toprak ise Ateş'e istikrar sağlar. Bu denge yönetilebilirse, ikisi birbirini tamamlayan güçlü bir birlik oluştururlar. Farklı hızlar ve öncelikler kimi zaman uyumu zorlaştırsa da anlayış her şeyin üstesinden gelir.";
  static const _fireAir =
      "Ateş'in ilham veren enerjisi ile Hava'nın zekâsı buluşunca, sınırları zorlayan canlı bir bağ doğar. Birbirinizi besler, teşvik eder ve harekete geçirirsiniz. Derin konuşmalar ve spontane maceralar bu ilişkinin özünü oluşturur. Duygusal köklülük zaman zaman eksik hissettirse de, paylaşılan tutku bu boşluğu kapatar.";
  static const _fireWater =
      "Ateş ile Su'nun karşılaşması, güçlü çekim ve derin farklılıkların iç içe geçtiği bir ilişkiyi işaret eder. Birbirinizi hem büyüler hem de zorlarsınız. Ateş; Su'ya netlik ve cesaret verirken, Su; Ateş'e duygusal derinlik katmak ister. Bu zıtlığı anlayışla yönetebilirseniz, dönüştürücü bir birliktelik yaratabilirsiniz.";
  static const _earthAir =
      "Toprak'ın pratik dünyası ile Hava'nın entelektüel uçuşu, farklı ama tamamlayıcı bir uyum sunar. Hava, Toprak'ı yeni fikirlerle zenginleştirirken; Toprak, Hava'ya zemin ve güven sağlar. Bu ilişkide sabrın ve uzlaşının önemi büyüktür. Her birinizin güçlü yönleri, diğerinin eksiklerini doldurmak için bir fırsat sunar.";
  static const _earthWater =
      "Toprak ile Su'nun birleşmesi, astrolojinin en besleyici ve kalıcı bağlarından birini oluşturur. Toprak; Su'ya yön ve istikrar sağlarken, Su; Toprak'a duygusal derinlik ve sezgi katar. Bu ilişki; güven, sadakat ve olgun bir sevgi anlayışı üzerine yükselir. Birlikte zaman geçirdikçe bağınız güçlenir ve köklenir.";
  static const _airWater =
      "Hava'nın rasyonel dünyası ile Su'nun duygusal derinliği, büyüleyici ama kimi zaman zorlu bir denge kurar. Birbirinizden öğrenecek çok şeyiniz vardır: Hava, Su'ya netlik ve perspektif sunarken; Su, Hava'ya empati ve içsel sezgi öğretir. Bu ilişki anlayış ve sabır gerektirse de her iki tarafı da büyüten eşsiz bir bağ sunar.";

  static const _sexDesc = [
    'İkiniz arasında güçlü bir fiziksel ve duygusal yakınlık hissedilir. Bu alana özgü enerji, birlikteliğinizin en canlı boyutlarından birini oluşturur.',
    'Fiziksel uyum zaman zaman çaba gerektirir, ancak karşılıklı ilgi ve iletişimle derin bir yakınlık kurulabilir.',
    'Bu alanda farklı ihtiyaçlarınız olabilir. Sabır ve açık iletişim bu zorluğu fırsata dönüştürebilir.',
  ];
  static const _trustDesc = [
    'Birbirinize güvenmek doğal gelir. Söz verilmesi gerekmeden güven hissedilir; bu, ilişkinizin sağlam temellerinden biridir.',
    'Güven oluşturmak zaman alabilir. Tutarlılık ve şeffaflık bu temeli zamanla sağlamlaştıracaktır.',
    'Güven alanında dikkatli ve sabırlı olmanız gerekebilir. Küçük adımlar ve dürüst iletişim bu köprüyü inşa edebilir.',
  ];
  static const _commDesc = [
    'Birbirinizle konuşmak doğal ve akıcıdır. Düşünceleri paylaşmak, anlaşmazlıkları çözmek için güçlü bir zemin sağlar.',
    'İletişim kimi zaman çaba gerektirebilir, ancak doğru ortam yaratıldığında derin bir anlayış mümkündür.',
    'Farklı iletişim tarzlarınız zaman zaman yanlış anlaşılmalara yol açabilir. Dinleme ve sabır bu engeli aşmanın anahtarıdır.',
  ];
  static const _emotDesc = [
    'Duygusal uyumunuz derin ve içseldir. Birbirinizin ruh haline ve ihtiyaçlarına karşı doğal bir duyarlılık taşırsınız.',
    'Duygusal iletişim pratik gerektirebilir. Birbirinizin farklı duygusal ihtiyaçlarını tanımak ilişkinizi besler.',
    'Duygusal bağ kurmak zaman zaman zorlu olabilir. Empati ve açık ifade bu alandaki boşluğu köprüleyebilir.',
  ];
  static const _valDesc = [
    'Hayat öncelikleriniz ve değerleriniz büyük ölçüde örtüşür. Bu ortak zemin, uzun vadeli uyumun sağlam taşlarını oluşturur.',
    'Bazı değer farklılıkları olsa da bu çeşitlilik, birbirinizden öğrenme ve büyüme fırsatı sunar.',
    'Temel değer farklılıkları zaman zaman yönünüzü belirsizleştirebilir. Anlayış ve karşılıklı saygı bu farklılıkları zenginliğe dönüştürebilir.',
  ];
}
