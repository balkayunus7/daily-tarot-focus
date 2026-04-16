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
          paddingHorizontal: 20,
          width: 168,
          height: 48,
          buttonTextStyle: m10w600(context),
          borderRadius: Sp.xlarge.radiusR,
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
