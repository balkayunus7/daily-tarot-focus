import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_question/tarot_question_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_question/tarot_question_state.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_question/widgets/question_reader_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotQuestionStep1Page extends StatelessWidget {
  const TarotQuestionStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<TarotQuestionBloc, TarotQuestionState>(
      builder: (context, state) {
        final readers = state.readersOrCrash;

        return Scaffold(
          backgroundColor: colors.background,
          appBar: TarotAppBar(
            titleWidget: Column(
              children: [
                Text('Açılım Yolculuğu', style: m16w700(context)),
                Sp.tiny.heightBox,
                Text(
                  'ADIM 1 / 3',
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
                          'Sana rehberlik edecek okuyucunu seç.',
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

                            return ReaderCard(
                              reader: reader,
                              onTap: () async {
                                context.read<TarotQuestionBloc>().addReaderSelected(reader);
                                await context.push(AppRoutes.tarotQuestionStep2);
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
