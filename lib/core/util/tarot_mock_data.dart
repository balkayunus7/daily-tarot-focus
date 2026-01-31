import 'dart:math';

import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_category_enum.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_library.dart';

class TarotMockData {
  static final List<Map<String, String>> navbarItems = [
    {'path': TarotAppAssets.explore.path, 'label': 'Exlore'},
    {'path': TarotAppAssets.fish.path, 'label': 'Daily Tarots'},
    {'path': TarotAppAssets.settings.path, 'label': 'Profile'},
  ];

  static String get randomTarotCard {
    return 'assets/jpg/${allCards[Random().nextInt(allCards.length)]}.jpg';
  }

  static TarotLibrary get randomTarotLibraryCard {
    return fullTarotDeckMock[Random().nextInt(fullTarotDeckMock.length)];
  }

  static TarotLibrary getByName(String name) {
    return fullTarotDeckMock.firstWhere(
      (element) => element.title.toLowerCase() == name.toLowerCase(),
      orElse: () => fullTarotDeckMock.first,
    );
  }

  static const List<String> allCards = [
    'ace_of_cups',
    'ace_of_pentacles',
    'ace_of_swords',
    'ace_of_wands',
    'death',
    'eight_of_cups',
    'eight_of_pentacles',
    'eight_of_swords',
    'eight_of_wands',
    'five_of_cups',
    'five_of_pentacles',
    'five_of_swords',
    'five_of_wands',
    'four_of_cups',
    'four_of_pentacles',
    'four_of_swords',
    'four_of_wands',
    'judgement',
    'justice',
    'king_of_cups',
    'king_of_pentacles',
    'king_of_swords',
    'king_of_wands',
    'knight_of_cups',
    'knight_of_pentacles',
    'knight_of_swords',
    'knight_of_wands',
    'nine_of_cups',
    'nine_of_pentacles',
    'nine_of_swords',
    'nine_of_wands',
    'page_of_cups',
    'page_of_pentacles',
    'page_of_swords',
    'page_of_wands',
    'queen_of_cups',
    'queen_of_pentacles',
    'queen_of_swords',
    'queen_of_wands',
    'seven_of_cups',
    'seven_of_pentacles',
    'seven_of_swords',
    'seven_of_wands',
    'six_of_cups',
    'six_of_pentacles',
    'six_of_swords',
    'six_of_wands',
    'strength',
    'temperance',
    'ten_of_cups',
    'ten_of_pentacles',
    'ten_of_swords',
    'ten_of_wands',
    'the_chariot',
    'the_devil',
    'the_emperor',
    'the_empress',
    'the_fool',
    'the_hanged_man',
    'the_hermit',
    'the_hierophant',
    'the_high_priestess',
    'the_lovers',
    'the_magician',
    'the_moon',
    'the_star',
    'the_sun',
    'the_tower',
    'the_world',
    'three_of_cups',
    'three_of_pentacles',
    'three_of_swords',
    'three_of_wands',
    'two_of_cups',
    'two_of_pentacles',
    'two_of_swords',
    'two_of_wands',
    'wheel_of_fortune',
  ];

  static List<TarotLibrary> fullTarotDeckMock = [
    // Major Arcana
    deathCard,
    judgementCard,
    justiceCard,
    theStarCard,
    strengthCard,
    temperanceCard,
    theChariotCard,
    theDevilCard,
    theEmperorCard,
    theEmpressCard,
    theFoolCard,
    theHangedManCard,
    theHermitCard,
    theHierophantCard,
    theHighPriestessCard,
    theLoversCard,
    theMagicianCard,
    theMoonCard,
    theSunCard,
    theTowerCard,
    theWorldCard,
    wheelOfFortuneCard,

    // Cups Suit
    aceOfCupsCard,
    twoOfCupsCard,
    threeOfCupsCard,
    fourOfCupsCard,
    fiveOfCupsCard,
    sixOfCupsCard,
    sevenOfCupsCard,
    eightOfCupsCard,
    nineOfCupsCard,
    tenOfCupsCard,
    pageOfCupsCard,
    knightOfCupsCard,
    queenOfCupsCard,
    kingOfCupsCard,

    // Swords Suit
    aceOfSwordsCard,
    twoOfSwordsCard,
    threeOfSwordsCard,
    fourOfSwordsCard,
    fiveOfSwordsCard,
    sixOfSwordsCard,
    sevenOfSwordsCard,
    eightOfSwordsCard,
    nineOfSwordsCard,
    tenOfSwordsCard,
    pageOfSwordsCard,
    knightOfSwordsCard,
    queenOfSwordsCard,
    kingOfSwordsCard,

    // Pentacles Suit
    aceOfPentaclesCard,
    twoOfPentaclesCard,
    threeOfPentaclesCard,
    fourOfPentaclesCard,
    fiveOfPentaclesCard,
    sixOfPentaclesCard,
    sevenOfPentaclesCard,
    eightOfPentaclesCard,
    nineOfPentaclesCard,
    tenOfPentaclesCard,
    pageOfPentaclesCard,
    knightOfPentaclesCard,
    queenOfPentaclesCard,
    kingOfPentaclesCard,

    // Wands Suit
    aceOfWandsCard,
    twoOfWandsCard,
    threeOfWandsCard,
    fourOfWandsCard,
    fiveOfWandsCard,
    sixOfWandsCard,
    sevenOfWandsCard,
    eightOfWandsCard,
    nineOfWandsCard,
    tenOfWandsCard,
    pageOfWandsCard,
    knightOfWandsCard,
    queenOfWandsCard,
    kingOfWandsCard,
  ];
}

const TarotLibrary deathCard = TarotLibrary(
  title: 'Death',
  description:
      'Zorunlu sonlanmaları, dönüşümü, büyük değişimi ve yeni başlangıçlara yer açmayı simgeler. Fiziksel ölümden çok, bir dönemin bitişidir.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/death.jpg',
  meanings: [
    '✨ Genel: Sonlanma, dönüşüm, kaçınılmaz değişim.',
    '💼 İş/Kariyer: Bir işin bitişi, kariyerde radikal yön değişikliği.',
    '❤️ Aşk/İlişkiler: Bir ilişkinin sona ermesi, yeni bir ilişki formuna geçiş.',
    '💡 Yeniden Doğuş, Serbest Bırakma, Köklü Değişiklik.',
  ],
  uprightMeanings: [
    'Kaçınılmaz ve gerekli bir sonlanma.',
    'Yeni bir başlangıç için eskiyi bırakma zorunluluğu.',
    'Büyük bir dönüşüm ve değişim süreci.',
  ],
  reversedMeanings: [
    'Değişime direnç gösterme, tıkanmışlık.',
    'Küçük değişimlerden korkma ve yerinde sayma.',
    'Zorunlu bir sonlanmanın acı verici şekilde uzaması.',
  ],
);

const TarotLibrary judgementCard = TarotLibrary(
  title: 'Judgement',
  description:
      'Yeniden doğuşu, muhasebeyi, önemli kararları ve affetmeyi temsil eder. Geçmiş eylemlerin sonuçlarıyla yüzleşme.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/judgement.jpg',
  meanings: [
    '✨ Genel: Muhasebe, çağrı, yargılama, yeniden uyanış.',
    '💼 İş/Kariyer: Önemli bir iş teklifi, kariyer muhasebesi.',
    '❤️ Aşk/İlişkiler: İlişki hakkında nihai bir karar verme.',
    '💡 Değerlendirme, Affetme, İkinci Şans.',
  ],
  uprightMeanings: [
    'Geçmiş eylemlerinizin sonuçlarıyla yüzleşme.',
    'Büyük bir çağrı veya hayatınızı değiştirecek önemli bir karar.',
    'Yeniden doğuş ve kendini affetme.',
  ],
  reversedMeanings: [
    'Kendini suçlama, şüphe ve yargılanma korkusu.',
    'Önemli bir kararı erteleme veya reddetme.',
    'Kötü bir karar veya vicdan azabı.',
  ],
);

const TarotLibrary justiceCard = TarotLibrary(
  title: 'Justice',
  description:
      'Adaleti, dengeyi, gerçeği ve hukuki konuları temsil eder. Sebep-sonuç ilişkisinin kartıdır.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/justice.jpg',
  meanings: [
    '✨ Genel: Adalet, denge, doğruluk, yasal süreçler.',
    '💼 İş/Kariyer: Sözleşmeler, adil anlaşmalar, yasal işlemler.',
    '❤️ Aşk/İlişkiler: İlişkide dürüstlük, eşitlik ve denge.',
    '⚖️ Hukuk, Sebep-Sonuç, Hesap Verebilirlik.',
  ],
  uprightMeanings: [
    'Adil sonuçlar, dürüstlük ve gerçeğin ortaya çıkışı.',
    'Yasal bir meselenin lehinize çözülmesi.',
    'Eylemlerinizden sorumlu olma ve dengeyi koruma.',
  ],
  reversedMeanings: [
    'Haksızlık, yasal gecikmeler veya önyargı.',
    'Yanlış kararlar verme veya sorumluluktan kaçma.',
    'Dengesizlik ve yolsuzluk.',
  ],
);

const TarotLibrary theStarCard = TarotLibrary(
  title: 'The Star',
  description:
      'Umut, ilham, yenilenme ve dinginliği simgeler. Evren tarafından kutsanmış hissetme.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_star.jpg',
  meanings: [
    '✨ Genel: Umut, ilham, yenilenme, ruhsal bağlantı.',
    '🧘‍♀️ Sağlık/Ruh: Şifa, duygusal denge, huzur.',
    '💡 Yaratıcılık: Yeni fikirler, geleceğe dair iyimserlik.',
    '🌟 Dinginlik, İyimserlik, Evrensel Sevgi.',
  ],
  uprightMeanings: [
    'Umut ve ilhamın geri dönüşü.',
    'İyileşme, huzur ve ruhsal dinginlik.',
    'Geleceğe dair parlak ve iyimser bir görüş.',
  ],
  reversedMeanings: [
    'Umutsuzluk, karamsarlık ve inanç eksikliği.',
    'İlham kaybı, güvensizlik.',
    'İyileşmenin gecikmesi, ruhsal blokajlar.',
  ],
);

const TarotLibrary strengthCard = TarotLibrary(
  title: 'Strength',
  description:
      'İçsel gücü, cesareti, merhameti ve sabrı temsil eder. Dışsal değil, içsel gücü kullanma.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/strength.jpg',
  meanings: [
    '✨ Genel: Cesaret, içsel güç, merhamet.',
    '🧘‍♀️ Sağlık/Ruh: Fiziksel ve ruhsal güç, özgüven.',
    '💡 Sabır, İkna, Hassasiyet.',
    '🦁 Hayvan ruhu, Şefkat, Yürek.',
  ],
  uprightMeanings: [
    'İçsel güç ve cesaretle zorlukların üstesinden gelme.',
    'Zorlu bir durumu sabır ve merhametle yönetme.',
    'Korkularla yüzleşme ve özgüvenin artması.',
  ],
  reversedMeanings: [
    'Özgüven eksikliği, zayıflık veya korku.',
    'Gücü kötüye kullanma veya kaba kuvvet uygulama.',
    'Kendinden şüphe etme, içsel gücü bastırma.',
  ],
);

