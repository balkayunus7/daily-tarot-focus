import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_detail_content.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotDeckDetailPage extends StatelessWidget {
  const TarotDeckDetailPage({required this.tarotId, super.key});
  final String tarotId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TarotLocalizationCubit, TarotLocalizationState>(
      builder: (context, locState) {
        final cubit = context.read<TarotLocalizationCubit>();
        final tarot =
            cubit.getByTitle(tarotId) ??
            (locState.allCards.isNotEmpty ? locState.allCards.first : null);

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
