import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_detail_content.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/helpers/reveal_detail_page_mixin.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/helpers/reveal_detail_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_toast_ext.dart';

class TarotRevealDetailPage extends StatefulWidget {
  const TarotRevealDetailPage({required this.tarot, super.key});
  final TarotCardModel tarot;

  @override
  State<TarotRevealDetailPage> createState() => _TarotRevealDetailPageState();
}

class _TarotRevealDetailPageState extends State<TarotRevealDetailPage> with RevealDetailPageMixin {
  @override
  Widget build(BuildContext context) {
    return RevealDetailPageScope(
      state: this,
      child: BlocConsumer<TarotBloc, TarotState>(
        listenWhen: (previous, current) {
          return previous.hasRecordDailyCardSucceeded != current.hasRecordDailyCardSucceeded ||
              previous.hasRecordDailyCardFailed != current.hasRecordDailyCardFailed;
        },
        listener: (context, state) {
          if (state.hasRecordDailyCardFailed) {
            context.showToastMessage('Kart Kaydedilemedi!!');
          }
          if (state.hasRecordDailyCardSucceeded) {
            context.showToastMessage('Kart Kaydedildi');
            onSaveSucceeded();
          }
        },
        builder: (context, state) {
          final isSaving = state.isRecordDailyCard;
          return Scaffold(
            appBar: TarotAppBar(
              title: 'The Ethereal Archive',
              titleStyle: m18w600(context).copyWith(
                fontStyle: FontStyle.italic,
                color: context.colors.primary,
              ),
              onBackIconTap: onBack,
              backIcon: Icons.close,
              trailingIcon: isSaving ? FontAwesomeIcons.spinner : FontAwesomeIcons.floppyDisk,
              onIconTap: saveDailyCard,
            ),
            body: TarotDetailContent(tarot: widget.tarot),
          );
        },
      ),
    );
  }
}