const TarotLibrary temperanceCard = TarotLibrary(
  title: 'Temperance',
  description:
      'Dengeyi, ölçülülüğü, sabrı ve uyumu temsil eder. Hayatın farklı yönlerini harmanlama ihtiyacı.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/temperance.jpg',
  meanings: [
    '✨ Genel: Denge, ölçülülük, sabır, uyum.',
    '🧘‍♀️ Sağlık/Ruh: Şifa, kimya, enerjileri harmanlama.',
    '💡 Orta Yol, İşbirliği, Sağduyu.',
    '🤝 Uyum sağlama, Hassas Kontrol.',
  ],
  uprightMeanings: [
    'Hayatın farklı yönleri arasında mükemmel denge.',
    'Sabır ve ölçülülükle ilerleme, aşırılıktan kaçınma.',
    'Farklı fikirlerin ve enerjilerin başarılı birleşimi.',
  ],
  reversedMeanings: [
    'Dengesizlik, aşırılık ve ölçüsüzlük.',
    'Uyumsuzluk ve çatışma, sabırsızlık.',
    'İlerlemeyi engelleyen tutarsızlık.',
  ],
);

const TarotLibrary theDevilCard = TarotLibrary(
  title: 'The Devil',
  description:
      'Bağlılık, maddesel tuzaklar, bağımlılıklar ve kısıtlanmış hissetmeyi temsil eder. Genellikle kendi kendini kısıtlama.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_devil.jpg',
  meanings: [
    '✨ Genel: Bağımlılık, kısıtlama, maddiyat, gölge benlik.',
    '💰 Finans/Maddi: Maddi tuzaklar, aşırı tüketim, hırs.',
    '❤️ Aşk/İlişkiler: Sağlıksız takıntılar, cinsel bağımlılık.',
    '🔗 Esaret, Bağımlılık, Kendi Kendini Kısıtlama.',
  ],
  uprightMeanings: [
    'Maddi bağımlılıklar ve kısıtlamalarla yüzleşme.',
    'Kendi yarattığınız esaretten kurtulma ihtiyacı.',
    'Korku ve gölge benliğinizin farkına varma.',
  ],
  reversedMeanings: [
    'Bağımlılıklardan kurtulma ve özgürleşme.',
    'Kısıtlamaların üstesinden gelme ve güçlenme.',
    'Kendi iç gücünüzü geri kazanma.',
  ],
);

const TarotLibrary theEmperorCard = TarotLibrary(
  title: 'The Emperor',
  description:
      'Otorite, yapı, kontrol ve babalık figürünü temsil eder. Düzen kurma ve disiplin kartıdır.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_emperor.jpg',
  meanings: [
    '✨ Genel: Otorite, düzen, kontrol, babalık.',
    '💼 İş/Kariyer: Liderlik pozisyonu, kural koyucu, sağlam bir yapı kurma.',
    '💰 Finans/Sağlık: Maddi güvenlik, disiplinli bir sağlık rejimi.',
    '💡 İstikrar, Mantık, Yapı.',
  ],
  uprightMeanings: [
    'Disiplin, mantık ve kontrolün ele alınması.',
    'Güçlü bir liderlik ve otorite figürünün ortaya çıkışı.',
    'Uzun vadeli istikrar ve güvenlik için yapılar kurma.',
  ],
  reversedMeanings: [
    'Otoriterlik, aşırı kontrol veya katılık.',
    'Kural tanımama, disiplin eksikliği veya zayıf liderlik.',
    'Yıkıcı bir güç, mantık yerine ego ile hareket etme.',
  ],
);

const TarotLibrary theFoolCard = TarotLibrary(
  title: 'The Fool',
  description:
      'Yeni başlangıçlar, masumiyet, macera ve bilinmeyene atılmayı temsil eder. Saflık ve sınırsız potansiyel.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_fool.jpg',
  meanings: [
    '✨ Genel: Yeni Başlangıçlar, Masumiyet, Macera.',
    '💼 İş/Kariyer: Yeni bir işe girişme, risk alma.',
    '💡 Potansiyel, İyimserlik, Spontane Eylem.',
    '⛰️ Yüksek Bir Yerden Atlama, İnanç.',
  ],
  uprightMeanings: [
    'Yeni başlangıçlar için hazır olma, bilinmeyene atılma.',
    'İyimserlik, masumiyet ve sınırsız potansiyel.',
    'Hayatın tadını çıkarma, spontane ve özgür olma.',
  ],
  reversedMeanings: [
    'Dikkatsizlik, pervasızlık veya aptallık.',
    'Risk almaktan korkma, potansiyeli boşa harcama.',
    'Yanlış bir karar verme veya yersiz saflık.',
  ],
);

const TarotLibrary theHangedManCard = TarotLibrary(
  title: 'The Hanged Man',
  description:
      'Farklı bir perspektife, fedakarlığa, ertelemeye ve teslimiyete çağırır. Askıya alınmış eylem.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_hanged_man.jpg',
  meanings: [
    '✨ Genel: Erteleme, farklı bir bakış açısı, teslimiyet.',
    '💡 Fedakarlık, Tıkanıklık, Yeniden Değerlendirme.',
    '🧘‍♀️ Maneviyat: Aydınlanma, kurban verme.',
    '⏳ Durgunluk, Bekleyiş.',
  ],
  uprightMeanings: [
    'Bir duruma farklı bir perspektiften bakma ihtiyacı.',
    'Gönüllü fedakarlık veya eylemi erteleme.',
    'Teslimiyet ve durumu kontrol etmeyi bırakma.',
  ],
  reversedMeanings: [
    'Çaresizlik, gereksiz fedakarlık veya inatçılık.',
    'Kendini boşa harcama, durumu kontrol etmeye çalışma.',
    'Önemli bir dersi öğrenmeyi reddetme.',
  ],
);

const TarotLibrary theHermitCard = TarotLibrary(
  title: 'The Hermit',
  description:
      'Yalnızlık, iç gözlem, arayış ve bilgelik arayışını temsil eder. Dış dünyadan çekilme ihtiyacı.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_hermit.jpg',
  meanings: [
    '✨ Genel: Yalnızlık, iç gözlem, bilgelik.',
    '🎓 Öğrenme/Arayış: Rehberlik arama, derin düşünme, tefekkür.',
    '💡 Işık, Geri Çekilme, Bilinçli Yalnızlık.',
    '⏳ Sabır, Kendine Odaklanma.',
  ],
  uprightMeanings: [
    'İç gözlem, yalnızlık ve kişisel gelişim için geri çekilme.',
    'Manevi bir arayış veya rehberlik bulma.',
    'Bilgelik ve içsel doğruyu arama.',
  ],
  reversedMeanings: [
    'Yalnızlıktan korkma, sosyal izolasyon.',
    'Bilgelikten kaçınma, geri çekilmeyi reddetme.',
    'Aşırı derecede şüpheci ve güvensiz olma.',
  ],
);

const TarotLibrary theHierophantCard = TarotLibrary(
  title: 'The Hierophant',
  description:
      'Gelenek, kurumlar, manevi rehberlik ve uyumu temsil eder. Doğru yolu bulmak için kurallara uyma.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_hierophant.jpg',
  meanings: [
    '✨ Genel: Gelenek, kurum, dini veya manevi rehberlik.',
    '🎓 Eğitim/Kurum: Öğretmen, danışman, geleneksel öğrenme.',
    '❤️ Aşk/İlişkiler: Kurumsal evlilik, geleneksel değerler.',
    '💡 Uyum, Öğrenme, Kurallar.',
  ],
  uprightMeanings: [
    'Resmi danışmanlık veya rehberlik alma.',
    'Geleneksel değerlere ve kurumlara uyum sağlama.',
    'Önemli bir ritüel, düğün veya manevi tören.',
  ],
  reversedMeanings: [
    'Geleneklere isyan etme, kısıtlanmış hissetme.',
    'Yanlış danışmanlık, geleneksel olmayan yolları arama.',
    'Kendi kurallarını yaratma arzusu, dogmatizm.',
  ],
);

const TarotLibrary theHighPriestessCard = TarotLibrary(
  title: 'The High Priestess',
  description:
      'Gizemi, sezgiyi, bilinmeyeni ve pasif bilgiyi temsil eder. İçgüdülerinize güvenmeniz gerektiğini işaret eder.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_high_priestess.jpg',
  meanings: [
    '✨ Genel: Gizem, sezgi, bilinçaltı.',
    '🧘‍♀️ Sağlık/Ruh: İçsel bilgelik, meditasyon, gizli gerçekler.',
    '❤️ Aşk/İlişkiler: Gizli bir ilişki, sezgisel bir bağ, duygusal derinlik.',
    '💡 Sabır, Pasiflik, Sır.',
  ],
  uprightMeanings: [
    'Sezgilerinize güvenin, içsel sesinizi dinleyin.',
    'Ortaya çıkmayı bekleyen gizli bilgi veya sırlar.',
    'Pasiflik, sessizlik ve derin düşünme zamanı.',
  ],
  reversedMeanings: [
    'İçgüdüleri reddetme, duygusal yüzeysellik.',
    'Gizli düşmanlar, yüzeye çıkan sırlar.',
    'Aşırı pasiflik, bilgi eksikliği veya yanlış sezgiler.',
  ],
);

const TarotLibrary theMagicianCard = TarotLibrary(
  title: 'The Magician',
  description:
      'Potansiyeli, eylemi, kaynakları ve irade gücünü temsil eder. Sahip olduğu yetenekleri kullanma zamanı.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_magician.jpg',
  meanings: [
    '✨ Genel: Yaratıcılık, konsantrasyon, kaynaklara sahip olma.',
    '💼 İş/Kariyer: Yeni projeye başlama, yetenekleri sergileme, girişimcilik.',
    '❤️ Aşk/İlişkiler: Büyüleyici yeni bir ilişki, isteyerek bir ilişki başlatma.',
    '💡 İrade Gücü, Odaklanma, Yetenek.',
  ],
  uprightMeanings: [
    'Eyleme geçme gücü, yetenek ve kaynaklara sahip olma.',
    'Yeni başlangıçlar için uygun zaman, kendine güven.',
    'İrade gücü ve zekanın ustaca kullanımı.',
  ],
  reversedMeanings: [
    'Yetenekleri boşa harcama, hilekarlık veya manipulasyon.',
    'Özgüven eksikliği, fırsatları kaçırma.',
    'Yanlış yönlendirilmiş enerji ve amaçsızlık.',
  ],
);

const TarotLibrary theMoonCard = TarotLibrary(
  title: 'The Moon',
  description:
      'Korkuyu, illüzyonu, bilinçaltını ve sezgiyi temsil eder. Durumlar net değildir ve şüphe vardır.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_moon.jpg',
  meanings: [
    '✨ Genel: Korku, illüzyon, bilinçaltı, sezgi.',
    '💡 Gizem: Gizli düşmanlar, yanılsama, belirsizlik.',
    '🧘‍♀️ Ruh: Derin duygular, rüyalar, içgüdü.',
    '🐺 Güvensizlik, Kafa Karışıklığı.',
  ],
  uprightMeanings: [
    'Korku, bilinçaltı endişeler ve yanılsamalar.',
    'Durumlar net değil, kafa karışıklığı ve şüphe.',
    'Gizli düşmanlar veya aldatmacalar.',
  ],
  reversedMeanings: [
    'Korkuların üstesinden gelme ve netlik kazanma.',
    'Gizli gerçeklerin yavaş yavaş ortaya çıkması.',
    'Yanlış anlamaların çözülmesi.',
  ],
);

