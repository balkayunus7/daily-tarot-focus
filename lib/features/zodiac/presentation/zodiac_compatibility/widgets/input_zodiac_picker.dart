part of '../pages/zodiac_compatibility_input_page.dart';

class ZodiacPicker extends StatefulWidget {
  const ZodiacPicker({required this.isMe, super.key});
  final bool isMe;

  @override
  State<ZodiacPicker> createState() => _ZodiacPickerState();
}

class _ZodiacPickerState extends State<ZodiacPicker> {
  @override
  Widget build(BuildContext context) {
    final state = ZodiacCompatibilityPageScope.of(context).state;
    final notifier = state.getSignNotifier(isMe: widget.isMe);

    final pageController = state.getPageController(isMe: widget.isMe);
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, child) {
        return SizedBox(
          height: 120.h,
          child: PageView.builder(
            controller: pageController,
            itemCount: ZodiacSign.values.length,
            onPageChanged: (value) => HapticFeedbackHelper.lightImpact(),
            itemBuilder: (context, index) {
              final sign = ZodiacSign.values[index % 12];
              final distance = (index - state.getCurrentPage(isMe: widget.isMe)).abs();
              final opacity = (1.0 - distance * 0.45).clamp(0.45, 1.0);
              final isCenter = distance < 0.5;
              return Transform.scale(
                scale: isCenter ? 1.3 : 0.85,
                child: Opacity(
                  opacity: opacity,
                  child: ZodiacPickerItem(sign: sign, isSelected: isCenter),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ZodiacPickerItem extends StatelessWidget {
  const ZodiacPickerItem({required this.sign, required this.isSelected, super.key});
  final ZodiacSign sign;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FancyContainer(
          padding: Sp.medium.padAllR,
          borderRadius: Sp.huge,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.gradientStart, colors.gradientEnd],
          ),
          child: SvgPicture.asset(
            sign.svgPath,
            width: 32.w,
            height: 32.w,
            colorFilter: ColorFilter.mode(colors.textOnPrimary, BlendMode.srcIn),
          ),
        ),
        Sp.xsmall.heightBox,
        Text(
          sign.localizedName,
          style: m11w500(context).copyWith(
            color: isSelected ? colors.textPrimary : colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
