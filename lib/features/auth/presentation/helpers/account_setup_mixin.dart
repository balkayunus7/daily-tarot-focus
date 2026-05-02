import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/features/auth/presentation/pages/register_account_setup_page.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin AccountSetupMixin on State<AccountSetupPage> {
  late final ValueNotifier<bool> isPrecaching;

  @override
  void initState() {
    super.initState();
    isPrecaching = ValueNotifier(false);
    isPrecaching.addListener(() {
      if (!isPrecaching.value && context.mounted) {
        context.go(AppRoutes.tarotExplore);
      }
    });
  }

  @override
  void dispose() {
    isPrecaching.dispose();
    super.dispose();
  }

  Future<void> precacheImages(TarotState state) async {
    isPrecaching.value = true;

    final staticImages = [
      TarotAppAssets.dailyPickBgHttp,
      TarotAppAssets.emptyHttp,
      TarotAppAssets.maskotDailyHttp,
      TarotAppAssets.libraryHttp,
      TarotAppAssets.paywallHttp,
    ];

    final cardImages = state.allCardsOrEmpty
        .asList()
        .map((c) => c.imageUrl)
        .where((url) => url.isNotEmpty)
        .toList();

    final readerImages = state.readersOrEmpty
        .asList()
        .map((r) => r.imageUrl)
        .where((url) => url.isNotEmpty)
        .toList();

    await Future.wait([
      ...staticImages,
      ...cardImages,
      ...readerImages,
    ].map((url) => precacheImage(CachedNetworkImageProvider(url), context)));

    isPrecaching.value = false;
  }
}
