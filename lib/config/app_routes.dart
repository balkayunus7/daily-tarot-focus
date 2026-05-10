class AppRoutes {
  AppRoutes._();

  /// Auth not required
  static const Set<String> publicRoutes = {
    AppRoutes.splash,
  };

  /// Auth required
  static const Set<String> registerRoutes = {
    AppRoutes.registerStepZodiac,
    AppRoutes.registerStepRelationship,
    AppRoutes.registerStepCareer,
  };

  // Auth
  static const String splash = '/';
  static const String registerStepZodiac = '/register-step-zodiac';
  static const String registerStepRelationship = '/register-step-relationship';
  static const String registerStepCareer = '/register-step-career';
  static const String accountSetup = '/account-created';

  // Tarot Explore
  static const String tarotExplore = '/tarot-explore';

  // Tarot Reveal
  static const String tarotReveal = '/tarot-reveal';
  static const String tarotRevealDetail = '/tarot-reveal-detail';

  // Tarot Deck
  static const String tarotDeck = '/tarot-deck';
  static const String tarotDeckDetail = '/tarot-deck-detail';

  // Tarot Question
  static const String tarotQuestionStep1 = '/tarot-question-step-1';
  static const String tarotQuestionStep2 = '/tarot-question-step-2';
  static const String tarotQuestionStep3 = '/tarot-question-step-3';
  static const String tarotQuestionStep4 = '/tarot-question-step-4';
  static const String tarotQuestionStep5 = '/tarot-question-step-5';
  static const String tarotQuestionStep6 = '/tarot-question-step-6';
  static const String tarotReadingLoading = '/tarot-reading-loading';
  static const String tarotReadingAnswer = '/tarot-reading-answer';

  // Tarot daily
  static const String tarotDailyCalendar = '/tarot-daily-calendar';
  static const String tarotDailyDetail = '/tarot-daily-detail';
  static const String tarotSavedReadingDetail = '/tarot-saved-reading-detail';

  // Tarot Zodiac
  static const String tarotZodiacDetail = '/tarot-zodiac-detail';

  // Zodiac Horoscope
  static const String zodiacHoroscope = '/zodiac-horoscope';

  // Tarot Compatibility
  static const String tarotCompatibilityInput = '/tarot-compatibility-input';
  static const String tarotCompatibilityResult = '/tarot-compatibility-result';

  // Answer Book
  static const String answerBook = '/answer-book';

  // Numerology
  static const String numerologyInput = '/numerology-input';
  static const String numerologyResult = '/numerology-result';

  // Subscription
  static const String subscriptionPaywall = '/subscription-paywall';

  // Settings
  static const String settings = '/settings';
}
