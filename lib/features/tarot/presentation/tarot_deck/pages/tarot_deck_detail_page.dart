import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_detail_content.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotDeckDetailPage extends StatelessWidget {
  const TarotDeckDetailPage({required this.tarotId, super.key});
  final String tarotId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TarotBloc, TarotState>(
      builder: (context, state) {
        final tarot = state.getById(tarotId);

        if (tarot == null) {
          return Scaffold(
            appBar: TarotAppBar(
              title: 'The Ethereal Archive',
              titleStyle: m18w600(context).copyWith(
                fontStyle: FontStyle.italic,
                color: context.colors.primary,
              ),
            ),
            body: Center(child: SpinKitFadingCircle(color: context.colors.primary, size: 32)),
          );
        }

        return _TarotDetailContent(tarot: tarot);
      },
    );
  }
}

class _TarotDetailContent extends StatelessWidget {
  const _TarotDetailContent({required this.tarot});
  final TarotCardModel tarot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TarotAppBar(
        title: 'The Ethereal Archive',
        titleStyle: m18w600(context).copyWith(
          fontStyle: FontStyle.italic,
          color: context.colors.primary,
        ),
      ),
      body: TarotDetailContent(tarot: tarot),
    );
  }
}
