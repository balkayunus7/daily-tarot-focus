import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_account_setup_page.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin AccountSetupMixin on State<AccountSetupPage> {
  late final ValueNotifier<double> progress;
  late final ValueNotifier<bool> isPrecaching;
  Timer? _progressTimer;
  bool _dataLoaded = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    progress = ValueNotifier(0);
    isPrecaching = ValueNotifier(false);
    _startProgressTimer();
  }

  void _startProgressTimer() {
    // 5 saniye minimum gösterim: 100 tick × 50ms
    const minTicks = 100;
    var ticks = 0;

    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      ticks++;
      final isDone = _dataLoaded && !isPrecaching.value;
      final minTimeReached = ticks >= minTicks;

      if (isDone && minTimeReached && !_navigated) {
        // Faz 3: iş bitti + min süre geçti → hızlıca %100'e ulaş
        final current = progress.value;
        progress.value = current + (1.0 - current) * 0.25;

        if (progress.value >= 0.995) {
          _progressTimer?.cancel();
          progress.value = 1.0;
          _navigated = true;
          final router = GoRouter.of(context);
          Future.delayed(
            const Duration(milliseconds: 400),
            () => router.go(AppRoutes.tarotExplore),
          );
        }
      } else {
        // Faz 1/2: veri yükleniyor veya min süre dolmadı → yavaş ilerle
        // S=0.028 → 5 saniyede doğal olarak ~%85'e ulaşır
        final softCap = _dataLoaded ? 0.90 : 0.60;
        final current = progress.value;
        progress.value = current + (softCap - current) * 0.028;
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

  Future<void> precacheImages(TarotState state) async {
    _dataLoaded = true;
    isPrecaching.value = true;

    final staticImages = [
      TarotAppAssets.dailyPickBgHttp,
      TarotAppAssets.emptyHttp,
      TarotAppAssets.maskotDailyHttp,
      TarotAppAssets.libraryHttp,
      TarotAppAssets.paywallHttp,
    ];

    final cardImages =
        state.allCardsOrEmpty
            .asList()
            .map((c) => c.imageUrl)
            .where((url) => url.isNotEmpty)
            .toList();

    final readerImages =
        state.readersOrEmpty
            .asList()
            .map((r) => r.imageUrl)
            .where((url) => url.isNotEmpty)
            .toList();

    await Future.wait(
      [
        ...staticImages,
        ...cardImages,
        ...readerImages,
      ].map((url) => precacheImage(CachedNetworkImageProvider(url), context)),
    );

    isPrecaching.value = false;
  }
}
