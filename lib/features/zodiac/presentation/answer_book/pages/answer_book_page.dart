import 'dart:math';
import 'dart:ui';

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/answer_book/helpers/answer_book_page_mixin.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/answer_book/helpers/answer_book_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/answer_book_illustration.dart';
part '../widgets/answer_bottom_section.dart';

class AnswerBookPage extends StatefulWidget {
  const AnswerBookPage({super.key});

  @override
  State<AnswerBookPage> createState() => _AnswerBookPageState();
}

class _AnswerBookPageState extends State<AnswerBookPage>
    with TickerProviderStateMixin, AnswerBookPageMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnswerBookPageScope(
      state: this,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              TarotAppBar(
                title: LocaleKeys.answer_book_page_title.tr(),
                titleStyle: m18w700(context),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: revealAnswer,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const _BookVisual(),
                      const Spacer(),
                      const SafeArea(child: _BottomSection()),
                      Sp.xxxlarge.heightBox,
                    ],
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

class _BookVisual extends StatelessWidget {
  const _BookVisual();

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final size = min(shortestSide * 0.86, 340.r);
    final scope = AnswerBookPageScope.of(context).state;
    final bookW = size * 0.82;
    final bookH = size * 0.72;
    final bookTop = (size - bookH) / 2 + size * 0.04;
    final pageLeft = size / 2 + bookW * 0.06;
    final pageTop = bookTop + bookH * 0.2;
    final pageWidth = bookW * 0.38;
    final pageHeight = bookH * 0.56;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([
              scope.flipController,
              scope.settleController,
              scope.hasCompletedFlipCycle,
              scope.isAnswerShown,
            ]),
            builder: (context, _) {
              final settleProgress = scope.settleController.value;
              final blur =
                  scope.isAnswerShown.value
                      ? 0.0
                      : scope.blur * (1 - settleProgress);
              return ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: BookIllustration(
                  flipValue: scope.flipController.value,
                  hasCompletedFlipCycle: scope.hasCompletedFlipCycle.value,
                  settleProgress: settleProgress,
                  size: size,
                ),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: scope.currentIndex,
            builder: (context, index, child) {
              return Positioned(
                left: pageLeft,
                top: pageTop,
                width: pageWidth,
                height: pageHeight,
                child: FadeTransition(
                  opacity: scope.revealController,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: pageWidth,
                        child: Text(
                          scope.currentAnswer,
                          style: m18w700(context).copyWith(
                            color: const Color(0xFF5B4630),
                            fontSize: 15.sp,
                            height: 1.25,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