const TarotLibrary theSunCard = TarotLibrary(
  title: 'The Sun',
  description:
      'Neşe, başarı, canlılık ve özgüveni temsil eder. Hayatın en parlak ve en olumlu yönleri.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_sun.jpg',
  meanings: [
    '✨ Genel: Neşe, başarı, canlılık, özgüven.',
    '❤️ Aşk/İlişkiler: Uyumlu ilişkiler, mutluluk, gerçek aşk.',
    '💼 İş/Kariyer: Tanınma, büyük fırsatlar, ilham.',
    '🌟 Aydınlanma, Berraklık, Yaşam Gücü.',
  ],
  uprightMeanings: [
    'Mutlak başarı, neşe ve olumlu enerji.',
    'Açıklık, berraklık ve özgüvenin artması.',
    'Her şeyin yolunda gittiği bir dönem.',
  ],
  reversedMeanings: [
    'Geçici hayal kırıklığı veya başarının gecikmesi.',
    'Neşe eksikliği, karamsarlık veya kendine güvensizlik.',
    'Önemli bir gerçeği görememe.',
  ],
);

const TarotLibrary theTowerCard = TarotLibrary(
  title: 'The Tower',
  description:
      'Ani yıkım, köklü değişiklik, kriz ve özgürleşmeyi temsil eder. Gerekli bir uyanış.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_tower.jpg',
  meanings: [
    '✨ Genel: Yıkım, kriz, ani değişiklik, ifşaat.',
    '💡 Sarsıntı: Hayatın temel yapılarının çökmesi.',
    '🔥 Serbest Kalma, Uyanış, Ortaya Çıkan Gerçek.',
    '⚡ Felaaket, Değişim.',
  ],
  uprightMeanings: [
    'Ani ve yıkıcı bir kriz veya değişiklik.',
    'Artık işe yaramayan yapıların yıkılması.',
    'Gerekli bir uyanış ve özgürleşme.',
  ],
  reversedMeanings: [
    'Değişimi engelleme, felaketi erteleme.',
    'Küçük ama önemli krizler.',
    'Kaçınılmaz değişimin daha yumuşak gerçekleşmesi.',
  ],
);

const TarotLibrary wheelOfFortuneCard = TarotLibrary(
  title: 'Wheel of Fortune',
  description:
      'Kader, şans, döngüler ve dönüm noktalarını temsil eder. Hayatınızda büyük bir dönemeç.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/wheel_of_fortune.jpg',
  meanings: [
    '✨ Genel: Kader, şans, dönüm noktası, döngü.',
    '💰 Finans: İyi şans, beklenmedik kazanç.',
    '💡 Değişim, Hareket, İyi Talih.',
    '🔄 Tekerleğin Dönmesi, Neden-Sonuç.',
  ],
  uprightMeanings: [
    'İyi şans, kaderin lehinize dönmesi.',
    'Büyük bir dönüm noktası veya önemli bir değişim.',
    'Karmik olaylar ve döngülerin tamamlanması.',
  ],
  reversedMeanings: [
    'Kötü şans, aksilikler veya gecikmeler.',
    'Döngüsel sorunlar, talihsizlik.',
    'Dış faktörlerin kontrolünüz dışında olması.',
  ],
);

const TarotLibrary theChariotCard = TarotLibrary(
  title: 'The Chariot',
  description:
      'İrade gücü, zafer, kontrol, kararlılık ve hızlı ilerlemeyi temsil eder. Engelleri aşarak hedefe ulaşma.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_chariot.jpg',
  meanings: [
    '✨ Genel: Zafer, kontrol, kararlılık, seyahat.',
    '💼 İş/Kariyer: İş gezisi, kariyerde hızlı ilerleme, başarı.',
    '💡 İrade Gücü, Başarı, Yönlendirme.',
    '🚀 Hareket, Hız, Kendini Kontrol.',
  ],
  uprightMeanings: [
    'İradenin zaferi, engelleri aşarak başarıya ulaşma.',
    'Hedefinize doğru kararlı ve hızlı bir ilerleme.',
    'Kendini kontrol ve disiplin sayesinde ilerleme.',
  ],
  reversedMeanings: [
    'Yön eksikliği, kontrolü kaybetme veya yenilgi.',
    'Amaçsız sürüklenme veya aceleci davranma.',
    'Dengeyi kuramama ve iç çatışmalar.',
  ],
);

const TarotLibrary theEmpressCard = TarotLibrary(
  title: 'The Empress',
  description:
      'Bereket, annelik, yaratıcılık, duyusallık ve doğanın gücünü simgeler. Bolluk ve büyümeyi temsil eder.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_empress.jpg',
  meanings: [
    '✨ Genel: Bereket, annelik, duyusallık, lüks.',
    '💰 Finans/Yaratıcılık: Maddi bolluk, yaratıcı projelerde büyüme.',
    '❤️ Aşk/İlişkiler: Aile, konfor, doğurganlık, sevgi dolu bakım.',
    '💡 Doğurganlık, Besleme, Güzellik.',
  ],
  uprightMeanings: [
    'Bolluk ve bereketin keyfini çıkarma, büyüme dönemi.',
    'Doğurganlık (fikir, sanat veya bebek), yaratıcılık.',
    'Kendine bakma, lüks ve konforun tadını çıkarma.',
  ],
  reversedMeanings: [
    'Yaratıcılıkta tıkanma, kıtlık veya maddi sorunlar.',
    'Başkalarına aşırı bağımlılık veya ihmalkarlık.',
    'Kısırlık veya duygusal soğukluk.',
  ],
);

const TarotLibrary theLoversCard = TarotLibrary(
  title: 'The Lovers',
  description:
      'Aşkı, ilişkileri, değerleri ve önemli bir seçimi temsil eder. İki yol arasındaki kararı simgeler.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_lovers.jpg',
  meanings: [
    '✨ Genel: Aşk, uyum, ilişki, değerler.',
    '❤️ Aşk/İlişkiler: Derin bir aşk bağı, ruh eşi, cinsel uyum.',
    '💡 Karar: Önemli bir seçim yapma, yol ayrımı.',
    '🤝 İlişki Kurma, Değerler, Bağlılık.',
  ],
  uprightMeanings: [
    'Aşk, uyum ve mükemmel birleşme.',
    'Kalpten gelen büyük ve önemli bir seçim yapma.',
    'Değerlerinizin ve inançlarınızın bir testten geçmesi.',
  ],
  reversedMeanings: [
    'Uyumsuzluk, çatışma veya ilişkinin bitmesi.',
    'Yanlış seçimler, kararsızlık veya ikilem.',
    'Değerlerle ilgili çatışmalar, sadakatsizlik.',
  ],
);

const TarotLibrary theWorldCard = TarotLibrary(
  title: 'The World',
  description:
      'Tamamlanma, başarı, bütünlük ve uyumu temsil eder. Bir döngünün sonu ve kutlama.',
  category: TarotCategory.majorArcana,
  imagePath: 'assets/jpg/the_world.jpg',
  meanings: [
    '✨ Genel: Tamamlanma, Başarı, Bütünlük, Uyum.',
    '🌍 Seyahat: Dünya seyahatleri, küresel başarı.',
    '💡 Döngü Sonu, Başarı, Ödül, Kutlama.',
    '🏆 Hedefe Ulaşma, Evrensel Bilinç.',
  ],
  uprightMeanings: [
    'Başarı ve hedeflere ulaşma, bir döngünün tamamlanması.',
    'Bütünlük, uyum ve evrenle bağlantı.',
    'Uzun bir yolculuğun veya projenin mutlu sonu.',
  ],
  reversedMeanings: [
    'Tamamlanmamışlık, gecikmeler veya engeller.',
    'Başarıyı kutlamayı reddetme.',
    'Hedeflere ulaşamama veya yetersiz hissetme.',
  ],
);

// CUPS SUIT
// ===================================

const TarotLibrary aceOfCupsCard = TarotLibrary(
  title: 'Ace of Cups',
  description:
      'Duygusal bolluğun, yeni bir aşkın veya ruhsal bir uyanışın başlangıcını simgeler. Kalbinizin dolup taşması.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/ace_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Yeni ve derin bir aşk, duygusal tatmin, büyük neşe.',
    '💼 İş/Kariyer: Yaratıcı projelerde ilham, işe karşı duyulan tutku.',
    '💰 Finans/Sağlık: Duygusal şifa ve denge, cömertlik.',
    '💡 Sezgi, İçsel Huzur, Yeni Duygusal Başlangıçlar.',
  ],
  uprightMeanings: [
    'Yeni başlangıçlar, büyük neşe ve duygusal coşku.',
    'Derin mutluluk ve ruhsal tatmin.',
    'Aşk, şefkat ve şifa gücü.',
  ],
  reversedMeanings: [
    'Bastırılmış duygular, duygusal blokajlar veya hayal kırıklığı.',
    'İçsel boşluk hissi veya sevgiye karşılık bulamama.',
    'Duygusal taşkınlık, aşırı hassasiyet veya sevginin zehirli hale gelmesi.',
  ],
);

const TarotLibrary twoOfCupsCard = TarotLibrary(
  title: 'Two of Cups',
  description:
      'Birlik, uyum, ortaklık ve karşılıklı çekimi temsil eder. Sevgi dolu bir ilişki veya anlaşma.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/two_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Güçlü çekim, yeni bir aşk, ruh eşi bağlantısı.',
    '🤝 İş/Kariyer: Başarılı bir ortaklık, iyi bir işbirliği.',
    '💡 Uyum, Denklik, Saygı.',
    '⚖️ Denge, Bağlılık.',
  ],
  uprightMeanings: [
    'Karşılıklı sevgi, saygı ve uyum.',
    'Güçlü bir birliktelik veya ortaklık.',
    'Ruhsal ve duygusal bağ kurma.',
  ],
  reversedMeanings: [
    'Uyumsuzluk, dengesizlik veya ayrılık.',
    'Ortaklıkta sorunlar, karşılıklı saygı eksikliği.',
    'Aşk veya ilişkinin bozulması.',
  ],
);

const TarotLibrary threeOfCupsCard = TarotLibrary(
  title: 'Three of Cups',
  description:
      'Kutlama, dostluk, topluluk ve başarıyı temsil eder. Başarıyı arkadaşlarınızla kutlama zamanı.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/three_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Kutlama, düğün, güçlü dostluklar.',
    '💼 İş/Kariyer: Projenin başarılı tamamlanması ve ekip kutlaması.',
    '💡 Neşe, Topluluk, Verimlilik.',
    '🎉 Sosyallik, Birlik.',
  ],
  uprightMeanings: [
    'Kutlama, neşe ve iyi arkadaşlıklar.',
    'Başarının paylaşılması ve sosyal uyum.',
    'Verimlilik ve hedeflere ulaşma.',
  ],
  reversedMeanings: [
    'Aşırıcılık, dedikodu veya skandal.',
    'Sosyal uyumsuzluk veya parti sonrası düşüş.',
    'Bir kutlamanın iptal edilmesi.',
  ],
);

