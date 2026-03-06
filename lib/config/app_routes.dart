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
    AppRoutes.registerStepBirthdate,
  };

  // Auth routes
  static const String splash = '/';
  static const String registerStepZodiac = '/register-step-zodiac';
  static const String registerStepRelationship = '/register-step-relationship';
  static const String registerStepBirthdate = '/register-step-birthdate';

  // Tarot explore
  static const String tarotExplore = '/tarot-explore';

  // Tarot reveal
  static const String tarotReveal = '/tarot-reveal';
  static const String tarotRevealDetail = '/tarot-reveal-detail';

  // Tarot library
  static const String tarotLibrary = '/tarot-library';
  static const String tarotLibraryDetail = '/tarot-library-detail';

  // Tarot question (soru sorma & cevap)
  static const String tarotQuestion = '/tarot-question';
  static const String tarotQuestionAnswer = '/tarot-question-answer';

  // Settings
  static const String settings = '/settings';
}
