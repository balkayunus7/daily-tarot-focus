import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/helpers/spread_category_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/spread_category_card.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/spread_category_guide.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotQuestionStep2Page extends StatelessWidget {
  const TarotQuestionStep2Page({super.key});

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
              'ADIM 2 / 3',
              style: m10w500(context).copyWith(
                color: colors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<TarotBloc, TarotState>(
        builder: (context, state) {
          final categories = state.spreadsOrEmpty;

          return SafeArea(
            child: SingleChildScrollView(
              padding: Sp.medium.padXR,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Sp.small.heightBox,
                  Text(
                    'Bir odak noktası seçerek kehanetleri keşfet.',
                    style: m14w400(context).copyWith(color: colors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  Sp.xlarge.heightBox,
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: mockSpreadCategories.length,
                    separatorBuilder: (context, index) => Sp.small.heightBox,
                    itemBuilder: (context, index) {
                      final meta = mockSpreadCategories[index];
                      final categoryData = categories.firstOrNull(
                        (category) => category.id == meta.categoryId,
                      );

                      if (categoryData == null) return const SizedBox.shrink();

                      return SpreadCategoryCard(
                        title: categoryData.title,
                        subtitle: '${categoryData.spreads.size} Açılım',
                        icon: meta.icon,
                        onTap: () async {
                          context.read<TarotBloc>().addSelectSpreadCategory(category: categoryData);
                          await context.push(AppRoutes.tarotQuestionStep3);
                        },
                      );
                    },
                  ),
                  Sp.xlarge.heightBox,
                  SpreadCategoryGuide(onTap: () {}),
                  Sp.xxlarge.heightBox,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
