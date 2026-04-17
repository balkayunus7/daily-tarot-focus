class AppRoutes {
  AppRoutes._();

  /// Auth not required routes
  static const Set<String> publicRoutes = {
    AppRoutes.splash,
  };

  /// Auth required routes
  static const Set<String> registerRoutes = {
    AppRoutes.registerStepZodiac,
    AppRoutes.registerStepRelationship,
    AppRoutes.registerStepCareer,
  };

  // Auth routes
  static const String splash = '/';
  static const String registerStepZodiac = '/register-step-zodiac';
  static const String registerStepRelationship = '/register-step-relationship';
  static const String registerStepCareer = '/register-step-career';

  // Tarot explore
  static const String tarotExplore = '/tarot-explore';

  // Tarot reveal
  static const String tarotReveal = '/tarot-reveal';
  static const String tarotRevealDetail = '/tarot-reveal-detail';

  // Tarot Deck
  static const String tarotDeck = '/tarot-deck';
  static const String tarotDeckDetail = '/tarot-deck-detail';

  // Tarot question (soru sorma & cevap)
  static const String tarotQuestion = '/tarot-question';
  static const String tarotSpreadSelect = '/tarot-spread-select';
  static const String tarotQuestionCardSelect = '/tarot-question-card-select';
  static const String tarotReading = '/tarot-question-answer';

  // Tarot daily
  static const String tarotDailyDetail = '/tarot-daily-detail';

  // Subscription
  static const String subscriptionPaywall = '/subscription-paywall';

  // Settings
  static const String settings = '/settings';
}
