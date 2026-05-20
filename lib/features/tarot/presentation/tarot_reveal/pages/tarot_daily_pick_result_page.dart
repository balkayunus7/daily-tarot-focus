import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/build_context_toast_ext.dart';
import 'package:daily_tarot_focus/core/util/locale_extensions.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_daily_pick_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/widgets/daily_pick_result_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotDailyPickResultArgs {
  const TarotDailyPickResultArgs({
    required this.tarot,
    required this.isReversed,
  });

  final TarotCardModel tarot;
  final bool isReversed;
}

class TarotDailyPickResultPage extends StatefulWidget {
  const TarotDailyPickResultPage({required this.args, super.key});
  final TarotDailyPickResultArgs args;

  @override
  State<TarotDailyPickResultPage> createState() =>
      _TarotDailyPickResultPageState();
}

class _TarotDailyPickResultPageState extends State<TarotDailyPickResultPage> {
  void _saveDailyPick() {
    final state = context.read<TarotBloc>().state;
    if (state.isRecordDailyCard) return;
    final dailyPick = state.generateDailyPickResponseOrNull;
    if (dailyPick == null) return;

    final session = context.read<AuthCubit>().state.sessionOrCrash;

    context.read<TarotBloc>().addRecordDailyCardRequested(
      request: RecordDailyCardRequest(
        session: session,
        cardId: widget.args.tarot.id,
        isReversed: widget.args.isReversed,
        dailyPick: dailyPick,
        locale: context.currentLocaleLanguage.value,
        date: DateTime.now(),
      ),
    );
  }

  void _generateDailyPick() {
    context.read<TarotBloc>().addGenerateDailyPickRequested(
      request: GenerateDailyPickRequest(
        session: context.read<AuthCubit>().state.sessionOrCrash,
        card: widget.args.tarot,
        isReversed: widget.args.isReversed,
        date: DateTime.now(),
        locale: context.currentLocaleLanguage.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocConsumer<TarotBloc, TarotState>(
      listenWhen: (previous, current) {
        return previous.hasRecordDailyCardSucceeded !=
                current.hasRecordDailyCardSucceeded ||
            previous.hasRecordDailyCardFailed !=
                current.hasRecordDailyCardFailed;
      },
      listener: (context, state) {
        if (state.hasRecordDailyCardFailed) {
          context.showErrorToastMessage(
            LocaleKeys.tarot_daily_save_failed.tr(),
          );
        }
        if (state.hasRecordDailyCardSucceeded) {
          final router = GoRouter.of(context);
          context.showToastMessage(LocaleKeys.tarot_daily_save_success.tr());
          router.go(AppRoutes.tarotDailyCalendar);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: colors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                TarotAppBar(
                  title: LocaleKeys.daily_pick_page_title.tr(),
                  titleStyle: m18w700(context),
                  backIcon: Icons.close,
                  trailingIcon:
                      state.isRecordDailyCard
                          ? FontAwesomeIcons.spinner
                          : Icons.save,
                  onBackIconTap: () => context.go(AppRoutes.tarotExplore),
                  onIconTap: _saveDailyPick,
                ),
                Expanded(
                  child: BlocBuilder<TarotBloc, TarotState>(
                    buildWhen:
                        (previous, current) =>
                            previous.isGeneratingDailyPick !=
                                current.isGeneratingDailyPick ||
                            previous.fetchFailureOrGenerateDailyPick !=
                                current.fetchFailureOrGenerateDailyPick,
                    builder: (context, state) {
                      final response = state.generateDailyPickResponseOrNull;

                      return SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          Sp.large.h,
                          0,
                          Sp.xxxlarge.h +
                              MediaQuery.of(context).padding.bottom,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DailyPickDetailTop(
                              tarot: widget.args.tarot,
                              isReversed: widget.args.isReversed,
                              date: DateTime.now(),
                            ),
                            Sp.xlarge.heightBox,
                            if (response != null) ...[
                              Padding(
                                padding: Sp.xlarge.padXR,
                                child: Column(
                                  children: [
                                    DailyPickAdviceCard(
                                      text: response.dailyAdvice,
                                    ),
                                    Sp.medium.heightBox,
                                    ...response.categories.map(
                                      (category) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: Sp.medium.h,
                                        ),
                                        child: DailyPickCategoryTile(
                                          category: category,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else if (state.hasGeneratedDailyPickFailed) ...[
                              Padding(
                                padding: Sp.xlarge.padXR,
                                child: _DailyPickErrorCard(
                                  onRetry: _generateDailyPick,
                                ),
                              ),
                            ] else ...[
                              Padding(
                                padding: Sp.xlarge.padXR,
                                child: const _DailyPickShimmer(),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DailyPickErrorCard extends StatelessWidget {
  const _DailyPickErrorCard({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: context.colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: context.colors.border),
      child: Column(
        children: [
          Text(
            LocaleKeys.tarot_question_loading_error.tr(),
            style: m16w700(context),
          ),
          Sp.medium.heightBox,
          FancyButton(onTap: onRetry, text: LocaleKeys.common_confirm.tr()),
        ],
      ),
    );
  }
}

class _DailyPickShimmer extends StatelessWidget {
  const _DailyPickShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: Sp.small.h),
          child: FancyContainer(
            width: double.infinity,
            height: index == 0 ? 96.h : 78.h,
            borderRadius: Sp.large,
            color: colors.textSecondary.withValues(alpha: 0.06),
            border: Border.all(color: colors.border),
          ),
        ),
      ),
    );
  }
}
