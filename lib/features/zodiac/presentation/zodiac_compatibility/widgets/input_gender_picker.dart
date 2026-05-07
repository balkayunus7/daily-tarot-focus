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
              onTap: () => notifier.value = CompatGender.female,
            ),
            Sp.small.widthBox,
            _GenderButton(
              isSelected: gender.isMale,
              genderSvgPath: TarotAppAssets.male.path,
              onTap: () => notifier.value = CompatGender.male,
            ),
            Sp.small.widthBox,
            _GenderButton(
              isSelected: gender.isNonBinary,
              genderSvgPath: TarotAppAssets.nonBinary.path,
              onTap: () => notifier.value = CompatGender.nonBinary,
            ),
          ],
        );
      },
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({required this.isSelected, required this.genderSvgPath, required this.onTap});
  final String genderSvgPath;
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
      child: AnimatedContainer(
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
            color: isSelected ? colors.primary : colors.primary.withValues(alpha: 0.2),
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
    );
  }
}
