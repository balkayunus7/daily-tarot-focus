import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_spread_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/tarot_spread_card.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotQuestionStep2Page extends StatelessWidget {
  const TarotQuestionStep2Page({required this.category, super.key});
  final TarotSpreadCategoryModel category;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: TarotAppBar(
        titleWidget: Column(
          children: [
            Text('Açılım Yolculuğu', style: m16w700(context)),
            Sp.tiny.heightBox,
            Text(
              'ADIM 2 / 4',
              style: m10w500(context).copyWith(
                color: colors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Sp.medium.padXR,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Sp.small.heightBox,
              Text(
                'İçsel rehberliğini aydınlatacak düzeni belirle.',
                style: m14w400(context).copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              Sp.xxlarge.heightBox,
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: category.spreads.length,
                separatorBuilder: (context, index) => Sp.medium.heightBox,
                itemBuilder: (context, index) {
                  final spread = category.spreads[index];
                  return TarotSpreadCard(
                    spread: spread,
                    onTap: () {},
                  );
                },
              ),
              Sp.xxlarge.heightBox,
              _QuoteSection(),
              Sp.xxlarge.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}

class _QuoteSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '"Gelecek, şu anki düşüncelerinizin bir yansımasıdır."',
          style: m16w600(context).copyWith(
            fontStyle: FontStyle.italic,
            color: context.colors.textSecondary.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
