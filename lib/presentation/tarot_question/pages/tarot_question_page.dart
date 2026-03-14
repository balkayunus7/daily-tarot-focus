import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/presentation/tarot_question/helpers/question_page_mixin.dart';
import 'package:daily_tarot_focus/presentation/tarot_question/helpers/question_topic_enum.dart';
import 'package:flutter/material.dart';
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
      appBar: TarotAppBar(title: LocaleKeys.questionTitle.tr()),
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
                      hintText: LocaleKeys.questionHintText.tr(),
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
                title: LocaleKeys.questionChooseTopic.tr(),
              ),
              Spacing.mediumH,
              ValueListenableBuilder(
                valueListenable: selectedTopic,
                builder: (context, value, child) {
                  return Row(
                    children: [
                      QuestionTopicCard(
                        title: LocaleKeys.questionCareerTopic.tr(),
                        svgIconPath: TarotAppAssets.careerIcon.path,
                        onTap: () => topic = QuestionTopic.career,
                        isSelected: value!.isCareer,
                      ),
                      Spacing.mediumW,
                      QuestionTopicCard(
                        title: LocaleKeys.questionLoveTopic.tr(),
                        svgIconPath: TarotAppAssets.loveIcon.path,
                        onTap: () => topic = QuestionTopic.love,
                        isSelected: value.isLove,
                      ),
                      Spacing.mediumW,
                      QuestionTopicCard(
                        title: LocaleKeys.questionHealthTopic.tr(),
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
                title: LocaleKeys.questionChooseCardCount.tr(),
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
                        title: LocaleKeys.questionSingleCard.tr(),
                        subtitle: LocaleKeys.questionSingleCardDesc.tr(),
                        isSelected: value == singleCardCount,
                        onTap: () => cardCount = singleCardCount,
                      ),
                      Spacing.mediumW,
                      QuestionSpreadOptionCard(
                        cardCount: multipleCardCount.value,
                        title: LocaleKeys.questionMultipleCards.tr(),
                        subtitle: LocaleKeys.questionMultipleCardsDesc.tr(),
                        isSelected: value == multipleCardCount,
                        onTap: () => cardCount = multipleCardCount,
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              TarotButton(
                buttonText: LocaleKeys.questionStartQuestion.tr(),
                onTap: () {},
                bgColor: colors.accent,
                buttonTextStyle: m16w700(context),
                isDisabled: questionController.text.isEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
