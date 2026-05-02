import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/helpers/reveal_page_scope.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/widgets/reveal_card_item.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class RevealCardWheel extends StatelessWidget {
  const RevealCardWheel({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = RevealPageScope.of(context);
    final cardWheelheight = context.suHeight * 0.25;
    final screenWidth = context.suWidth;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: cardWheelheight,
            child: RotatedBox(
              quarterTurns: 1,
              child: ValueListenableBuilder<int>(
                valueListenable: scope.selectedCardIndex,
                builder: (context, selectedCardIndex, _) {
                  return ListWheelScrollView.useDelegate(
                    controller: scope.wheelScrollController,
                    itemExtent: CardSp.wheelItemExtent,
                    diameterRatio: CardSp.wheelDiameterRatio,
                    perspective: CardSp.wheelPerspective,
                    physics: const FixedExtentScrollPhysics(parent: ClampingScrollPhysics()),
                    squeeze: CardSp.wheelSqueeze,
                    clipBehavior: Clip.none,
                    onSelectedItemChanged: scope.handleCardScroll,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: CardSp.totalCards,
                      builder: (context, index) {
                        return RevealCardItem(
                          index: index,
                          isSelected: index == selectedCardIndex,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Sp.xsmall.heightBox,
          CustomCacheNetworkImage(
            imageUrl: TarotAppAssets.arrowHttp,
            width: screenWidth * 0.18,
            height: screenWidth * 0.1,
            color: context.colors.primary,
          ),
          Sp.xsmall.heightBox,
          Text(
            LocaleKeys.reveal_page_drag_to_move.tr(),
            style: m12w500(context).copyWith(color: context.colors.textSecondary),
          ),
          Sp.medium.heightBox,
        ],
      ),
    );
  }
}
