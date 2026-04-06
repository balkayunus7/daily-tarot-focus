import 'package:daily_tarot_focus/application/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/application/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/application/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_question_data.dart';
import 'package:daily_tarot_focus/presentation/tarot_question/helpers/question_page_mixin.dart';
import 'package:daily_tarot_focus/presentation/tarot_question/helpers/question_topic_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../widgets/question_section_header.dart';
part '../widgets/question_topic_card.dart';
part '../widgets/question_spread_option_card.dart';

class TarotQuestionPage extends StatefulWidget {
  const TarotQuestionPage({super.key});

  @override
  State<TarotQuestionPage> createState() => _TarotQuestionPageState();
}

class _TarotQuestionPageState extends State<TarotQuestionPage> with QuestionPageStateMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: TarotAppBar(title: LocaleKeys.question_page_title.tr()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingConsts.large),
          child: Column(
            children: [
              Spacing.largeH,
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  TextFormField(
                    controller: questionController,
                    maxLines: 5,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    cursorColor: colors.primary,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: Spacing.smallBorderRadius,
                        borderSide: BorderSide(color: colors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: Spacing.smallBorderRadius,
                        borderSide: BorderSide(color: colors.primary, width: 2),
                      ),
                      hintText: LocaleKeys.question_page_hint_text.tr(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  Positioned(
                    right: SpacingConsts.medium,
                    bottom: SpacingConsts.medium,
                    child: ScalingContainer(
                      onTap: getSuggestedQuestion,
                      child: Padding(
                        padding: const EdgeInsets.all(SpacingConsts.small),
                        child: Icon(
                          FontAwesomeIcons.wandSparkles,
                          color: colors.primary,
                          size: SpacingConsts.large,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.xxlargeH,
              QuestionSectionHeader(
                icon: FontAwesomeIcons.handSparkles,
                title: LocaleKeys.question_page_choose_topic.tr(),
              ),
              Spacing.mediumH,
              ValueListenableBuilder(
                valueListenable: selectedTopic,
                builder: (context, value, child) {
                  return Row(
                    children: [
                      QuestionTopicCard(
                        title: LocaleKeys.question_page_career_topic.tr(),
                        svgIconPath: TarotAppAssets.careerIcon.path,
                        onTap: () => topic = QuestionTopic.career,
                        isSelected: value!.isCareer,
                      ),
                      Spacing.mediumW,
                      QuestionTopicCard(
                        title: LocaleKeys.question_page_love_topic.tr(),
                        svgIconPath: TarotAppAssets.loveIcon.path,
                        onTap: () => topic = QuestionTopic.love,
                        isSelected: value.isLove,
                      ),
                      Spacing.mediumW,
                      QuestionTopicCard(
                        title: LocaleKeys.question_page_health_topic.tr(),
                        svgIconPath: TarotAppAssets.healthIcon.path,
                        onTap: () => topic = QuestionTopic.health,
                        isSelected: value.isHealth,
                      ),
                    ],
                  );
                },
              ),
              Spacing.xxlargeH,
              QuestionSectionHeader(
                icon: FontAwesomeIcons.accusoft,
                title: LocaleKeys.question_page_choose_card_count.tr(),
              ),
              Spacing.mediumH,
              ValueListenableBuilder(
                valueListenable: selectedCardCount,
                builder: (context, value, child) {
                  const singleCardCount = QuestionCardCount.singleCardCount;
                  const multipleCardCount = QuestionCardCount.multipleCardCount;

                  return Row(
                    children: [
                      QuestionSpreadOptionCard(
                        cardCount: singleCardCount.value,
                        title: LocaleKeys.question_page_single_card.tr(),
                        subtitle: LocaleKeys.question_page_single_card_desc.tr(),
                        isSelected: value == singleCardCount,
                        onTap: () => cardCount = singleCardCount,
                      ),
                      Spacing.mediumW,
                      QuestionSpreadOptionCard(
                        cardCount: multipleCardCount.value,
                        title: LocaleKeys.question_page_multiple_cards.tr(),
                        subtitle: LocaleKeys.question_page_multiple_cards_desc.tr(),
                        isSelected: value == multipleCardCount,
                        onTap: () => cardCount = multipleCardCount,
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              BlocBuilder<TarotBloc, TarotState>(
                builder: (context, state) {
                  return ValueListenableBuilder(
                    valueListenable: questionController,
                    builder: (context, value, _) {
                      return TarotButton(
                        buttonText: LocaleKeys.question_page_see_answer.tr(),
                        isLoading: state.isAskingQuestion,
                        onTap: () {
                          final tarotBloc = context.read<TarotBloc>();
                          final lclCubit = context.read<TarotLocalizationCubit>();
                          final authState = context.read<AuthCubit>().state;
                          final session = authState.sessionOrCrash;

                          final tarotQuestionData = TarotQuestionData(
                            user: authState.userOrCrash as TarotUser,
                            topic: selectedTopic.value!.value,
                            question: questionController.text,
                            drawnCards: lclCubit.getRandomCards(selectedCardCount.value!.value),
                            language: context.locale.languageCode,
                          );

                          tarotBloc.addQuestionAsked(
                            session: session,
                            tarotQuestionData: tarotQuestionData,
                            languageCode: context.locale.languageCode,
                          );

                          context.replace(AppRoutes.tarotQuestionAnswer);
                        },
                        bgColor: colors.accent,
                        buttonTextStyle: m16w700(context),
                        isDisabled: value.text.isEmpty || state.isAskingQuestion,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
