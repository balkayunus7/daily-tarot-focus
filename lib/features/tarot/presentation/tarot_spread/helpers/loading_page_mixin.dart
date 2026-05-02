import 'dart:async';

import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/pages/tarot_spread_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin LoadingPageMixin on State<TarotSpreadLoadingPage> {
  final List<String> loadingMessages = const [
    'Enerjiler harmanlanıyor...',
    'Kartlar kaderini fısıldıyor...',
    'Evrenin rehberliği şekilleniyor...',
    'Yorumun hazırlanıyor...',
  ];

  final ValueNotifier<int> messageIndex = ValueNotifier(0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final session = context.read<AuthCubit>().state.sessionOrCrash;
    context.read<TarotBloc>().addGenerateReadingRequested(session: session);

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      messageIndex.value = (messageIndex.value + 1) % loadingMessages.length;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    messageIndex.dispose();
    super.dispose();
  }
}
