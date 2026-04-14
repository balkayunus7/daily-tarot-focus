import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/helpers/spread_category_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/guide_promo_card.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/spread_category_card.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotQuestionPage extends StatelessWidget {
  const TarotQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: TarotAppBar(
        titleWidget: Column(
          children: [
            Text('Açılım Yolculuğu', style: m16w700(context)),
            Spacing.tinyH,
            Text(
              'ADIM 1 / 4',
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
          padding: const EdgeInsets.symmetric(horizontal: SpacingConsts.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacing.smallH,
              Text(
                'Bir odak noktası seçerek kehanetleri keşfet.',
                style: m14w400(context).copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              Spacing.xlargeH,
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: mockSpreadCategories.length,
                separatorBuilder: (context, index) => Spacing.smallH,
                itemBuilder: (context, index) {
                  final category = mockSpreadCategories[index];
                  return SpreadCategoryCard(
                    title: category.title,
                    icon: category.icon,
                    onTap: () {},
                  );
                },
              ),
              Spacing.xlargeH,
              GuidePromoCard(onTap: () {}),
              Spacing.xxlargeH,
            ],
          ),
        ),
      ),
    );
  }
}