const TarotLibrary fourOfCupsCard = TarotLibrary(
  title: 'Four of Cups',
  description:
      'Doymuşluk, kayıtsızlık veya yeni tekliflere karşı isteksizliği simgeler. Teklif edilen bir fırsatı görmezden gelme.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/four_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Bir ilişkide sıkılma, duygusal durgunluk.',
    '💼 İş/Kariyer: Yeni iş tekliflerine karşı isteksizlik, motivasyon eksikliği.',
    '💰 Finans/Sağlık: Maddi konularda kayıtsızlık, enerji düşüklüğü.',
    '💡 Doygunluk, Can Sıkıntısı, Nankörlük.',
  ],
  uprightMeanings: [
    'Kayıtsızlık, can sıkıntısı ve doymuşluk.',
    'Yeni teklifleri veya fırsatları reddetme.',
    'Durumu iyileştirmek için harekete geçme isteksizliği.',
  ],
  reversedMeanings: [
    'Yeniden motivasyon ve isteklilik kazanma.',
    'Yeni bir fırsatı kucaklama ve enerjik hissetme.',
    'Kendini beğenmişlikten kurtulma ve çevreye açılma.',
  ],
);

const TarotLibrary fiveOfCupsCard = TarotLibrary(
  title: 'Five of Cups',
  description:
      'Kaybın, kederin ve pişmanlığın kartıdır. Genellikle dökülen üç kupaya odaklanıp, hala ayakta olan ikisini görememeyi anlatır.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/five_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Ayrılık sonrası yas, pişmanlık, geçmişi özleme.',
    '💼 İş/Kariyer: Başarısızlıklar veya kayıplar sonrası karamsarlık.',
    '💰 Finans/Sağlık: Maddi kayıplar, iyileşmeye odaklanamama.',
    '💡 Keder, Pişmanlık, Hayal Kırıklığı.',
  ],
  uprightMeanings: [
    'Kayıp ve üzüntü, geçmişe takılı kalma.',
    'Fırsatları kaçırma veya sahip olunan şeyleri takdir edememe.',
    'Üzüntü ve pişmanlık dönemini kabullenme ihtiyacı.',
  ],
  reversedMeanings: [
    'Kaybı kabullenme ve iyileşmeye başlama.',
    'Yeniden umut bulma ve ileriye bakma.',
    'Geçmişten gelen bir ilişkinin veya durumun barışçıl çözümü.',
  ],
);

const TarotLibrary sixOfCupsCard = TarotLibrary(
  title: 'Six of Cups',
  description:
      'Geçmişi, nostaljiyi, çocukluğu ve masumiyeti temsil eder. Geçmişten gelen bir hediyeyi veya kişiyi simgeler.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/six_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Geçmişten gelen bir aşk, çocukluk arkadaşı, nostalji.',
    '💡 Anılar: Geçmişe özlem, çocukluk anıları.',
    '🤝 Cömertlik, İyilik, Masumiyet.',
    '🏡 Yuva, Tanıdık Yerler.',
  ],
  uprightMeanings: [
    'Geçmişten gelen güzel anılar ve nostalji.',
    'Eski bir arkadaşla veya aşkla yeniden bir araya gelme.',
    'Cömertlik ve iyilik yapma.',
  ],
  reversedMeanings: [
    'Geçmişe takılı kalma, ilerlemeyi reddetme.',
    'Çocukluk travmaları veya sorunları.',
    'Huzursuzluk, geçmişten kurtulma zorluğu.',
  ],
);

const TarotLibrary sevenOfCupsCard = TarotLibrary(
  title: 'Seven of Cups',
  description:
      'Seçenekleri, hayalleri, illüzyonları ve kafa karışıklığını temsil eder. Gerçekçi olmayan beklentiler.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/seven_of_cups.jpg',
  meanings: [
    '✨ Genel: Hayaller, yanılsamalar, sayısız seçenek.',
    '💡 Kafa Karışıklığı, Seçim Yapma Zorluğu, Fantezi.',
    '🚫 Gerçekdışı beklentiler, Aşırı Hayalcilik.',
    '🤔 İrade Gücü, Disiplin Eksikliği.',
  ],
  uprightMeanings: [
    'Sayısız seçenek ve karar verme zorluğu.',
    'Gerçekçi olmayan hayaller ve illüzyonlar.',
    'Olasılıklar arasında kaybolma.',
  ],
  reversedMeanings: [
    'Kafa karışıklığının giderilmesi ve netlik.',
    'Gerçekçi bir hedef belirleme ve eyleme geçme.',
    'Büyük bir yanılsamadan kurtulma.',
  ],
);

const TarotLibrary eightOfCupsCard = TarotLibrary(
  title: 'Eight of Cups',
  description:
      'Duygusal tatminsizlik nedeniyle bir durumu, ilişkiyi veya yeri terk etmeyi temsil eder. Daha derin bir anlam arayışı.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/eight_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Tatmin etmeyen bir ilişkiyi bitirme kararı.',
    '💼 İş/Kariyer: Artık anlam ifade etmeyen bir kariyeri bırakma.',
    '💰 Finans/Sağlık: Maddi duruma rağmen içsel boşluk hissi.',
    '💡 Ayrılış, Yorgunluk, Daha Anlamlı Bir Şey Arayışı.',
  ],
  uprightMeanings: [
    'Bir durumdan veya ilişkiden sessizce çekilme.',
    'Duygusal tatmin ve ruhsal anlam arayışı.',
    'Terk etme kararı, ancak bu bir zorunluluktan çok bir seçimdir.',
  ],
  reversedMeanings: [
    'Geri dönme kararı veya ayrılmaktan tereddüt etme.',
    'Kaçınma veya bir durumu bitirmeye cesaret edememe.',
    'Tekrarlayan duygusal döngülere saplanma.',
  ],
);

const TarotLibrary nineOfCupsCard = TarotLibrary(
  title: 'Nine of Cups',
  description:
      "Dileklerin gerçekleşmesi, duygusal tatmin ve mutluluğu simgeler. Genellikle 'Dilek Kartı' olarak bilinir.",
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/nine_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: İlişkide büyük mutluluk, ruh eşini bulma.',
    '💼 İş/Kariyer: İş yerinde başarı, tatmin edici bir pozisyona ulaşma.',
    '💰 Finans/Sağlık: Maddi konfor ve güvenlik, fiziksel sağlığın iyi olması.',
    '💡 Keyif Alma, Lüks, Tatmin ve Güven.',
  ],
  uprightMeanings: [
    'Dileklerin gerçekleşmesi ve mutluluk.',
    'Kendine güven ve duygusal tatmin.',
    'Maddi ve manevi olarak kendini iyi hissetme.',
  ],
  reversedMeanings: [
    'Gerçekleşmeyen dilekler veya hayal kırıklığı.',
    'Aşırı hoşgörü, kibir veya kendini beğenmişlik.',
    'Maddi kazanç olmasına rağmen duygusal boşluk.',
  ],
);

const TarotLibrary tenOfCupsCard = TarotLibrary(
  title: 'Ten of Cups',
  description:
      'Mutlak mutluluk, kalıcı uyum, aile ve duygusal tatminin doruk noktasını temsil eder. Gerçekleşen rüyalar.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/ten_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Aile mutluluğu, evlilik, huzurlu yuva.',
    '💡 Uyum, Neşe, Ebedi Mutluluk.',
    '🏡 Çocuklar ve Ev, Kalıcı Barış.',
    '🌟 Duygusal Tamamlanma.',
  ],
  uprightMeanings: [
    'Aile ve duygusal mutluluğun en üst seviyesi.',
    'Kalıcı uyum ve barış.',
    'Hayatınızın duygusal olarak tamamlanması.',
  ],
  reversedMeanings: [
    'Aile içi çatışma, uyumsuzluk veya bozulma.',
    'Mutluluğun geçici veya sahte olması.',
    'Ailenin desteğini kaybetme.',
  ],
);

const TarotLibrary pageOfCupsCard = TarotLibrary(
  title: 'Page of Cups',
  description:
      'Duygusal haberi, sezgiyi, sanatsal ilhamı ve yaratıcı teklifleri temsil eder. Genç, hassas bir kişi.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/page_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Yeni romantik davet, hassas bir kişi.',
    '💼 İş/Kariyer: Yaratıcı bir teklif veya ilham verici bir fikir.',
    '💡 Haber: Duygusal bir mesaj, sezgisel uyanış.',
    '🎨 Sanatsal Yetenek, Hayalperest.',
  ],
  uprightMeanings: [
    'Yeni duygusal haber veya teklif.',
    'Yaratıcı ilham ve sanatsal yeteneklerin keşfi.',
    'Hassas, hayalperest ve sezgisel bir kişi.',
  ],
  reversedMeanings: [
    'Kötü haberler, duygusal olgunlaşmamışlık.',
    'Yaratıcı blokaj, hayal kırıklığı.',
    'Gerçek dışı vaatler, duygusal manipülasyon.',
  ],
);

const TarotLibrary knightOfCupsCard = TarotLibrary(
  title: 'Knight of Cups',
  description:
      'Romantizmi, teklifleri, davetleri ve hayalperest bir eylemi temsil eder. Duygusal bir haberci.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/knight_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Romantik teklif, çekici bir flört.',
    '💼 İş/Kariyer: Yaratıcı bir iş teklifi veya davet.',
    '💡 Haber: Duygusal bir teklif veya davet.',
    '💌 Romantizm, Zarafet, Hayalperestlik.',
  ],
  uprightMeanings: [
    'Bir davet veya romantik teklifin gelişi.',
    'Hassas, çekici ve romantik bir kişinin yaklaşması.',
    'Yaratıcı fikirlerin eyleme geçirilmesi.',
  ],
  reversedMeanings: [
    'Yanlış teklifler, hayal kırıklığı veya duygusal karışıklık.',
    'Modu düşük, karamsar veya güvensiz bir kişi.',
    'Aşk veya ilişkide tutarsızlık.',
  ],
);

const TarotLibrary queenOfCupsCard = TarotLibrary(
  title: 'Queen of Cups',
  description:
      'Sezgi, şefkat, duygusal istikrar ve sanatsal yeteneği temsil eder. Duyarlı bir figür.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/queen_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Sevecen, şefkatli ve sezgisel bir kadın.',
    '💼 İş/Kariyer: Yaratıcılık gerektiren işlerde başarı.',
    '💡 Sezgi, Duygusallık, Şifa.',
    '👑 Anaç, Sevgi Dolu Danışman.',
  ],
  uprightMeanings: [
    'Şefkatli, sevgi dolu ve duygusal olarak istikrarlı bir kadın.',
    'Güçlü sezgi ve psişik yetenekler.',
    'Başkalarına duygusal destek sağlama.',
  ],
  reversedMeanings: [
    'Duygusal dengesizlik, bağımlılık veya aşırı hassasiyet.',
    'Kıskançlık, huysuzluk veya güvensizlik.',
    'Duygusal manipülasyon.',
  ],
);

