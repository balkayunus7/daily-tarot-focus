import 'package:daily_tarot_focus/application/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/application/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_detail_content.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';
import 'package:daily_tarot_focus/presentation/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotRevealDetailPage extends StatelessWidget {
  const TarotRevealDetailPage({required this.tarot, super.key});
  final TarotCard tarot;

  void saveDailyCard(BuildContext context, {required bool isSaving}) {
    if (isSaving) return;

    final authState = context.read<AuthCubit>().state;
    final langCode = Localizations.localeOf(context).languageCode;

    context.read<TarotBloc>().addDailyCardSaved(
      session: authState.sessionOrCrash,
      tarotCardId: tarot.id,
      languageCode: langCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TarotBloc, TarotState>(
      listenWhen: (previous, current) => previous.hasSavedDailyCard != current.hasSavedDailyCard,
      listener: (context, state) {
        if (state.hasSavedDailyCardFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kart kaydedilemedi')),
          );
        }
        if (state.hasSavedDailyCardSucceeded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kart kaydedildi ✨')),
          );
          context.go(AppRoutes.tarotExplore, extra: HomePageArguments(context, initialTabIndex: 1));
        }
      },
      builder: (context, state) {
        final isSaving = state.isSavingDailyCard;
        return Scaffold(
          appBar: TarotAppBar(
            title: tarot.title,
            onBackIconTap: () {
              context.go(AppRoutes.tarotExplore, extra: HomePageArguments(context));
            },
            backIcon: Icons.close,
            trailingIcon: isSaving ? FontAwesomeIcons.spinner : FontAwesomeIcons.floppyDisk,
            onIconTap: () => saveDailyCard(context, isSaving: isSaving),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: SharedTarotDetailPageContent(tarot: tarot, showMeaningForDay: true),
            ),
          ),
        );
      },
    );
  }
}
