part of '../pages/zodiac_compatibility_input_page.dart';

class GenderPicker extends StatelessWidget {
  const GenderPicker({required this.isMe, super.key});
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final state = ZodiacCompatibilityPageScope.of(context).state;
    final notifier = state.getGenderNotifier(isMe: isMe);

    return ValueListenableBuilder<CompatGender>(
      valueListenable: notifier,
      builder: (_, gender, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _GenderButton(
              isSelected: gender.isFemale,
              genderSvgPath: TarotAppAssets.female.path,
              label: LocaleKeys.compat_page_gender_female.tr(),
              onTap: () => notifier.value = CompatGender.female,
            ),
            Sp.small.widthBox,
            _GenderButton(
              isSelected: gender.isMale,
              genderSvgPath: TarotAppAssets.male.path,
              label: LocaleKeys.compat_page_gender_male.tr(),
              onTap: () => notifier.value = CompatGender.male,
            ),
          ],
        );
      },
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.isSelected,
    required this.genderSvgPath,
    required this.label,
    required this.onTap,
  });
  final String genderSvgPath;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ScalingContainer(
      onTap: () async {
        await HapticFeedbackHelper.lightImpact();
        onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isSelected
                      ? colors.primary.withValues(alpha: 0.18)
                      : colors.primary.withValues(alpha: 0.06),
              border: Border.all(
                color:
                    isSelected
                        ? colors.primary
                        : colors.primary.withValues(alpha: 0.2),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Center(
              child: SvgPicture.asset(
                genderSvgPath,
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  isSelected ? colors.primary : colors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Sp.tiny.heightBox,
          Text(
            label,
            style: m11w500(context).copyWith(
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
