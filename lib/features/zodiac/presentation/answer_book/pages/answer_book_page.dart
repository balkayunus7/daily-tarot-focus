import 'dart:math';
import 'dart:ui';

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/answer_book/helpers/answer_book_page_mixin.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/answer_book/helpers/answer_book_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

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
    final size = 260.r;
    final scope = AnswerBookPageScope.of(context).state;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: scope.flipController,
            builder: (context, _) {
              final blur = scope.blur;
              return ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: BookIllustration(flipValue: scope.flipController.value, size: size),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: scope.currentIndex,
            builder: (context, index, child) {
              return FadeTransition(
                opacity: scope.revealController,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    scope.currentAnswer,
                    style: m18w700(context).copyWith(
                      color: context.colors.textOnPrimary,
                      fontSize: 24.sp,
                      height: 1.35,
                      shadows: [
                        Shadow(color: Colors.black.withValues(alpha: 0.85), blurRadius: 16),
                        Shadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 4),
                      ],
                    ),
                    textAlign: TextAlign.center,
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
