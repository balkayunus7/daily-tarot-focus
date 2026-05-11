import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/config/restartable_app.dart';
import 'package:daily_tarot_focus/core/util/locale_extensions.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac/zodiac_bloc.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_request_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin ZodiacCompatibilityPageMixin<T extends StatefulWidget> on State<T>, TickerProvider {
  /// Input Page
  late ValueNotifier<ZodiacSign> mySign;
  late ValueNotifier<ZodiacSign> partnerSign;
  late ValueNotifier<CompatGender> myGender;
  late ValueNotifier<CompatGender> partnerGender;
  static const List<ZodiacSign> signs = ZodiacSign.values;
  late final PageController myPageController;
  late final PageController partnerPageController;
  late double myCurrentPage;
  late double partnerCurrentPage;

  /// Result Page
  late final ValueNotifier<bool> isExpanded;
  late final AnimationController animController;
  late final Animation<double> expandAnimation;

  ValueNotifier<ZodiacSign> getSignNotifier({required bool isMe}) => isMe ? mySign : partnerSign;

  ValueNotifier<CompatGender> getGenderNotifier({required bool isMe}) =>
      isMe ? myGender : partnerGender;

  PageController getPageController({required bool isMe}) =>
      isMe ? myPageController : partnerPageController;

  double getCurrentPage({required bool isMe}) => isMe ? myCurrentPage : partnerCurrentPage;

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

    isExpanded = ValueNotifier(false);
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    expandAnimation = CurvedAnimation(parent: animController, curve: Curves.easeInOut);
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
    isExpanded.dispose();
    animController.dispose();
    super.dispose();
  }

  GenerateCompatibilityRequestModel buildRequest() {
    final session = context.read<AuthCubit>().state.sessionOrCrash;
    return GenerateCompatibilityRequestModel(
      session: session,
      mySign: mySign.value,
      myGender: myGender.value,
      partnerSign: partnerSign.value,
      partnerGender: partnerGender.value,
      locale: context.currentLocaleLanguage.value,
    );
  }

  void calculate() =>
      context.read<ZodiacBloc>().addGenerateCompatibilityRequested(request: buildRequest());

  Widget wrapWithRestartListener(BuildContext context, Widget child) {
    return BlocListener<TarotBloc, TarotState>(
      listenWhen:
          (p, c) => p.clearCacheFailureOrUnit.isNone() && c.clearCacheFailureOrUnit.isSome(),
      listener: (ctx, _) async {
        if (ctx.canPop()) ctx.pop();
        if (!ctx.mounted) return;
        ctx.go(AppRoutes.splash);
        if (!ctx.mounted) return;
        await RestartableApp.restartApp(ctx);
      },
      child: child,
    );
  }
}
