import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/features/auth/presentation/widgets/step_background.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class AccountSetupPage extends StatefulWidget {
  const AccountSetupPage({super.key});

  @override
  State<AccountSetupPage> createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends State<AccountSetupPage> {
  @override
  void initState() {
    super.initState();
    final session = context.read<AuthCubit>().state.sessionOrCrash;
    context.read<TarotBloc>().addSetupAccountRequested(session: session);
  }

  Future<void> _precacheImages(BuildContext context, TarotState state) async {
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

    final allImages = [...staticImages, ...cardImages, ...readerImages];

    await Future.wait(
      allImages.map((url) => precacheImage(CachedNetworkImageProvider(url), context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocListener<TarotBloc, TarotState>(
        listenWhen: (previous, current) {
          return (previous.isSettingUpAccount != current.isSettingUpAccount) &&
              current.hasAccountSetupCompleted;
        },
        listener: (context, state) async {
          await _precacheImages(context, state);
          if (!context.mounted) return;
          context.go(AppRoutes.tarotExplore);
        },
        child: Stack(
          children: [
            const StepBackground(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: BlocBuilder<TarotBloc, TarotState>(
                  builder: (context, state) {
                    final completed =
                        [
                          state.fetchAllCardsFailureOrCards.isSome(),
                          state.fetchSpreadsFailureOrSpreads.isSome(),
                          state.fetchReadersFailureOrReaders.isSome(),
                        ].where((e) => e).length;

                    final progress = completed / 3.0;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hesabın hazırlanıyor',
                          style: m28w600(context),
                        ),
                        Sp.xsmall.heightBox,
                        Text(
                          'Tarot kartları, falcılar ve spreads yükleniyor...',
                          style: m14w500(context).copyWith(color: colors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        Sp.xlarge.heightBox,
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          builder:
                              (context, value, _) => LinearProgressIndicator(
                                value: value,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(8),
                                backgroundColor: colors.secondary,
                                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                              ),
                        ),
                        Sp.medium.heightBox,
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 400),
                          builder:
                              (context, value, _) => Text(
                                '%${(value * 100).toInt()}',
                                style: m14w700(context).copyWith(color: colors.primary),
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
