part of '../page/tarot_daily_page.dart';

class DailyEmptyWidget extends StatelessWidget {
  const DailyEmptyWidget({required this.message, required this.onTap, super.key});
  final String message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GlassButton(
          onTap: onTap,
          buttonText: message,
          width: 168.w,
          height: 48.h,
          buttonTextStyle: m10w600(context).copyWith(color: context.colors.textOnPrimary),
        ),
        Sp.xxlarge.heightBox,
        Image.asset(
          TarotAppAssets.empty.path,
          height: MediaQuery.of(context).size.height * 0.3,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
