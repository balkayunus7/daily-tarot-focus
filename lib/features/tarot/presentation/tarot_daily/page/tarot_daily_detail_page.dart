import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_detail_content.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TarotDailyDetailPage extends StatelessWidget {
  const TarotDailyDetailPage({required this.tarot, super.key});
  final TarotCardModel tarot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TarotAppBar(
        title: tarot.name,
        onBackIconTap: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SharedTarotDetailPageContent(tarot: tarot, showMeaningForDay: true),
        ),
      ),
    );
  }
}
