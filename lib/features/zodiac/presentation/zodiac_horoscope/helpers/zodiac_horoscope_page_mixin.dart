part of '../pages/zodiac_horoscope_page.dart';

mixin ZodiacHoroscopePageMixin on State<ZodiacHoroscopePage>, TickerProvider {
  late final TabController tabController;
  // Category Tile Expand Logic
  late final ValueNotifier<bool> isExpanded;
  late final AnimationController animController;
  late final Animation<double> expandAnimation;

  late int _currentIndex;
  bool _horoscopeRequested = false;
  String? _lastRequestedLocale;

  /// Horoscope Categories
  final List<(String, String)> cats = [
    ('❤️', LocaleKeys.horoscope_page_category_love),
    ('💰', LocaleKeys.horoscope_page_category_finance),
    ('💼', LocaleKeys.horoscope_page_category_career),
    ('🩺', LocaleKeys.horoscope_page_category_health),
    ('🏠', LocaleKeys.horoscope_page_category_family),
  ];

  Future<void> toggle() async {
    isExpanded.value = !isExpanded.value;
    if (isExpanded.value) {
      await animController.forward();
    } else {
      await animController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 2);
    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _currentIndex,
    );

    isExpanded = ValueNotifier(false);
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    expandAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeInOut,
    );

    tabController.addListener(onTabChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.currentLocaleLanguage.value;
    if (_horoscopeRequested && _lastRequestedLocale == locale) return;
    _horoscopeRequested = true;
    _lastRequestedLocale = locale;
    generateHoroscope(HoroscopePeriod.values[tabController.index]);
  }

  void onTabChanged() {
    if (_currentIndex == tabController.index) return;
    _currentIndex = tabController.index;
    generateHoroscope(HoroscopePeriod.values[_currentIndex]);
  }

  void generateHoroscope(HoroscopePeriod period) {
    final session = context.read<AuthCubit>().state.sessionOrCrash;
    context.read<ZodiacBloc>().addGenerateHoroscopeRequested(
      request: GenerateHoroscopeRequestModel(
        session: session,
        sign: widget.sign,
        period: period,
        locale: context.currentLocaleLanguage.value,
      ),
    );
  }

  @override
  void dispose() {
    tabController
      ..removeListener(onTabChanged)
      ..dispose();
    isExpanded.dispose();
    animController.dispose();
    super.dispose();
  }
}
