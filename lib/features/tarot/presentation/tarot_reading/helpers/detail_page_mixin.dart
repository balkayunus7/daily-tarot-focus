import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/update_reading_note_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/pages/tarot_reading_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin DetailPageMixin on State<TarotReadingDetailPage> {
  late final TextEditingController notesController;
  final ValueNotifier<bool> isDirty = ValueNotifier(false);
  late String _lastSavedNote;

  @override
  void initState() {
    super.initState();
    _lastSavedNote = widget.reading.note ?? '';
    notesController = TextEditingController(text: _lastSavedNote);
    notesController.addListener(_onNotesChanged);
  }

  void _onNotesChanged() {
    isDirty.value = notesController.text.trim() != _lastSavedNote.trim();
  }

  void onSaveNote() {
    final session = context.read<AuthCubit>().state.sessionOrCrash;
    final note = notesController.text.trim().isEmpty ? null : notesController.text.trim();
    context.read<TarotBloc>().addUpdateReadingNoteRequested(
      request: UpdateReadingNoteRequest(
        session: session,
        readingId: widget.reading.id,
        note: note,
      ),
    );
  }

  void onUpdateNoteSucceeded() {
    _lastSavedNote = notesController.text.trim();
    isDirty.value = false;
  }

  @override
  void dispose() {
    notesController
      ..removeListener(_onNotesChanged)
      ..dispose();
    isDirty.dispose();
    super.dispose();
  }
}
