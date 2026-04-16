import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:flutter/material.dart';

class ReadingEmptyWidget extends StatelessWidget {
  const ReadingEmptyWidget({required this.message, required this.onTap, super.key});
  final String message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Bir hata olustu',
          style: m16w700(context),
        ),
        Sp.xxlarge.heightBox,
        TarotButton(
          onTap: onTap,
          buttonText: message,
          paddingHorizontal: 20,
          width: 128,
          height: 40,
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
