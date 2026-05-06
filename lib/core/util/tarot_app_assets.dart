enum TarotAppAssets {
  /////SVG///////////////////////
  card._('assets/svg/card.svg'),
  crown._('assets/svg/crown.svg'),
  explore._('assets/svg/explore.svg'),
  doubleArrow._('assets/svg/double_arrow.svg'),
  settings._('assets/svg/settings.svg'),
  tarotIcon._('assets/svg/tarot.svg'),
  shiningStars._('assets/json/shining_stars.json'),
  tarot._('assets/json/tarot.json'),
  cardsThree._('assets/svg/cards-three.svg'),
  moonStars._('assets/svg/moon-stars.svg'),
  heartHalf._('assets/svg/heart-half.svg'),
  handCoins._('assets/svg/hand-coins.svg'),
  chartLine._('assets/svg/chart-line.svg'),
  asclepius._('assets/svg/asclepius.svg'),
  babyIcon._('assets/svg/baby.svg'),
  male._('assets/svg/male.svg'),
  female._('assets/svg/female.svg'),
  nonBinary._('assets/svg/non_binary.svg');

  const TarotAppAssets._(this.path);
  final String path;

  /////HTTP///////////////////////
  static const _base =
      'https://wcokelgolrodijdxtvjn.supabase.co/storage/v1/object/public/app-images/backgrounds';

  static const arrowHttp = '$_base/arrow.png';
  static const askQuestionHttp = '$_base/ask_question.png';
  static const cardBgHttp = '$_base/card_bg.png';
  static const dailyPickBgHttp = '$_base/daily_pick_bg.png';
  static const emptyHttp = '$_base/empty.png';
  static const libraryHttp = '$_base/library.png';
  static const maskotDailyHttp = '$_base/maskot_daily.png';
  static const paywallHttp = '$_base/paywall.png';
}
