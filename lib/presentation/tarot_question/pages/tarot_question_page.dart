import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/presentation/tarot_question/helpers/question_page_mixin.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

part '../helpers/tarot_reading_topic_enum.dart';

class TarotQuestionPage extends StatefulWidget {
  const TarotQuestionPage({super.key});

  @override
  State<TarotQuestionPage> createState() => _TarotQuestionPageState();
}

class _TarotQuestionPageState extends State<TarotQuestionPage>
    with QuestionPageStateMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
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
                    bottom: SpacingConsts.xlarge,
                    child: Icon(
                      FontAwesomeIcons.wandSparkles,
                      color: colors.primary,
                      size: SpacingConsts.large,
                    ),
                  ),
                ],
              ),
              Spacing.xxlargeH,
              _SectionTitle(
                icon: FontAwesomeIcons.handSparkles,
                title: LocaleKeys.questionChooseReadingType.tr(),
              ),
              Spacing.mediumH,
              ValueListenableBuilder(
                valueListenable: selectedReadingTopic,
                builder: (context, value, child) {
                  return Row(
                    children: [
                      _ReadingTypeCard(
                        title: LocaleKeys.questionCareerReading.tr(),
                        icon: Icons.business,
                        onTap: () => readingTopic = TarotReadingTopic.career,
                        isSelected: value!.isCareer,
                      ),
                      Spacing.mediumW,
                      _ReadingTypeCard(
                        title: LocaleKeys.questionLoveReading.tr(),
                        icon: Icons.heart_broken,
                        onTap: () => readingTopic = TarotReadingTopic.love,
                        isSelected: value.isLove,
                      ),
                      Spacing.mediumW,
                      _ReadingTypeCard(
                        title: LocaleKeys.questionHealthReading.tr(),
                        icon: Icons.health_and_safety,
                        onTap: () => readingTopic = TarotReadingTopic.health,
                        isSelected: value.isHealth,
                      ),
                    ],
                  );
                },
              ),
              Spacing.xxlargeH,
              _SectionTitle(
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
                      _CardOption(
                        cardCount: singleCardCount.value,
                        title: LocaleKeys.questionSingleCard.tr(),
                        subtitle: LocaleKeys.questionSingleCardDesc.tr(),
                        isSelected: value == singleCardCount,
                        onTap: () => cardCount = singleCardCount,
                      ),
                      Spacing.mediumW,
                      _CardOption(
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
                buttonText: LocaleKeys.questionStartReading.tr(),
                onTap: () {},
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, color: colors.primary, size: 20),
        Spacing.mediumW,
        Text(title, style: m16w500(context)),
      ],
    );
  }
}

class _ReadingTypeCard extends StatelessWidget {
  const _ReadingTypeCard({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isSelected,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenSize = Spacing.screenWidth(context);
    final cardWidth = (screenSize / 3) - 24;
    final primaryColor = isSelected ? colors.primary : colors.surfaceSecondary;

    return ScalingContainer(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: SpacingConsts.medium),
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: Spacing.smallBorderRadius,
          border: Border.all(color: primaryColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryColor),
            Spacing.smallH,
            Text(
              title,
              style: m16w500(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardOption extends StatelessWidget {
  const _CardOption({
    required this.cardCount,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final int cardCount;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final itemWidth = MediaQuery.of(context).size.width / 2 - 28;
    final itemHeight = itemWidth + SpacingConsts.medium;
    final selectedColor = isSelected ? colors.primary : colors.surfaceSecondary;
    final cardWidth = itemHeight / 5;
    final cardHeight = itemHeight / 3;

    return ScalingContainer(
      onTap: onTap,
      child: Container(
        height: itemHeight,
        width: itemWidth,
        decoration: BoxDecoration(
          borderRadius: Spacing.defaultBorderRadius,
          border: Border.all(color: selectedColor, width: 2),
        ),
        child: Padding(
          padding: Spacing.xsmallPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  cardCount,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingConsts.tiny,
                    ),
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        borderRadius: Spacing.xsmallBorderRadius,
                        border: Border.all(color: selectedColor),
                      ),
                    ),
                  ),
                ),
              ),
              Spacing.mediumH,
              Text(title, style: m16w500(context)),
              Spacing.xsmallH,
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: m12w500(context).copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
