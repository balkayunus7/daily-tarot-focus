import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/features/auth/presentation/helpers/account_setup_mixin.dart';
import 'package:daily_tarot_focus/features/auth/presentation/helpers/account_setup_scope.dart';
import 'package:daily_tarot_focus/features/auth/presentation/widgets/step_background.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class AccountSetupPage extends StatefulWidget {
  const AccountSetupPage({super.key});

  @override
  State<AccountSetupPage> createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends State<AccountSetupPage> with AccountSetupMixin {
  @override
  void initState() {
    super.initState();
    final session = context.read<AuthCubit>().state.sessionOrCrash;
    context.read<TarotBloc>().addSetupAccountRequested(session: session);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AccountSetupScope(
      state: this,
      child: Scaffold(
        backgroundColor: colors.background,
        body: BlocListener<TarotBloc, TarotState>(
          listenWhen: (previous, current) =>
              (previous.isSettingUpAccount != current.isSettingUpAccount) &&
              current.hasAccountSetupCompleted,
          listener: (context, state) async {
            await AccountSetupScope.of(context).state.precacheImages(state);
          },
          child: Stack(
            children: [
              const StepBackground(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: BlocBuilder<TarotBloc, TarotState>(
                    builder: (context, state) {
                      final completed = [
                        state.fetchAllCardsFailureOrCards.isSome(),
                        state.fetchSpreadsFailureOrSpreads.isSome(),
                        state.fetchReadersFailureOrReaders.isSome(),
                      ].where((e) => e).length;

                      return ValueListenableBuilder<bool>(
                        valueListenable: AccountSetupScope.of(context).state.isPrecaching,
                        builder: (context, precaching, _) {
                          final totalProgress = (completed / 4.0) +
                              (precaching ? 0.0 : (completed == 3 ? 0.25 : 0.0));

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.register_page_preparing_account.tr(),
                                style: m26w600(context),
                              ),
                              Sp.xsmall.heightBox,
                              Text(
                                precaching
                                    ? LocaleKeys.register_page_loading_images.tr()
                                    : LocaleKeys.register_page_loading_data.tr(),
                                style: m12w500(context)
                                    .copyWith(color: colors.textSecondary),
                                textAlign: TextAlign.center,
                              ),
                              Sp.xlarge.heightBox,
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: totalProgress),
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                                builder: (context, value, _) => LinearProgressIndicator(
                                  value: value,
                                  minHeight: 8,
                                  borderRadius: Sp.xsmall.radiusR,
                                  backgroundColor: colors.accent,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(colors.primary),
                                ),
                              ),
                              Sp.medium.heightBox,
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: totalProgress),
                                duration: const Duration(milliseconds: 500),
                                builder: (context, value, _) => Text(
                                  LocaleKeys.register_page_progress_format.tr(
                                    args: [(value * 100).toInt().toString()],
                                  ),
                                  style: m14w700(context)
                                      .copyWith(color: colors.secondary),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
