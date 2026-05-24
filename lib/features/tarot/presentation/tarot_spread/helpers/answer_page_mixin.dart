import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/core/subscription/premium_override_service.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/save_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/pages/tarot_reading_answer_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_time_ext.dart';

mixin AnswerPageMixin on State<TarotReadingAnswerPage> {
  late final TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  void onSave() {
    final authState = context.read<AuthCubit>().state;
    final user = authState.userOrCrash as TarotUser;
    final isPremium = PremiumOverrideService.isPremium(
      user: user,
      networkTime: context.networkNow(),
    );
    if (!isPremium) {
      unawaited(context.push(AppRoutes.subscriptionPaywall));
      return;
    }

    final session = authState.sessionOrCrash;
    final tarotState = context.read<TarotBloc>().state;
    final response = tarotState.generateReadingResponseOrNull;
    if (response == null) {
      return;
    }
    context.read<TarotBloc>().addSaveReadingRequested(
      request: SaveReadingRequest(
        session: session,
        spreadId: response.spreadId,
        readerId: tarotState.selectedReader?.id,
        question: tarotState.selectedQuestion,
        cardInterpretations: response.cardInterpretations,
        generalInterpretation: response.generalInterpretation,
        note:
            notesController.text.trim().isEmpty
                ? null
                : notesController.text.trim(),
      ),
    );
  }
}
