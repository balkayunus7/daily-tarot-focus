import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/save_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/pages/tarot_reading_answer_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

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
    final session = context.read<AuthCubit>().state.sessionOrCrash;
    final tarotState = context.read<TarotBloc>().state;
    final response = tarotState.generateReadingResponseOrNull;
    if (response == null) return;
    context.read<TarotBloc>().addSaveReadingRequested(
      request: SaveReadingRequest(
        session: session,
        spreadId: response.spreadId,
        readerId: tarotState.selectedReader?.id,
        question: tarotState.selectedQuestion,
        cardInterpretations: response.cardInterpretations,
        generalInterpretation: response.generalInterpretation,
        note: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
      ),
    );
  }
}
