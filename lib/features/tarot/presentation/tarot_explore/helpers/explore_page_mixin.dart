part of '../pages/tarot_explore_page.dart';

mixin ExplorePageStateMixin on State<TarotExplorePage> {
  late final ValueNotifier<int> selected;

  int get selectedIndex => selected.value;
  bool get isPlanetaryTab => selected.value == 0;
  bool get isCardsInsightsTab => selected.value == 1;
  set setIndex(int value) => selected.value = value;

  /// Horoscope Card
  late final PageController horoscopeCardPageController;
  late final ValueNotifier<int> currHoroscopeCardPage;
  List<HoroscopePeriod> get periods => HoroscopePeriod.values;

  void _onScroll() {
    final page = horoscopeCardPageController.page?.round() ?? 0;
    if (page != currHoroscopeCardPage.value) {
      currHoroscopeCardPage.value = page;
    }
  }

  Future<void> navigateToHoroscopePage(BuildContext context, ZodiacSign sign) async {
    await context.pushNamed<void>(
      AppRoutes.zodiacHoroscope,
      queryParameters: {'sign': sign.value, 'initialIndex': currHoroscopeCardPage.value.toString()},
    );
  }

  @override
  void initState() {
    selected = ValueNotifier(0);

    // Horoscope Card
    horoscopeCardPageController = PageController();
    horoscopeCardPageController.addListener(_onScroll);
    currHoroscopeCardPage = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  void dispose() {
    selected.dispose();

    // Horoscope Card
    horoscopeCardPageController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }
}