const TarotLibrary kingOfCupsCard = TarotLibrary(
  title: 'King of Cups',
  description:
      'Duygusal olgunluk, merhamet, kontrol ve dengeyi temsil eder. Bilge bir yönetici figürü.',
  category: TarotCategory.cups,
  imagePath: 'assets/jpg/king_of_cups.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Duygusal olarak olgun, dengeli bir erkek.',
    '💼 İş/Kariyer: Sanat, danışmanlık veya şifa alanında lider.',
    '💡 Merhamet, Denge, Kontrol.',
    '👑 Bilgelik, Hoşgörü.',
  ],
  uprightMeanings: [
    'Duygusal kontrol ve olgunluk.',
    'Merhametli ve sevgi dolu bir lider veya figür.',
    'Bilgelikle duyguları yönetme yeteneği.',
  ],
  reversedMeanings: [
    'Duygusal manipülasyon, dengesizlik.',
    'Huzursuzluk, duygusal kaçış veya alkolizm.',
    'Huysuz ve değişken bir mizaç.',
  ],
);

// SWORDS SUIT
// ===================================

const TarotLibrary aceOfSwordsCard = TarotLibrary(
  title: 'Ace of Swords',
  description:
      'Zihinsel netliği, yeni fikirleri, atılımları ve gerçeği temsil eder. Zihnin gücü.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/ace_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Zihinsel Netlik, Yeni Fikirler, Atılım.',
    '💼 İş/Kariyer: Yeni bir iş fikri, yasal bir zafer.',
    '💡 Hakikat, Adalet, Zekanın Gücü.',
    '🧠 Berrak Düşünme, Disiplin.',
  ],
  uprightMeanings: [
    'Zihinsel netlik, yeni bir fikrin doğuşu.',
    'Zorlukların üstesinden gelme yeteneği, zafer.',
    'Gerçeği görme ve dürüstlük.',
  ],
  reversedMeanings: [
    'Kafa karışıklığı, yanlış yönlendirilmiş enerji.',
    'Kötü niyet, zalim eleştiri veya yıkım.',
    'Zihinsel yorgunluk ve engeller.',
  ],
);

const TarotLibrary twoOfSwordsCard = TarotLibrary(
  title: 'Two of Swords',
  description:
      'Kararsızlık, çıkmaz, savunma ve kaçınmayı temsil eder. Zor bir seçimden kaçınma.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/two_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Kararsızlık, Çıkmaz, Savunma.',
    '💡 Engellenmiş Duygular, Seçimden Kaçınma.',
    '🧘‍♀️ Denge: İki görüş arasında kalma.',
    '🙅‍♀️ Kör Nokta, Barışçıl Çözüm Arayışı.',
  ],
  uprightMeanings: [
    'Zor bir seçimle yüzleşme veya kararsızlık.',
    'Savunma ve duygusal geri çekilme.',
    'Duygusal gerçekleri görmezden gelme.',
  ],
  reversedMeanings: [
    'Kararsızlığın sona ermesi, eyleme geçme.',
    'Yanlış bilgilerin ortaya çıkması.',
    'Zor bir kararı ertelemenin sonuçları.',
  ],
);

const TarotLibrary threeOfSwordsCard = TarotLibrary(
  title: 'Three of Swords',
  description:
      'Üzüntü, kalp kırıklığı, kayıp ve ihaneti temsil eder. Duygusal acı.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/three_of_swords.jpg',
  meanings: [
    '❤️ Aşk/İlişkiler: Kalp kırıklığı, ayrılık, ihanet.',
    '⚔️ Genel: Kayıp, üzüntü, acı.',
    '💡 Hayal Kırıklığı, Keder, Gözyaşları.',
    '🌧️ İzolasyon, Dışlanma.',
  ],
  uprightMeanings: [
    'Büyük bir kalp kırıklığı ve duygusal acı.',
    'İhanet, ayrılık veya derin bir kayıp.',
    'Hayal kırıklığı yaratan gerçeklerin kabulü.',
  ],
  reversedMeanings: [
    'Acının hafiflemesi, iyileşme süreci.',
    'Eski bir yaradan kurtulma.',
    'Tekrarlanan kalp kırıklığı döngüsünden kaçınma.',
  ],
);

const TarotLibrary fourOfSwordsCard = TarotLibrary(
  title: 'Four of Swords',
  description:
      'Dinlenme, iyileşme, meditasyon ve geri çekilmeyi temsil eder. Eyleme geçmeden önce toparlanma zamanı.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/four_of_swords.jpg',
  meanings: [
    '🧘‍♀️ Sağlık/Ruh: İyileşme, dinlenme, zihinsel detoks.',
    '💼 İş/Kariyer: İşten izin alma, geri çekilme.',
    '💡 Meditasyon, Huzur, Yalnızlık.',
    '⏳ İyileşme Süreci, Durgunluk.',
  ],
  uprightMeanings: [
    'Dinlenme, iyileşme ve zihinsel toparlanma.',
    'Eyleme geçmeden önce iç gözlem yapma.',
    'Sükûnet, sessizlik ve zihinsel huzur.',
  ],
  reversedMeanings: [
    'Acele etme, dinlenmeyi reddetme.',
    'Tükenmişlik, geri çekilmenin uzaması.',
    'Sürekli hareket etme zorunluluğu, huzursuzluk.',
  ],
);

const TarotLibrary fiveOfSwordsCard = TarotLibrary(
  title: 'Five of Swords',
  description:
      'Yenilgi, utanç, boş bir zafer ve kayıp pahasında kazanmayı temsil eder. Herkesin kaybettiği bir çatışma.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/five_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Yenilgi, Utanç, Kayıp, Boş Zafer.',
    '💡 Kötü Kan, Anlaşmazlık, Aşağılama.',
    '🤝 Kazan-Kaybet Durumu, Onur Kaybı.',
    '💔 İlişkilerde Zarar.',
  ],
  uprightMeanings: [
    'Yenilgi veya utanç verici bir kayıp.',
    'Kazanılan ancak herkesin kaybettiği bir zafer.',
    'Anlaşmazlık, kötü niyet veya çatışma.',
  ],
  reversedMeanings: [
    'Çatışmaların sona ermesi, uzlaşma.',
    'Geçmişteki düşmanlıkları bırakma.',
    'Yenilgiden ders çıkarma ve kendini affetme.',
  ],
);

const TarotLibrary sixOfSwordsCard = TarotLibrary(
  title: 'Six of Swords',
  description:
      'Zor bir durumdan uzaklaşmayı, geçişi, iyileşmeyi ve seyahati temsil eder. Daha iyi sulara doğru ilerleme.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/six_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Geçiş, Seyahat, İyileşme.',
    '💡 Uzaklaşma, Zor Durumdan Çıkış.',
    '🌊 Daha İyi Sular, Yavaş Hareket.',
    '🚢 Ulaşım, Yer Değişikliği.',
  ],
  uprightMeanings: [
    'Zor bir durumdan yavaşça uzaklaşma.',
    'Fiziksel veya duygusal bir geçiş dönemi.',
    'İyileşme ve daha iyi bir geleceğe ilerleme.',
  ],
  reversedMeanings: [
    'Geçişte gecikme, kaçınma veya geri dönme.',
    'Eski sorunlara takılı kalma.',
    'Seyahat planlarının iptali.',
  ],
);

const TarotLibrary sevenOfSwordsCard = TarotLibrary(
  title: 'Seven of Swords',
  description:
      'Gizlilik, aldatma, hilekarlık ve bir şeylerden kaçmayı temsil eder. Bir durumu gizlice manipüle etme.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/seven_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Gizlilik, Aldatma, Hilekarlık, Kaçınma.',
    '💡 Kendini Kandırma, Sinsi Davranış, Onursuzluk.',
    '👤 Kayıp, Çalınma, Dürüst Olmama.',
    '🏃‍♀️ Hırsızlık, Risk Alma.',
  ],
  uprightMeanings: [
    'Gizlilik, hilekarlık veya aldatma.',
    'Sorumluluktan kaçma veya bir şeyleri gizlice yapma.',
    'Bir durumu dürüst olmayan yollarla manipüle etme.',
  ],
  reversedMeanings: [
    'Sırların açığa çıkması, dürüstlük.',
    'Hilekarlığı bırakma ve dürüst olma.',
    'Kaybedilen bir şeyi geri alma veya çalınanı bulma.',
  ],
);

const TarotLibrary eightOfSwordsCard = TarotLibrary(
  title: 'Eight of Swords',
  description:
      'Kısıtlanma, kurban rolü, kendini kısıtlama ve engellenmiş hissetmeyi temsil eder. Düşüncelerin hapishanesi.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/eight_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Kısıtlanma, Kurban Rolü, Engellenmişlik.',
    '💡 Kendi Kendini Kısıtlama, Çaresizlik Hissi.',
    '⛓️ Hapishane, Sınırlama, Korkular.',
    '💭 Olumsuz Düşünce Döngüleri.',
  ],
  uprightMeanings: [
    'Kendini kısıtlanmış ve kapana kısılmış hissetme.',
    'Kurban rolü oynama ve çaresizlik.',
    'Olumsuz düşüncelerin yarattığı zihinsel hapishane.',
  ],
  reversedMeanings: [
    'Kısıtlamalardan kurtulma ve özgürleşme.',
    'Kurban rolünü bırakma ve sorumluluk alma.',
    'Yeni bir perspektif kazanma ve engelleri görme.',
  ],
);

const TarotLibrary nineOfSwordsCard = TarotLibrary(
  title: 'Nine of Swords',
  description:
      'Endişe, kabuslar, umutsuzluk ve kaygıyı temsil eder. Gerçekten daha kötü görünen zihinsel bir acı.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/nine_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Endişe, Kabuslar, Umutsuzluk, Kaygı.',
    '💡 Uykusuzluk, Stres, Suçluluk Duygusu.',
    '😨 Korku, Aşırı Düşünme, Depresyon.',
    '🌙 Gece Korkuları, Pişmanlık.',
  ],
  uprightMeanings: [
    'Büyük endişe, kabuslar ve kaygı.',
    'Uykusuzluk ve zihinsel acı.',
    'Gerçekte olduğundan daha kötü görünen bir durum.',
  ],
  reversedMeanings: [
    'Endişelerin azalması ve rahatlama.',
    'Kabusların ve korkuların üstesinden gelme.',
    'Yardım isteme ve toparlanma.',
  ],
);

const TarotLibrary tenOfSwordsCard = TarotLibrary(
  title: 'Ten of Swords',
  description:
      'Ani ve yıkıcı bir son, yenilgi, en kötü senaryo ve bir döngünün acı verici bitişini temsil eder. Ancak aynı zamanda başlangıcı da simgeler.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/ten_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Yıkıcı Son, İhanet, Ağır Kayıp.',
    '💡 En Kötü Senaryo, Yenilgi, Kurban Olma.',
    '💔 Bitirme, Dip Noktası, İyileşme.',
    '🔪 Sona Erme, Dramatik Kriz.',
  ],
  uprightMeanings: [
    'Ani ve yıkıcı bir son, ihanet veya ağır kayıp.',
    'En kötü senaryonun gerçekleşmesi.',
    'Dip noktasına ulaşma ve buradan yeniden başlama zorunluluğu.',
  ],
  reversedMeanings: [
    'Felaketten kurtulma, iyileşme.',
    'Daha kötü bir durumdan kaçınma.',
    'Sonun ertelenmesi veya uzaması.',
  ],
);

