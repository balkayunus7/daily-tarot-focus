import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/reading_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotReadingPage extends StatelessWidget {
  const TarotReadingPage({required this.questionData, super.key});
  final TarotQuestionData questionData;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: TarotAppBar(
        title: 'Yorumların',
        backIcon: Icons.close,
        onBackIconTap: () {
          context.go(AppRoutes.tarotExplore);
        },
      ),
      body: BlocBuilder<TarotBloc, TarotState>(
        builder: (context, state) {
          if (state.isReading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingCircle(color: colors.primary, size: 32),
                  Spacing.largeH,
                  Text(
                    'Kartlar yorumlanıyor...',
                    style: m16w500(context).copyWith(color: colors.primary),
                  ),
                ],
              ),
            );
          }

          if (state.hasReadingQuestionFailed) {
            return ReadingEmptyWidget(
              message: 'Tekrar Dene',
              onTap: () {
                final tarotBloc = context.read<TarotBloc>();
                final authState = context.read<AuthCubit>().state;
                final session = authState.sessionOrCrash;

                tarotBloc.addReadingRequested(
                  request: ReadingRequest(session: session, data: questionData),
                );
              },
            );
          }

          final response = state.readingResponseOrNull;
          if (response == null) return const SizedBox.shrink();

          final data = response.data;
          return _ReadingAnswerWidget(data: data);
        },
      ),
    );
  }
}

class _ReadingAnswerWidget extends StatelessWidget {
  const _ReadingAnswerWidget({required this.data});
  final ReadingDataResponseModel data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: Spacing.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.mediumH,
          FancyContainer(
            width: double.infinity,
            borderRadius: Spacing.xlargeBorderRadius,
            child: Padding(
              padding: Spacing.hLargeVMediumPad,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.wandMagicSparkles,
                        size: 20,
                        color: colors.primary,
                      ),
                      Spacing.smallW,
                      Expanded(
                        child: Text(
                          'Özet',
                          style: m16w700(context),
                        ),
                      ),
                    ],
                  ),
                  Spacing.xsmallH,
                  Text(
                    data.summary,
                    style: m14w500(context).copyWith(
                      color: colors.textPrimary.withValues(alpha: 0.8),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacing.largeH,
          ...data.cards.map((card) {
            return Padding(
              padding: const EdgeInsets.only(bottom: SpacingConsts.large),
              child: FancyContainer(
                width: double.infinity,
                borderRadius: Spacing.xlargeBorderRadius,
                child: Padding(
                  padding: Spacing.hLargeVMediumPad,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${card.position.toUpperCase()} - ${card.id.replaceAll('_', ' ').toUpperCase()}',
                        style: m16w700(context).copyWith(color: colors.primary),
                      ),
                      Spacing.smallH,
                      Text(
                        card.interpretation,
                        style: m14w500(context).copyWith(
                          color: colors.textPrimary.withValues(alpha: 0.8),
                          height: 1.45,
                        ),
                      ),
                      if (card.advice.isNotEmpty) ...[
                        Spacing.mediumH,
                        Text(
                          LocaleKeys.tarot_detail_advice.tr(),
                          style: m14w700(context).copyWith(color: colors.textPrimary),
                        ),
                        Spacing.xsmallH,
                        Text(
                          card.advice,
                          style: m13w500(context).copyWith(
                            color: colors.textPrimary.withValues(alpha: 0.7),
                            height: 1.45,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
          FancyContainer(
            width: double.infinity,
            borderRadius: Spacing.xlargeBorderRadius,
            child: Padding(
              padding: Spacing.hLargeVMediumPad,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.envelopeOpenText,
                        size: 20,
                        color: colors.primary,
                      ),
                      Spacing.smallW,
                      Expanded(
                        child: Text(
                          'Genel Mesaj',
                          style: m16w700(context),
                        ),
                      ),
                    ],
                  ),
                  Spacing.xsmallH,
                  Text(
                    data.overallMessage,
                    style: m14w500(context).copyWith(
                      color: colors.textPrimary.withValues(alpha: 0.8),
                      height: 1.45,
                    ),
                  ),
                  Spacing.mediumH,
                  Row(
                    children: [
                      Icon(
                        Icons.self_improvement_rounded,
                        size: 20,
                        color: context.colors.primary,
                      ),
                      Spacing.smallW,
                      Expanded(
                        child: Text(
                          LocaleKeys.tarot_detail_affirmation.tr(),
                          style: m16w700(context),
                        ),
                      ),
                    ],
                  ),
                  Spacing.xsmallH,
                  Text(
                    data.affirmation,
                    style: m13w500(context).copyWith(
                      color: context.colors.textPrimary.withValues(alpha: 0.8),
                      height: 1.45,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacing.xxlargeH,
        ],
      ),
    );
  }
}
