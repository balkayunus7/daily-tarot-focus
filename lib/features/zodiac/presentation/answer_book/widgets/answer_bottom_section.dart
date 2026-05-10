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
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocaleKeys.answer_book_subtitle.tr(),
                        style: m18w700(context),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
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
            IgnorePointer(
              ignoring: !isAnswerShown,
              child: FadeTransition(
                opacity: scope.revealController,
                child: ScalingContainer(
                  onTap: scope.startCycling,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [colors.gradientStart, colors.gradientEnd]),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      LocaleKeys.answer_book_ask_again.tr(),
                      style: m15w600(context).copyWith(color: colors.textOnPrimary),
                    ),
                  ),
                ),
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.borderSecondary, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.primary, size: 26.r),
          SizedBox(height: 8.h),
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
