import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_confirm_dialog.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/delete_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/update_reading_note_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_reading/pages/tarot_reading_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    FocusScope.of(context).unfocus();
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

  Future<void> handleBackPress() async {
    debugPrint('[handleBackPress] called — isDirty=${isDirty.value}');
    if (!isDirty.value) {
      debugPrint('[handleBackPress] not dirty → calling context.pop()');
      if (mounted) context.pop();
      return;
    }
    final confirmed = await TarotConfirmDialog.show(
      context,
      title: LocaleKeys.tarot_reading_unsaved_title.tr(),
      body: LocaleKeys.tarot_reading_unsaved_desc.tr(),
      cancelText: LocaleKeys.tarot_reading_unsaved_discard.tr(),
      confirmText: LocaleKeys.tarot_reading_save.tr(),
    );
    if (!mounted) return;
    if (confirmed ?? false) onSaveNote();
    if (confirmed != null) {
      isDirty.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pop();
      });
    }
  }

  void onUpdateNoteSucceeded() {
    _lastSavedNote = notesController.text.trim();
    isDirty.value = false;
  }

  Future<void> onDeleteReading() async {
    final confirmed = await TarotConfirmDialog.show(
      context,
      title: LocaleKeys.tarot_reading_delete_title.tr(),
      body: LocaleKeys.tarot_reading_delete_desc.tr(),
      cancelText: LocaleKeys.tarot_reading_unsaved_discard.tr(),
      confirmText: LocaleKeys.tarot_reading_delete_confirm.tr(),
    );
    if (!mounted || confirmed != true) return;
    final session = context.read<AuthCubit>().state.sessionOrCrash;
    context.read<TarotBloc>().addDeleteReadingRequested(
      request: DeleteReadingRequest(session: session, readingId: widget.reading.id),
    );
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
