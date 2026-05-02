import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/features/core/home/home_page.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reveal/pages/tarot_reveal_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin RevealDetailPageMixin on State<TarotRevealDetailPage> {
  void saveDailyCard() {
    if (context.read<TarotBloc>().state.isRecordDailyCard) return;
    context.read<TarotBloc>().addRecordDailyCardRequested(
      request: RecordDailyCardRequest(
        session: context.read<AuthCubit>().state.sessionOrCrash,
        cardId: widget.tarot.id,
      ),
    );
  }

  void onBack() {
    context.go(AppRoutes.tarotExplore, extra: HomePageArguments(context));
  }

  void onSaveSucceeded() {
    context.go(AppRoutes.tarotDailyCalendar);
  }
}
