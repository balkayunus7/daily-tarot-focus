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
        FancyButton(
          onTap: onTap,
          text: message,
          width: 160.w,
          height: 40.h,
          textStyle: m10w600(context).copyWith(color: context.colors.textOnPrimary),
        ),
        Sp.xxlarge.heightBox,
        CustomCacheNetworkImage(
          imageUrl: TarotAppAssets.emptyHttp,
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.3,
        ),
      ],
    );
  }
}
