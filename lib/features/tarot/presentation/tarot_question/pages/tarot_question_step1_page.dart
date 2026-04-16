import 'dart:async';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_spread/tarot_spread_cubit.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_spread/tarot_spread_state.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/helpers/spread_category_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/guide_promo_card.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/spread_category_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotQuestionStep1Page extends StatelessWidget {
  const TarotQuestionStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider(
      create: (context) {
        final cubit = getIt<TarotSpreadCubit>();
        unawaited(cubit.loadSpreads());
        return cubit;
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: TarotAppBar(
          titleWidget: Column(
            children: [
              Text('Açılım Yolculuğu', style: m16w700(context)),
              Sp.tiny.heightBox,
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
        body: BlocBuilder<TarotSpreadCubit, TarotSpreadState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.isError) {
              return Center(child: Text(state.errorMessage ?? 'Hata oluştu'));
            }
            if (state.isSuccess) {
              final categories = state.categories;
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
                          final categoryData = categories.firstWhere(
                            (c) => c.categoryId == meta.categoryId,
                          );

                          return SpreadCategoryCard(
                            title: categoryData.title,
                            subtitle: '${categoryData.spreads.length} Açılım',
                            icon: meta.icon,
                            onTap: () async {
                              await context.pushNamed(
                                AppRoutes.tarotSpreadSelect,
                                extra: categoryData,
                              );
                            },
                          );
                        },
                      ),
                      Sp.xlarge.heightBox,
                      GuidePromoCard(onTap: () {}),
                      Sp.xxlarge.heightBox,
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