const TarotLibrary pageOfSwordsCard = TarotLibrary(
  title: 'Page of Swords',
  description:
      'Yeni fikirleri, merakı, hızlı düşünmeyi ve sözlü iletişimi temsil eder. Bir düşünce habercisi.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/page_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Yeni Fikirler, Merak, İletişim.',
    '💡 Haber: Zihinsel bir meydan okuma, dikkatli bilgi.',
    '👤 Zeki, Canlı, Analitik.',
    '🗣️ Soru Sorma, Öğrenme Arzusu.',
  ],
  uprightMeanings: [
    'Yeni ve canlı fikirlerin gelişi.',
    'Meraklı, zeki ve enerjik bir kişi.',
    'Sınırları zorlayan bir meydan okuma.',
  ],
  reversedMeanings: [
    'Sözlü saldırganlık, dedikodu veya kaba sözler.',
    'Fikirlerin boşa gitmesi, konsantrasyon eksikliği.',
    'Sahte haberler veya yavaş ilerleme.',
  ],
);

const TarotLibrary knightOfSwordsCard = TarotLibrary(
  title: 'Knight of Swords',
  description:
      'Hızlı eylemi, atılganlığı, aceleciliği ve kararlılığı temsil eder. Fevri ve cesur bir eylem.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/knight_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Hızlı Eylem, Acelecilik, Cesaret.',
    '💡 Saldırı, Tartışma, Kararlılık.',
    '🚀 Hız, Fevrilik, Savaşçı Ruh.',
    '💥 Çatışma, Düşüncesiz Hareket.',
  ],
  uprightMeanings: [
    'Hızlı ve kararlı eylem, ileri atılma.',
    'Cesaret ve atılganlık.',
    'Düşüncesizce hareket etme riski.',
  ],
  reversedMeanings: [
    'Gecikme, engellenmiş eylem veya yavaşlık.',
    'Öfke, saldırganlık veya düşüncesiz acelecilik.',
    'Ağız dalaşı veya zorbalık.',
  ],
);

const TarotLibrary queenOfSwordsCard = TarotLibrary(
  title: 'Queen of Swords',
  description:
      'Keskin zekayı, bağımsızlığı, dürüstlüğü ve yargılamayı temsil eder. Duygularını mantıkla ayıran bir figür.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/queen_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Bağımsızlık, Zeka, Dürüstlük, Analiz.',
    '💡 Keskin Zihin, Tarafsızlık, Dul/Ayrılmış Kadın.',
    '🗣️ Açık İletişim, Gerçeği Söyleme.',
    '👑 Mantık, Doğruluk.',
  ],
  uprightMeanings: [
    'Bağımsız, keskin zekalı ve dürüst bir kadın.',
    'Duygusal olmayan, mantıklı karar verme.',
    'Gerçeği net ve doğrudan söyleme.',
  ],
  reversedMeanings: [
    'Zalim eleştiri, soğukluk veya duygusal manipülasyon.',
    'Kibir, kıskançlık veya yalan söyleme.',
    'Duygusuzluk veya aşırı mantıkçılık.',
  ],
);

const TarotLibrary kingOfSwordsCard = TarotLibrary(
  title: 'King of Swords',
  description:
      'Entelektüel otoriteyi, zihinsel disiplini, gücü ve gerçeği temsil eder. Adil ama sert bir yönetici.',
  category: TarotCategory.swords,
  imagePath: 'assets/jpg/king_of_swords.jpg',
  meanings: [
    '⚔️ Genel: Entelektüel Otorite, Disiplin, Güç.',
    '💡 Yasal Konular, Adil Yargılama, Mantık.',
    '👑 Avukat, Hükümet Figürü, Zeki Adam.',
    '⚖️ Keskin Karar Verme.',
  ],
  uprightMeanings: [
    'Entelektüel otorite ve zihinsel berraklık.',
    'Disiplinli, adil ve mantıklı karar verme.',
    'Hukuk veya yasal konularda başarı.',
  ],
  reversedMeanings: [
    'Zalimlik, tiranlık veya haksız yargılama.',
    'Duygusuzluk, yıkıcı eleştiri.',
    'Kötüye kullanılan güç veya entelektüel kafa karışıklığı.',
  ],
);

// PENTACLES SUIT
// ===================================

const TarotLibrary aceOfPentaclesCard = TarotLibrary(
  title: 'Ace of Pentacles',
  description:
      'Yeni bir maddi fırsatı, refahı, istikrarı ve somut bir başlangıcı temsil eder. Maddi bir hediye.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/ace_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Yeni iş fırsatları, maddi kazanç, güvenlik.',
    '💼 İş/Kariyer: Somut bir iş projesi, iyi bir başlangıç.',
    '💡 Refah, İstikrar, Başarı Potansiyeli.',
    '🌱 Fırsat, Büyüme, Topraklanma.',
  ],
  uprightMeanings: [
    'Yeni bir maddi fırsat veya başlangıç.',
    'Bolluk, refah ve maddi güvenlik.',
    'Somut başarı potansiyeli ve istikrar.',
  ],
  reversedMeanings: [
    'Maddi kayıp, fırsatların kaçırılması veya iptali.',
    'Maddi konulara aşırı odaklanma, açgözlülük.',
    'Güvenlik eksikliği veya istikrarsızlık.',
  ],
);

const TarotLibrary twoOfPentaclesCard = TarotLibrary(
  title: 'Two of Pentacles',
  description:
      'Dengeleme, esneklik, öncelikleri yönetme ve hayatın farklı yönlerini idare etmeyi temsil eder.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/two_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Bütçeleri dengeleme, iki gelir kaynağı.',
    '💡 Esneklik, Uyum Sağlama, Öncelikleri Yönetme.',
    '⚖️ Dengeyi Koruma, Değişkenlik.',
    '🔄 Hareket, Akışkanlık.',
  ],
  uprightMeanings: [
    'İki farklı durumu veya sorumluluğu dengeleme.',
    'Hayatın iniş çıkışlarına uyum sağlama.',
    'Öncelikleri yönetme ve esneklik.',
  ],
  reversedMeanings: [
    'Dengesizlik, aşırı yüklenme veya kaybolma.',
    'Maddi kafa karışıklığı, borçlanma.',
    'Önemli bir şeyi ihmal etme.',
  ],
);

const TarotLibrary threeOfPentaclesCard = TarotLibrary(
  title: 'Three of Pentacles',
  description:
      'Ekip çalışması, işbirliği, yeteneklerinizi sergileme ve ustalaşmayı temsil eder. Birlikte mükemmelleşme.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/three_of_pentacles.jpg',
  meanings: [
    '💼 İş/Kariyer: Takım çalışması, ortak proje başarısı, eğitim.',
    '💰 Finans: İşbirliği yoluyla kazanç, projenin onayı.',
    '💡 Ustalaşma, Kalite, Yeteneklerin Sergilenmesi.',
    '🤝 Uyum, Değerlendirme.',
  ],
  uprightMeanings: [
    'Ekip çalışması ve başarılı işbirliği.',
    'Yeteneklerinizin takdir edilmesi ve mükemmelleşme.',
    'Bir projede onay alma ve ilerleme.',
  ],
  reversedMeanings: [
    'Ekip içinde uyumsuzluk, rekabet veya beceriksizlik.',
    'Yanlış danışmanlık, kalitesiz işçilik.',
    'Maddi amaçlar için yetenekleri boşa harcama.',
  ],
);

const TarotLibrary fourOfPentaclesCard = TarotLibrary(
  title: 'Four of Pentacles',
  description:
      'Maddi güvenlik, sahip olma, cimrilik ve kontrolü temsil eder. Elde tutulan mal varlığı.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/four_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Güvenlik, birikim, mülk edinme.',
    '💡 Cimrilik, Kontrol İhtiyacı, Sınır Koyma.',
    '🔒 Sıkı Tutma, Maddi Takıntı.',
    '🏠 Stabilite, Yerleşik Düzen.',
  ],
  uprightMeanings: [
    'Maddi güvenlik, birikim yapma ve stabilite.',
    'Sahiplenme, cimrilik ve kontrol etme ihtiyacı.',
    'Sınırlar koyma ve korunma.',
  ],
  reversedMeanings: [
    'Cimriliği bırakma, cömertlik.',
    'Maddi kayıplar, savurganlık.',
    'Kontrolü kaybetme korkusu, yeni fırsatlara kapalı olma.',
  ],
);

const TarotLibrary fiveOfPentaclesCard = TarotLibrary(
  title: 'Five of Pentacles',
  description:
      'Maddi kayıp, yoksulluk, dışlanma ve sağlık sorunlarını temsil eder. Kendini dışlanmış hissetme.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/five_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Maddi kayıp, yoksulluk, işsizlik.',
    '🧘‍♀️ Sağlık: Hastalık, zayıflık, ihmal.',
    '💡 Dışlanma, Kayıp, Yardım İstemekten Çekinme.',
    '🏚️ Yalnızlık, Güvensizlik.',
  ],
  uprightMeanings: [
    'Maddi kayıp, zorluklar ve güvensizlik.',
    'Kendini dışlanmış, istenmeyen veya yalnız hissetme.',
    'Fırsatları veya yardımı görememe.',
  ],
  reversedMeanings: [
    'Maddi durumun iyileşmesi, yeni bir iş.',
    'Zor bir dönemin sonu, yeniden umutlanma.',
    'Yardım kabul etme ve kendini dahil etme.',
  ],
);

const TarotLibrary sixOfPentaclesCard = TarotLibrary(
  title: 'Six of Pentacles',
  description:
      'Cömertlik, hayırseverlik, verme ve alma dengesini temsil eder. Finansal adalet.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/six_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Hibe, kredi, cömertlik, borç verme.',
    '💡 Denge, Hayırseverlik, Adil Paylaşım.',
    '🤝 Destek Alma/Verme, Finansal Denge.',
    '⚖️ Eşitlik, Karşılıklı Yardımlaşma.',
  ],
  uprightMeanings: [
    'Cömertlik ve hayırseverlik.',
    'Finansal dengenin sağlanması, borçların ödenmesi.',
    'Başkalarından yardım alma veya başkalarına yardım etme.',
  ],
  reversedMeanings: [
    'Eşitsizlik, adaletsizlik veya bencil cömertlik.',
    'Borçların kötü yönetimi, açgözlülük.',
    'Yardımın kötüye kullanılması veya reddedilmesi.',
  ],
);

const TarotLibrary sevenOfPentaclesCard = TarotLibrary(
  title: 'Seven of Pentacles',
  description:
      'Bekleme, değerlendirme, sabır ve yatırımların sonuçlarını bekleme zamanını temsil eder. Emeklerin karşılığını görme.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/seven_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Yatırım, uzun vadeli planlama, bekleme.',
    '💼 İş/Kariyer: Emeklerin karşılığını görme, projenin değerlendirilmesi.',
    '💡 Sabır, Duraksama, Değerlendirme.',
    '🌱 Hasat Bekleyişi, Hayal Kırıklığı.',
  ],
  uprightMeanings: [
    'Emeklerin karşılığını sabırla bekleme.',
    'Yatırımların sonuçlarını değerlendirme.',
    'Bir mola verme ve ilerlemeyi gözden geçirme.',
  ],
  reversedMeanings: [
    'Sabırsızlık, başarısızlık korkusu.',
    'Yatırımların kötü sonuç vermesi.',
    'Hemen sonuç bekleme, aceleci kararlar.',
  ],
);

