import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_spread/pages/tarot_spread_step4_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin Step4PageMixin on State<TarotSpreadStep4Page> {
  static const int maxChars = 120;

  late final TextEditingController questionController;
  late final FocusNode questionFocusNode;
  final ValueNotifier<int> charCount = ValueNotifier(0);
  final ValueNotifier<bool> isFocused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController();
    questionFocusNode = FocusNode();
    questionController.addListener(() => charCount.value = questionController.text.length);
    questionFocusNode.addListener(() => isFocused.value = questionFocusNode.hasFocus);
  }

  @override
  void dispose() {
    questionController.dispose();
    questionFocusNode.dispose();
    charCount.dispose();
    isFocused.dispose();
    super.dispose();
  }

  Future<void> onNext() async {
    context.read<TarotBloc>().addSelectQuestion(question: questionController.text);
    await context.push(AppRoutes.tarotQuestionStep5);
  }
}
