part of '../pages/tarot_explore_page.dart';

mixin ExplorePageStateMixin on State<TarotExplorePage> {
  late final ValueNotifier<int> selected;

  int get selectedIndex => selected.value;
  bool get isTarotTab => selected.value == 0;
  bool get isHoroscopeTab => selected.value == 1;
  set setIndex(int value) => selected.value = value;

  @override
  void initState() {
    selected = ValueNotifier(0);
    super.initState();
  }

  @override
  void dispose() {
    selected.dispose();
    super.dispose();
  }
}
