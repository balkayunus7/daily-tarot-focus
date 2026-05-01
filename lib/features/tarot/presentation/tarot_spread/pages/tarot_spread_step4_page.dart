import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/widgets/spread_layout_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class TarotSpreadStep4Page extends StatefulWidget {
  const TarotSpreadStep4Page({super.key});

  @override
  State<TarotSpreadStep4Page> createState() => _TarotSpreadStep4PageState();
}

class _TarotSpreadStep4PageState extends State<TarotSpreadStep4Page> {
  static const int _maxChars = 120;

  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  final ValueNotifier<int> _charCount = ValueNotifier(0);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(() => _charCount.value = _controller.text.length);
    _focusNode.addListener(() => _isFocused.value = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _charCount.dispose();
    _isFocused.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      resizeToAvoidBottomInset: true,
      appBar: TarotAppBar(
        titleWidget: Column(
          children: [
            Text(
              LocaleKeys.tarot_question_question_step_title.tr(),
              style: m16w700(context),
            ),
            Sp.tiny.heightBox,
            Text(
              LocaleKeys.tarot_question_step_4_of_6.tr(),
              style: m10w500(context).copyWith(color: colors.textSecondary, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: BlocBuilder<TarotBloc, TarotState>(
          builder: (context, state) {
            final spread = state.selectedSpread;
            if (spread == null) return const SizedBox.shrink();

            return Column(
              children: [
                _SpreadTitleBar(
                  title: spread.title,
                  onMoreTap: () async {
                    await showSpreadDetailsBottomSheet(context, spread: spread);
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sp.screen.w,
                      vertical: Sp.small.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TipItem(
                          index: 1,
                          emoji: '🔍',
                          title: LocaleKeys.tarot_question_tip_1_title.tr(),
                          description: LocaleKeys.tarot_question_tip_1_desc.tr(),
                        ),
                        Sp.small.heightBox,
                        _TipItem(
                          index: 2,
                          emoji: '🧭',
                          title: LocaleKeys.tarot_question_tip_2_title.tr(),
                          description: LocaleKeys.tarot_question_tip_2_desc.tr(),
                        ),
                        Sp.small.heightBox,
                        _TipItem(
                          index: 3,
                          emoji: '🎯',
                          title: LocaleKeys.tarot_question_tip_3_title.tr(),
                          description: LocaleKeys.tarot_question_tip_3_desc.tr(),
                        ),
                        Sp.xxlarge.heightBox,
                        _QuestionTextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          charCount: _charCount,
                          isFocused: _isFocused,
                          maxChars: _maxChars,
                        ),
                      ],
                    ),
                  ),
                ),
                _NextButton(
                  charCount: _charCount,
                  onTap: () async {
                    context.read<TarotBloc>().addSelectQuestion(question: _controller.text);
                    await context.push(AppRoutes.tarotQuestionStep5);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SpreadTitleBar extends StatelessWidget {
  const _SpreadTitleBar({required this.title, required this.onMoreTap});

  final String title;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sp.screen.w, vertical: Sp.small.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
          ),
          Sp.xsmall.widthBox,
          Expanded(
            child: Text(
              title,
              style: m14w600(context).copyWith(color: colors.textSecondary, letterSpacing: 0.2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Sp.small.widthBox,
          ScalingContainer(
            onTap: onMoreTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.common_more.tr(),
                  style: m12w500(context).copyWith(color: colors.primary),
                ),
                Sp.tiny.widthBox,
                Icon(Icons.keyboard_arrow_right_rounded, color: colors.primary, size: 14.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({
    required this.index,
    required this.emoji,
    required this.title,
    required this.description,
  });

  final int index;
  final String emoji;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.35),
        borderRadius: Sp.small.radiusR,
        border: Border(left: BorderSide(color: colors.primary, width: 3)),
      ),
      padding: Sp.medium.padSymR(h: Sp.medium, v: Sp.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text('$index', style: m10w700(context).copyWith(color: colors.primary)),
          ),
          Sp.small.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(emoji, style: m13w500(context)),
                    Sp.tiny.widthBox,
                    Expanded(
                      child: Text(
                        title,
                        style: m13w500(context).copyWith(color: colors.textPrimary),
                      ),
                    ),
                  ],
                ),
                Sp.tiny.heightBox,
                Text(
                  description,
                  style: m12w400(context).copyWith(color: colors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionTextField extends StatelessWidget {
  const _QuestionTextField({
    required this.controller,
    required this.focusNode,
    required this.charCount,
    required this.isFocused,
    required this.maxChars,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueNotifier<int> charCount;
  final ValueNotifier<bool> isFocused;
  final int maxChars;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: Sp.xsmall.h),
          child: Text(
            LocaleKeys.tarot_question_question_hint.tr(),
            style: m11w500(context).copyWith(color: colors.textSecondary, letterSpacing: 0.3),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isFocused,
          builder:
              (_, focused, child) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: focused ? colors.primary.withValues(alpha: 0.6) : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(Sp.medium.w, Sp.medium.h, Sp.medium.w, Sp.xsmall.h),
                child: child,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: null,
                minLines: 5,
                maxLength: maxChars,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: m14w400(context).copyWith(color: colors.textPrimary, height: 1.55),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  hintText: LocaleKeys.tarot_question_question_hint.tr(),
                  hintStyle: m14w400(context).copyWith(color: colors.textDisabled, height: 1.6),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Sp.tiny.heightBox,
              ValueListenableBuilder<int>(
                valueListenable: charCount,
                builder: (_, count, _) {
                  final isNearLimit = count > (maxChars * 0.8).toInt();
                  return Text(
                    '$count / $maxChars',
                    style: m10w400(context).copyWith(
                      color: isNearLimit ? colors.error : colors.textDisabled,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.charCount, required this.onTap});
  final ValueNotifier<int> charCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ValueListenableBuilder<int>(
        valueListenable: charCount,
        builder:
            (_, count, _) => Padding(
              padding: Sp.screen.padXR,
              child: FancyButton(
                onTap: onTap,
                text: LocaleKeys.common_next.tr(),
                isDisabled: count == 0,
              ),
            ),
      ),
    );
  }
}
