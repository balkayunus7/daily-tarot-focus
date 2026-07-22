import 'dart:async';

import 'package:daily_tarot_focus/core/util/locale_extensions.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/pages/tarot_spread_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin LoadingPageMixin on State<TarotSpreadLoadingPage> {
  List<String> get loadingMessages => [
    LocaleKeys.tarot_question_loading_message_1.tr(),
    LocaleKeys.tarot_question_loading_message_2.tr(),
    LocaleKeys.tarot_question_loading_message_3.tr(),
    LocaleKeys.tarot_question_loading_message_4.tr(),
  ];

  final ValueNotifier<int> messageIndex = ValueNotifier(0);
  Timer? _timer;
  bool _readingRequested = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      messageIndex.value = (messageIndex.value + 1) % loadingMessages.length;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_readingRequested) return;
    _readingRequested = true;
    final session = context.read<AuthCubit>().state.sessionOrCrash;
    context.read<TarotBloc>().addGenerateReadingRequested(
      session: session,
      locale: context.currentLocaleLanguage.value,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    messageIndex.dispose();
    super.dispose();
  }
}
