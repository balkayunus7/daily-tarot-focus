import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_flow_type.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/widgets/spread_reader_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotSpreadStep1Page extends StatelessWidget {
  const TarotSpreadStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<TarotBloc, TarotState>(
      builder: (context, state) {
        final readers = state.readersOrEmpty;

        return Scaffold(
          backgroundColor: colors.background,
          appBar: TarotAppBar(
            titleWidget: Column(
              children: [
                Text(LocaleKeys.tarot_question_reader_step_title.tr(), style: m16w700(context)),
                Sp.tiny.heightBox,
                Text(
                  LocaleKeys.tarot_question_step_1_of_5.tr(),
                  style: m10w500(context).copyWith(
                    color: colors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: Sp.medium.padXR,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Sp.small.heightBox,
                        Text(
                          LocaleKeys.tarot_question_choose_reader_subtitle.tr(),
                          style: m14w400(context).copyWith(color: colors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        Sp.xlarge.heightBox,
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: readers.size,
                          separatorBuilder: (_, _) => Sp.small.heightBox,
                          itemBuilder: (context, index) {
                            final reader = readers[index];

                            return SpreadReaderCard(
                              reader: reader,
                              onTap: () async {
                                final bloc =
                                    context.read<TarotBloc>()..addSelectReader(reader: reader);
                                if (state.flowType == TarotFlowType.threeCard) {
                                  final threeCardCat =
                                      state.spreadsOrEmpty
                                          .asList()
                                          .where((c) => c.id == 'cat_3_cards')
                                          .firstOrNull;
                                  if (threeCardCat != null) {
                                    bloc.addSelectSpreadCategory(category: threeCardCat);
                                  }
                                  await context.push(AppRoutes.tarotQuestionStep3);
                                } else {
                                  await context.push(AppRoutes.tarotQuestionStep2);
                                }
                              },
                            );
                          },
                        ),
                        Sp.xlarge.heightBox,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
