import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/zodiac_compatibility_model.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_compatibility/pages/zodiac_compatibility_input_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin ZodiacCompatibilityPageMixin on State<TarotCompatibilityInputPage> {
  late ValueNotifier<ZodiacSign> mySign;
  late ValueNotifier<ZodiacSign> partnerSign;
  late ValueNotifier<CompatGender> myGender;
  late ValueNotifier<CompatGender> partnerGender;
  static const List<ZodiacSign> signs = ZodiacSign.values;
  late final PageController myPageController;
  late final PageController partnerPageController;
  late double myCurrentPage;
  late double partnerCurrentPage;

  ValueNotifier<ZodiacSign> getSignNotifier({required bool isMe}) {
    return isMe ? mySign : partnerSign;
  }

  ValueNotifier<CompatGender> getGenderNotifier({required bool isMe}) {
    return isMe ? myGender : partnerGender;
  }

  PageController getPageController({required bool isMe}) {
    return isMe ? myPageController : partnerPageController;
  }

  double getCurrentPage({required bool isMe}) {
    return isMe ? myCurrentPage : partnerCurrentPage;
  }

  void _onMyScroll() {
    if (!mounted) return;
    setState(() => myCurrentPage = myPageController.page ?? myCurrentPage);
    mySign.value = signs[(myPageController.page?.round() ?? myCurrentPage.round()) % 12];
  }

  void _onPartnerScroll() {
    if (!mounted) return;
    setState(() => partnerCurrentPage = partnerPageController.page ?? partnerCurrentPage);
    partnerSign.value =
        signs[(partnerPageController.page?.round() ?? partnerCurrentPage.round()) % 12];
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.userOrCrash;
    final sign = (user is TarotUser ? user.zodiac : null) ?? ZodiacSign.aries;
    mySign = ValueNotifier(sign);
    partnerSign = ValueNotifier(ZodiacSign.values[(sign.index + 6) % ZodiacSign.values.length]);
    myGender = ValueNotifier(CompatGender.female);
    partnerGender = ValueNotifier(CompatGender.male);
    final partnerInitialPage = (sign.index + 6) % ZodiacSign.values.length;
    myPageController = PageController(initialPage: sign.index, viewportFraction: 1 / 3);
    partnerPageController = PageController(
      initialPage: partnerInitialPage,
      viewportFraction: 1 / 3,
    );
    myCurrentPage = sign.index.toDouble();
    partnerCurrentPage = partnerInitialPage.toDouble();
    myPageController.addListener(_onMyScroll);
    partnerPageController.addListener(_onPartnerScroll);
  }

  @override
  void dispose() {
    mySign.dispose();
    partnerSign.dispose();
    myGender.dispose();
    partnerGender.dispose();
    myPageController
      ..removeListener(_onMyScroll)
      ..dispose();
    partnerPageController
      ..removeListener(_onPartnerScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> calculate() async {
    final result = CompatibilityResult.calculate(mySign.value, partnerSign.value);
    final input = CompatibilityInputModel(
      mySign: mySign.value,
      myGender: myGender.value,
      partnerSign: partnerSign.value,
      partnerGender: partnerGender.value,
    );
    await context.push(AppRoutes.tarotCompatibilityResult, extra: (input, result));
  }
}