const TarotLibrary eightOfPentaclesCard = TarotLibrary(
  title: 'Eight of Pentacles',
  description:
      'Zanaat, beceri, çıraklık ve ayrıntılara dikkat etmeyi temsil eder. Kendini geliştirmeye adama.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/eight_of_pentacles.jpg',
  meanings: [
    '💼 İş/Kariyer: Çıraklık, beceri kazanma, detaylara odaklanma.',
    '💡 Konsantrasyon, Çalışkanlık, Ustalık.',
    '💰 Finans: Çalışkanlık yoluyla maddi kazanç.',
    '🛠️ Pratik Uygulama, Kalite.',
  ],
  uprightMeanings: [
    'Beceri, çalışkanlık ve kendini geliştirmeye adama.',
    'Detaylara dikkat etme ve mükemmeliyet.',
    'Bir zanaat veya işte ustalaşma.',
  ],
  reversedMeanings: [
    'Mükemmeliyetçilik, tembellik veya başarısızlık.',
    'Aceleci ve özensiz çalışma.',
    'Maddi amaçlar için becerileri ihmal etme.',
  ],
);

const TarotLibrary nineOfPentaclesCard = TarotLibrary(
  title: 'Nine of Pentacles',
  description:
      'Lüks, kendi kendine yeterlilik, finansal bağımsızlık ve zarafeti temsil eder. Emeklerin karşılığını alma.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/nine_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Finansal bağımsızlık, lüks, sağlam yatırım.',
    '💡 Özgüven, Zarafet, Kendi Kendine Yeterlilik.',
    '🏡 Konfor, Güvenlik, Keyif.',
    '🏆 Başarı, Ödül.',
  ],
  uprightMeanings: [
    'Finansal bağımsızlık ve başarı.',
    'Lüks ve konforun tadını çıkarma.',
    'Özgüven, zarafet ve kendi kendine yetme.',
  ],
  reversedMeanings: [
    'Maddi kayıp, başarısızlık veya savurganlık.',
    'Hırsızlık, güvensizlik.',
    'Başkalarına aşırı bağımlılık.',
  ],
);

const TarotLibrary tenOfPentaclesCard = TarotLibrary(
  title: 'Ten of Pentacles',
  description:
      'Kalıcı serveti, aile mirasını, istikrarı ve uzun vadeli başarıyı temsil eder. Nesiller arası zenginlik.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/ten_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Kalıcı servet, miras, finansal başarı.',
    '🏡 Aile: Aile geleneği, kökler, evde güvenlik.',
    '💡 İstikrar, Başarı, Topluluk.',
    '📜 Miras, Zenginlik.',
  ],
  uprightMeanings: [
    'Kalıcı finansal güvenlik ve servet.',
    'Aile mirası, gelenekler ve kökler.',
    'Uzun vadeli başarı ve istikrar.',
  ],
  reversedMeanings: [
    'Maddi kayıp, aile içi çatışma veya kayıp miras.',
    'Aile ile ilgili sorunlar, güvensizlik.',
    'Finansal risk veya başarısızlık.',
  ],
);

const TarotLibrary pageOfPentaclesCard = TarotLibrary(
  title: 'Page of Pentacles',
  description:
      'Yeni maddi fırsatları, kariyerle ilgili haberleri, öğrenmeyi ve pratik becerileri temsil eder. Maddi bir öğrenci.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/page_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Maddi haberler, yeni iş teklifleri.',
    '💼 İş/Kariyer: Yeni bir beceri öğrenme, eğitim fırsatı.',
    '💡 Haber: Pratik fikirler, odaklanma.',
    '🌱 Potansiyel, Çalışkanlık.',
  ],
  uprightMeanings: [
    'Yeni maddi fırsatlar veya kariyer haberleri.',
    'Öğrenme ve pratik becerileri geliştirme.',
    'Çalışkan ve odaklanmış bir kişi.',
  ],
  reversedMeanings: [
    'Kötü haberler, eğitimde başarısızlık.',
    'Fırsatları kaçırma, savurganlık.',
    'Tembellik veya konsantrasyon eksikliği.',
  ],
);

const TarotLibrary knightOfPentaclesCard = TarotLibrary(
  title: 'Knight of Pentacles',
  description:
      'Sabrı, çalışkanlığı, güvenilirliği ve yavaş ilerlemeyi temsil eder. Garanti edilmiş ama yavaş başarı.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/knight_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Yavaş ama garantili yatırım.',
    '💼 İş/Kariyer: Güvenilir çalışan, düzenli ilerleme.',
    '💡 Sabır, Çalışkanlık, Güvenilirlik.',
    '🐢 Yavaşlık, Pratiklik.',
  ],
  uprightMeanings: [
    'Sabır, çalışkanlık ve güvenilirlik.',
    'Yavaş ama garantili ilerleme ve başarı.',
    'Pratik ve gerçekçi bir yaklaşım.',
  ],
  reversedMeanings: [
    'Tembellik, durgunluk veya sorumsuzluk.',
    'İlerlemede gecikmeler, işleri ağırdan alma.',
    'Sıkıcılık ve vizyon eksikliği.',
  ],
);

const TarotLibrary queenOfPentaclesCard = TarotLibrary(
  title: 'Queen of Pentacles',
  description:
      'Cömertlik, annelik, pratiklik ve maddi güvenliği temsil eder. Besleyici ve başarılı bir figür.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/queen_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Finansal olarak güvenli, cömert kadın.',
    '🏡 Aile: Anaç, besleyici, evde konfor.',
    '💡 Pratiklik, Cömertlik, Rahatlık.',
    '👑 Ev Sahibi, Girişimci.',
  ],
  uprightMeanings: [
    'Cömert, pratik ve besleyici bir kadın.',
    'Maddi güvenlik ve evde konfor.',
    'Başarıyı ve aileyi dengeleme.',
  ],
  reversedMeanings: [
    'Maddi güvensizlik, bencillik veya ihmalkarlık.',
    'Aşırı sahiplenme veya kaygılı olma.',
    'Kötü finansal yönetim.',
  ],
);

const TarotLibrary kingOfPentaclesCard = TarotLibrary(
  title: 'King of Pentacles',
  description:
      'Maddi başarı, iş zekası, istikrar ve gücü temsil eder. Başarılı bir iş adamı veya yönetici.',
  category: TarotCategory.pentacles,
  imagePath: 'assets/jpg/king_of_pentacles.jpg',
  meanings: [
    '💰 Finans: Zengin, başarılı, güvenilir yatırımcı.',
    '💼 İş/Kariyer: İş adamı, yönetici, maddi istikrar.',
    '💡 Güvenilirlik, Lüks, İş Zekası.',
    '👑 Zenginlik, Başarı, Cömertlik.',
  ],
  uprightMeanings: [
    'Maddi başarı, zenginlik ve istikrar.',
    'Güvenilir, başarılı bir lider veya figür.',
    'Finansal güvenlik ve cömertlik.',
  ],
  reversedMeanings: [
    'Açgözlülük, müsriflik veya finansal başarısızlık.',
    'Yolsuzluk, inatçılık veya materyalizm.',
    'Güvenilmezlik ve otoriterlik.',
  ],
);

// WANDS SUIT
// ===================================

const TarotLibrary aceOfWandsCard = TarotLibrary(
  title: 'Ace of Wands',
  description:
      'Yaratıcılığın, yeni bir girişimin veya ilham verici bir fikrin başlangıcını simgeler. Enerji ve tutku dolu bir dönem.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/ace_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Yeni iş fırsatları, kariyerde atılım, yaratıcı projeler.',
    '❤️ Aşk/İlişkiler: İlişkiye giren yeni bir heyecan, tutku veya enerjik bir başlangıç.',
    '💰 Finans/Sağlık: Artan enerji ve canlılık, maddi konularda yeni bir girişimde bulunma cesareti.',
    '💡 İlham, Heyecan Verici Yeni Bir Fikir, Potansiyelin Ortaya Çıkışı.',
  ],
  uprightMeanings: [
    'Yeni başlangıçlar, ilham ve keşfetme arzusu.',
    'Büyük bir enerji ve hareketlilik döneminin kapısı.',
    'Girişimde bulunma cesareti, tutku ve coşku.',
  ],
  reversedMeanings: [
    'Projelerde gecikmeler, engeller veya ilham eksikliği.',
    'Tükenmişlik, erteleme veya yanlış yönlendirilmiş enerji.',
    'Yeni fırsatları görememek veya değerlendirememek.',
  ],
);

const TarotLibrary twoOfWandsCard = TarotLibrary(
  title: 'Two of Wands',
  description:
      'Planlama, ilerleme, geleceği düşünme ve cesur kararlar almayı temsil eder. Dünya ile birleşme.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/two_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Planlama, ortaklık kurma, geleceğe bakma.',
    '💡 Cesaret, Bireysellik, Keşfetme Arzusu.',
    '🌍 Genişleme, Küresel Fırsatlar, Karar Verme.',
    '🤝 Kontrol, İlerleme.',
  ],
  uprightMeanings: [
    'Geleceği planlama ve ilerlemeye hazırlanma.',
    'Cesur kararlar alma ve yeni fırsatları keşfetme.',
    'Başarı potansiyeli ve kontrol.',
  ],
  reversedMeanings: [
    'Korku, ilerlemede gecikmeler veya engeller.',
    'Planların başarısız olması, aşırı temkinli olma.',
    'İlerlemek için isteksizlik.',
  ],
);

const TarotLibrary threeOfWandsCard = TarotLibrary(
  title: 'Three of Wands',
  description:
      'Uzun vadeli vizyon, genişleme, fırsatlar ve sağlam temeller üzerinde ilerlemeyi temsil eder. Başarının ilk aşaması.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/three_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Ticaret, ihracat, ortaklıkta büyüme.',
    '💡 Vizyon, Gelecek Planları, Genişleme.',
    '🚢 Ufuk, Başlangıç Başarısı, Ortaklık.',
    '⏳ Uzun Vadeli Bakış.',
  ],
  uprightMeanings: [
    'Uzun vadeli vizyon ve planların gerçekleşmesi.',
    'Genişleme, uluslararası fırsatlar.',
    'Sağlam temeller üzerinde ilerleme ve başarı.',
  ],
  reversedMeanings: [
    'Gecikme, ihanet veya hayal kırıklığı.',
    'Fırsatları kaçırma, engeller.',
    'Vizyon eksikliği veya karamsarlık.',
  ],
);

const TarotLibrary fourOfWandsCard = TarotLibrary(
  title: 'Four of Wands',
  description:
      'Kutlama, uyum, istikrar ve yuva kurmayı simgeler. Başarılı bir dönemin ardından gelen huzur.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/four_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Bir projenin başarıyla tamamlanması ve kutlama.',
    '❤️ Aşk/İlişkiler: Evlilik, nişan, evde huzur ve mutluluk.',
    '💰 Finans/Sağlık: Maddi istikrarın keyfini çıkarma, sağlığın iyi olması.',
    '💡 Güvenlik, Uyum, Topluluk İçinde Kutlama.',
  ],
  uprightMeanings: [
    'Eve dönüş, yuva hissi ve mutluluk.',
    'Başarı ve istikrarın kutlanması.',
    'Uyum, topluluk ve güvenli bir liman.',
  ],
  reversedMeanings: [
    'Geçici istikrarsızlık veya huzursuzluk.',
    'Kutlamaların ertelenmesi veya aile içi uyumsuzluk.',
    'Planlanan etkinliğin başarısızlıkla sonuçlanması.',
  ],
);

