import 'package:daily_tarot_focus/application/tarot_localization/tarot_localization_cubit.dart';
import 'package:daily_tarot_focus/core/widgets/base_gradient_layout.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_detail_content.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotDataDetailPage extends StatelessWidget {
  const TarotDataDetailPage({required this.tarotId, super.key});
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
          return BaseGradientLayout(
            appBar: TarotAppBar(title: tarotId),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return _TarotDetailContent(tarot: tarot);
      },
    );
  }
}

class _TarotDetailContent extends StatelessWidget {
  const _TarotDetailContent({required this.tarot});
  final TarotCard tarot;

  @override
  Widget build(BuildContext context) {
    return BaseGradientLayout(
      appBar: TarotAppBar(title: tarot.title),
      child: SafeArea(
        child: SingleChildScrollView(
          child: SharedTarotDetailPageContent(tarot: tarot),
        ),
      ),
    );
  }
}
