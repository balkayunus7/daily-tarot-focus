part of '../pages/answer_book_page.dart';

class _BottomSection extends StatelessWidget {
  const _BottomSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final scope = AnswerBookPageScope.of(context).state;

    return ValueListenableBuilder(
      valueListenable: scope.isAnswerShown,
      builder: (context, isAnswerShown, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            IgnorePointer(
              ignoring: isAnswerShown,
              child: AnimatedOpacity(
                opacity: isAnswerShown ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: Sp.xlarge.padHR,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocaleKeys.answer_book_subtitle.tr(),
                        style: m18w700(context),
                        textAlign: TextAlign.center,
                      ),
                      Sp.large.heightBox,
                      Row(
                        children: [
                          Expanded(
                            child: _BottomActionCard(
                              icon: Icons.vibration_rounded,
                              label: LocaleKeys.answer_book_shake_label.tr(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              LocaleKeys.answer_book_or.tr(),
                              style: m13w500(context).copyWith(color: colors.textSecondary),
                            ),
                          ),
                          Expanded(
                            child: _BottomActionCard(
                              icon: Icons.touch_app_rounded,
                              label: LocaleKeys.answer_book_tap_instruction.tr(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FadeTransition(
              opacity: scope.revealController,
              child: FancyButton(
                onTap: scope.startCycling,
                text: LocaleKeys.answer_book_ask_again.tr(),
                width: 128.w,
                isDisabled: !isAnswerShown,
                textStyle: m15w600(context).copyWith(color: colors.textOnPrimary),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BottomActionCard extends StatelessWidget {
  const _BottomActionCard({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.primary, size: Sp.xlarge.r),
          Sp.xsmall.heightBox,
          Text(
            label,
            style: m13w500(context).copyWith(color: colors.textPrimary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
