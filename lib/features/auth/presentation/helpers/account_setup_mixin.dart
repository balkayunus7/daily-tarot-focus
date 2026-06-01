import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin AccountSetupMixin<T extends StatefulWidget> on State<T> {
  late final ValueNotifier<double> progress;
  late final ValueNotifier<bool> isPrecaching;
  Timer? _progressTimer;
  bool _dataLoaded = false;
  bool _navigated = false;

  bool get shouldAutoNavigate => true;

  @override
  void initState() {
    super.initState();
    progress = ValueNotifier(0);
    isPrecaching = ValueNotifier(false);
    if (shouldAutoNavigate) _startProgressTimer();
  }

  void _startProgressTimer() {
    const minTicks = 100;
    var ticks = 0;

    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      ticks++;
      final isDone = _dataLoaded && !isPrecaching.value;
      final minTimeReached = ticks >= minTicks;

      if (isDone && minTimeReached && !_navigated) {
        final current = progress.value;
        progress.value = current + (1.0 - current) * 0.25;

        if (progress.value >= 0.995) {
          _progressTimer?.cancel();
          progress.value = 1.0;
          _navigated = true;
          final router = GoRouter.of(context);
          Future.delayed(
            const Duration(milliseconds: 400),
            () {
              router.go(AppRoutes.tarotExplore);
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (context.mounted) {
                  await router.push(AppRoutes.subscriptionPaywall);
                }
              });
            },
          );
        }
      } else if (isDone && !minTimeReached) {
        final current = progress.value;
        progress.value = current + (0.99 - current) * 0.01;
      } else if (!_dataLoaded) {
        final current = progress.value;
        progress.value = current + (0.60 - current) * 0.028;
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    progress.dispose();
    isPrecaching.dispose();
    super.dispose();
  }

  void precacheImages() {
    final state = context.read<TarotBloc>().state;
    if (!state.hasAccountSetupCompleted) return;

    _dataLoaded = true;
    isPrecaching.value = true;

    final allUrls = [
      TarotAppAssets.dailyPickBgHttp,
      TarotAppAssets.emptyHttp,
      TarotAppAssets.maskotDailyHttp,
      TarotAppAssets.libraryHttp,
      TarotAppAssets.paywallHttp,
      ...state.allCardsOrEmpty.asList().map((c) => c.imageUrl).where((u) => u.isNotEmpty),
      ...state.readersOrEmpty.asList().map((r) => r.imageUrl).where((u) => u.isNotEmpty),
    ];

    var completed = 0;
    final total = allUrls.length;

    void onComplete() {
      completed++;
      if (shouldAutoNavigate) {
        final newValue = completed / total * 0.30;
        if (newValue > progress.value) progress.value = newValue;
      }
      if (completed >= total) isPrecaching.value = false;
    }

    for (final url in allUrls) {
      unawaited(
        precacheImage(
          CachedNetworkImageProvider(url),
          context,
        ).then((_) => onComplete()).catchError((_) => onComplete()),
      );
    }
  }
}
