import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_flow_type.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/spread_layout_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotQuestionStep3Page extends StatelessWidget {
  const TarotQuestionStep3Page({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<TarotBloc, TarotState>(
      builder: (context, state) {
        final category = state.selectedSpreadCategory;
        if (category == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: colors.background,
          appBar: TarotAppBar(
            titleWidget: Column(
              children: [
                Text(LocaleKeys.tarot_question_spread_step_title.tr(), style: m16w700(context)),
                Sp.tiny.heightBox,
                Text(
                  LocaleKeys.tarot_question_step_3_of_6.tr(),
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
                    LocaleKeys.tarot_question_choose_spread_subtitle.tr(),
                    style: m14w400(context).copyWith(color: colors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  Sp.xlarge.heightBox,
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: category.spreads.size,
                    separatorBuilder: (context, index) => Sp.medium.heightBox,
                    itemBuilder: (context, index) {
                      final spread = category.spreads[index];
                      return SpreadLayoutCard(
                        spread: spread,
                        onTap: () async {
                          context.read<TarotBloc>().addSelectSpread(spread: spread);
                          if (state.flowType == TarotFlowType.threeCard) {
                            await context.push(AppRoutes.tarotQuestionStep4);
                          } else {
                            await context.push(AppRoutes.tarotQuestionStep5);
                          }
                        },
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
      },
    );
  }
}

class _QuoteSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Sp.huge.padXR,
      child: Column(
        children: [
          Text(
            LocaleKeys.tarot_question_quote_future.tr(),
            style: m14w600(context).copyWith(
              fontStyle: FontStyle.italic,
              color: context.colors.textSecondary.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
