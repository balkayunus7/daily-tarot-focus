import 'dart:math' as math;

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/helpers/question_card_select_page_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class TarotQuestionCardSelectPage extends StatefulWidget {
  const TarotQuestionCardSelectPage({required this.draftData, super.key});
  final TarotQuestionDraftData draftData;

  @override
  State<TarotQuestionCardSelectPage> createState() => _TarotQuestionCardSelectPageState();
}

class _TarotQuestionCardSelectPageState extends State<TarotQuestionCardSelectPage>
    with QuestionCardSelectPageStateMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: TarotAppBar(
        title: 'Kart Seçimi',
        backIcon: Icons.close,
        onBackIconTap: () {
          context.go(AppRoutes.tarotExplore);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingConsts.large),
          child: Column(
            children: [
              Spacing.largeH,
              FancyContainer(
                width: double.infinity,
                borderRadius: Spacing.defaultBorderRadius,
                child: Padding(
                  padding: Spacing.hMediumVSmallPad,
                  child: Center(
                    child: Text(
                      'Kartını seç ($selectedCardCount/$requiredCardCount)',
                      style: m16w700(context).copyWith(color: colors.primary),
                    ),
                  ),
                ),
              ),
              Spacing.largeH,
              if (deckCards.isEmpty) ...[
                Center(child: SpinKitFadingCircle(color: colors.primary, size: 32)),
                Spacing.mediumH,
                Text(
                  'Kartlar yükleniyor...',
                  style: m14w500(
                    context,
                  ).copyWith(color: colors.textSecondary),
                ),
              ] else ...[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: deckCards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: SpacingConsts.xsmall,
                    crossAxisSpacing: SpacingConsts.small,
                    childAspectRatio: 0.63,
                  ),
                  itemBuilder: (context, index) {
                    final deckCard = deckCards[index];
                    return _QuestionFlipSelectableCard(
                      card: deckCard.card,
                      isFlipped: deckCard.isFlipped,
                      isSelected: deckCard.isSelected,
                      isReversed: deckCard.isReversed,
                      onTap: () => onDeckCardTap(index),
                    );
                  },
                ),
              ],
              const Spacer(),
              BlocBuilder<TarotBloc, TarotState>(
                builder: (context, state) {
                  return TarotButton(
                    buttonText: 'Cevabı Gör',
                    isLoading: state.isReading,
                    onTap: submitQuestion,
                    buttonTextStyle: m16w700(context),
                    isDisabled: state.isReading || !hasEnoughSelection,
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

class _QuestionFlipSelectableCard extends StatelessWidget {
  const _QuestionFlipSelectableCard({
    required this.card,
    required this.isFlipped,
    required this.isSelected,
    required this.isReversed,
    required this.onTap,
  });

  final TarotCardModel card;
  final bool isFlipped;
  final bool isSelected;
  final bool isReversed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScalingContainer(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        tween: Tween<double>(begin: 0, end: isFlipped ? 1 : 0),
        builder: (context, value, child) {
          final rotateY = value * math.pi;
          final isBackVisible = value < 0.5;
          final borderColor = isSelected ? context.colors.primary : context.colors.border;

          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotateY),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: Spacing.smallBorderRadius,
                border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
              ),
              child: ClipRRect(
                borderRadius: Spacing.xsmallBorderRadius,
                child:
                    isBackVisible
                        ? Image.asset(TarotAppAssets.cardBg.path, fit: BoxFit.cover)
                        : Transform(
                          alignment: Alignment.center,
                          transform:
                              Matrix4.identity()
                                ..rotateY(math.pi)
                                ..rotateZ(isReversed ? math.pi : 0),
                          child: Image.asset(card.imagePath, fit: BoxFit.cover),
                        ),
              ),
            ),
          );
        },
      ),
    );
  }
}