const TarotLibrary fiveOfWandsCard = TarotLibrary(
  title: 'Five of Wands',
  description:
      'Küçük çatışmaları, rekabeti veya enerjilerin birbiriyle çakışmasını temsil eder. Bu genellikle yapıcı bir mücadeledir.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/five_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Ofis içi rekabet, fikir çatışmaları, yaratıcı gerginlik.',
    '❤️ Aşk/İlişkiler: Eğlenceli ama yorucu tartışmalar, küçük anlaşmazlıklar.',
    '💰 Finans/Sağlık: Enerjinin dağılması, odaklanma sorunları.',
    '💡 Çeşitli Görüşlerin Çarpışması, Dostça Rekabet.',
  ],
  uprightMeanings: [
    'Rekabet ve mücadele, ancak genellikle yapıcı sonuçlar doğurur.',
    'Grup içinde fikir ayrılıkları ve farklı yaklaşımlar.',
    'Enerjiyi doğru bir hedefe yönlendirme ihtiyacı.',
  ],
  reversedMeanings: [
    'Çatışmalardan kaçınma veya bastırılmış anlaşmazlıklar.',
    'Sonuca varmayan anlamsız çekişmeler ve huzursuzluk.',
    'Bir sorunu çözmek için enerjiyi birleştirememe.',
  ],
);

const TarotLibrary sixOfWandsCard = TarotLibrary(
  title: 'Six of Wands',
  description:
      'Zafer, halk önünde tanınma, başarı ve özgüveni temsil eder. Bir zorluğun ardından gelen onur.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/six_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Başarı, terfi, halk önünde takdir.',
    '💡 Zafer, Özgüven, Tanınma, Haber.',
    '🏆 Başarıyı Kutlama, İyi Haber.',
    '🏇 İlerleme, Motivasyon.',
  ],
  uprightMeanings: [
    'Halk önünde zafer ve tanınma.',
    'Başarı, özgüven ve olumlu sonuçlar.',
    'İyi haberlerin alınması ve motivasyon.',
  ],
  reversedMeanings: [
    'Gecikme, başarısızlık veya utanç.',
    'Özgüven eksikliği, kötü haber.',
    'Elde edilen başarının geçici olması.',
  ],
);

const TarotLibrary sevenOfWandsCard = TarotLibrary(
  title: 'Seven of Wands',
  description:
      'Meydan okuma, rekabet, cesaret ve kendinizi savunmayı temsil eder. Zorluklara karşı ayakta durma.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/seven_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Rekabet, saldırılar, savunma.',
    '💡 Meydan Okuma, Cesaret, Kendini Savunma.',
    '⛰️ Üstünlük, Başarısızlığa Direnme.',
    '⚔️ Güçlü Pozisyon, Direniş.',
  ],
  uprightMeanings: [
    'Meydan okumalara ve rekabete karşı kendinizi savunma.',
    'Cesaret ve azimle ayakta durma.',
    'Üstün bir pozisyonda olma ve direnme.',
  ],
  reversedMeanings: [
    'Vazgeçme, korkaklık veya teslim olma.',
    'Güven eksikliği, yenilgi.',
    'Aşırı savunmacı veya gergin olma.',
  ],
);

const TarotLibrary eightOfWandsCard = TarotLibrary(
  title: 'Eight of Wands',
  description:
      'Hızlı hareket, olayların hızlanması ve ani haberleşmeyi simgeler. Durumlar beklenenden daha hızlı gelişebilir.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/eight_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Projelerin hızlı tamamlanması, acil haberler veya hızlı gelişmeler.',
    '❤️ Aşk/İlişkiler: Bir ilişkinin aniden hızlanması, hızlı duygusal iletişim.',
    '💰 Finans/Sağlık: Önemli bir kararın hızla verilmesi gerekliliği, ani iyileşmeler.',
    '💡 Hareket, Seyahat, Hızlı Eylem.',
  ],
  uprightMeanings: [
    'Eylemin hızı, hızlı ilerleme ve olayların hızlanması.',
    'Tüm engellerin kalkması ve hedefe doğru serbest akış.',
    'Haberleşme ve seyahatle ilgili müjdeler.',
  ],
  reversedMeanings: [
    'Gecikmeler, hayal kırıklığı yaratan yavaşlama veya engellenmiş ilerleme.',
    'Sabırsızlık ve aceleci kararlar sonucu hatalar.',
    'İletişim kopuklukları veya yanlış yönlendirilmiş enerji.',
  ],
);

const TarotLibrary nineOfWandsCard = TarotLibrary(
  title: 'Nine of Wands',
  description:
      'Dayanıklılık, cesaret ve son bir engelin üstesinden gelme yeteneğini temsil eder. Yorulmuş ama hazır olma durumu.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/nine_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Projenin son aşamasına gelme, son bir direniş.',
    '❤️ Aşk/İlişkiler: İlişkide savunmacı veya şüpheci olma.',
    '💰 Finans/Sağlık: İyileşme sürecinde sabır gösterme, maddi zorluklara karşı direnme.',
    '💡 Son Bir Duruş, İçsel Güç, Sınırları Koruma.',
  ],
  uprightMeanings: [
    'Direniş, cesaret ve tükenmeye yakın bile olsa vazgeçmeme.',
    'Son bir meydan okumaya hazırlanma ve sınırları koruma.',
    'Deneyimlerden ders alma ve bilgeliği kullanma.',
  ],
  reversedMeanings: [
    'Paranoya, aşırı savunmacı olma veya güvensizlik.',
    'Yorgunluğa yenik düşme ve mücadeleden vazgeçme.',
    'Geçmiş yaralardan kurtulamama, enerjiyi boşa harcama.',
  ],
);

const TarotLibrary tenOfWandsCard = TarotLibrary(
  title: 'Ten of Wands',
  description:
      'Aşırı yüklenme, sorumluluk, baskı ve ağırlık altında kalmayı temsil eder. Yükü bırakma zamanı.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/ten_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Aşırı iş yükü, stres, sorumluluk.',
    '💡 Baskı, Yük, Bitkinlik.',
    '🚶 Yükü Bırakma İhtiyacı, Görev Bilinci.',
    '😔 Tükenmişlik, Stres.',
  ],
  uprightMeanings: [
    'Aşırı yüklenme, sorumluluk ve baskı altında kalma.',
    'Tükenmişlik ve stresin artması.',
    'Taşıdığınız yükü bırakma ihtiyacı.',
  ],
  reversedMeanings: [
    'Yükü hafifletme, rahatlama.',
    'Sorumluluktan kaçınma veya kaybetme.',
    'Bir projenin sonuna ulaşma ve serbest kalma.',
  ],
);

const TarotLibrary pageOfWandsCard = TarotLibrary(
  title: 'Page of Wands',
  description:
      'Heyecan verici haberleri, başlangıçları, coşkuyu ve maceraperest bir ruhu temsil eder. Enerjik bir haberci.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/page_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Yeni bir fırsat haberi, ilham verici fikir.',
    '💡 Coşku, Maceraperest Ruh, Başlangıç Potansiyeli.',
    '🗣️ Enerjik İletişim, İyi Haber.',
    '🤸 Harekete Geçme, Keşif.',
  ],
  uprightMeanings: [
    'Yeni, heyecan verici haberler veya fırsatlar.',
    'Coşku, yaratıcılık ve macera arzusu.',
    'Yeni bir yola başlama potansiyeli.',
  ],
  reversedMeanings: [
    'Kötü haberler, gecikmeler veya engeller.',
    'Coşku eksikliği, kararsızlık.',
    'Yanlış bilgilendirme veya söylentiler.',
  ],
);

const TarotLibrary knightOfWandsCard = TarotLibrary(
  title: 'Knight of Wands',
  description:
      'Hızlı, dürtüsel ve maceraperest bir eylem çağrısını temsil eder. Çoğu zaman bir yolculuk veya ani bir gidişi simgeler.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/knight_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Hızlı bir iş teklifi veya kariyerde ani bir değişiklik.',
    '❤️ Aşk/İlişkiler: Hızlı gelişen, tutkulu ama kalıcı olmayan bir ilişki.',
    '💰 Finans/Sağlık: Riskli yatırımlar, dikkatsizlik sonucu kazalar.',
    '💡 Maceraperest, Hevesli, Fevri ve Gözüpek.',
  ],
  uprightMeanings: [
    'Hızlı ve coşkulu eylem, macera arayışı.',
    'Büyük bir enerji patlaması ve tutkuyla ilerleme.',
    'Bir yere gitme veya önemli bir olayın yaklaştığı haberi.',
  ],
  reversedMeanings: [
    'Gecikme, hayal kırıklığı ve öfke patlamaları.',
    'Acelecilik, düşüncesizlik ve eylemlerin sonuçlarını düşünmeme.',
    'Sözünde duramama, plansız ayrılışlar veya geri çekilme.',
  ],
);

const TarotLibrary queenOfWandsCard = TarotLibrary(
  title: 'Queen of Wands',
  description:
      'Cazibe, kendine güven, cesaret ve yaratıcılığı temsil eder. Enerjik ve popüler bir figür.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/queen_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Girişimci, yaratıcı lider, popülerlik.',
    '💡 Kendine Güven, Neşe, Cazibe.',
    '👑 Enerjik, Cesur, Bağımsız.',
    '🤝 Dostluk, Sosyallik.',
  ],
  uprightMeanings: [
    'Kendine güvenen, enerjik ve yaratıcı bir kadın.',
    'Cazibe ve popülerlik, başkalarına ilham verme.',
    'Güçlü bir sosyal çevre ve dostluk.',
  ],
  reversedMeanings: [
    'Kıskançlık, huysuzluk veya talepkarlık.',
    'Egoizm, kendini beğenmişlik.',
    'Yaratıcılıkta tıkanma, kendine güvensizlik.',
  ],
);

const TarotLibrary kingOfWandsCard = TarotLibrary(
  title: 'King of Wands',
  description:
      'Karizmatik, vizyoner ve enerjik bir lideri temsil eder. Yaratıcılık, girişimcilik ve doğal otoriteyi simgeler.',
  category: TarotCategory.wands,
  imagePath: 'assets/jpg/king_of_wands.jpg',
  meanings: [
    '🔥 İş/Kariyer: Güçlü bir lider, vizyon sahibi bir patron veya girişimci.',
    '❤️ Aşk/İlişkiler: Tutkulu, coşkulu ve dominant bir partner.',
    '💰 Finans/Sağlık: Finansal risk alma isteği, güçlü bir yaşam enerjisi.',
    '💡 Otorite, İlham Verici, Dürüst ve Onurlu Kişi.',
  ],
  uprightMeanings: [
    'Doğal liderlik, özgüven ve çekicilik.',
    'Büyük vizyonları gerçeğe dönüştürme yeteneği.',
    'Eylem adamı olma ve güçlü bir tutkuyla hareket etme.',
  ],
  reversedMeanings: [
    'Zorba, aşırı talepkar veya diktatörce davranışlar.',
    'Kendi kendini sabote etme, vizyon eksikliği veya amaçsızlık.',
    'İlerlemeyi engelleyen hoşgörüsüzlük veya acelecilik.',
  ],
);
