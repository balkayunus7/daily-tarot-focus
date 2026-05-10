import 'package:daily_tarot_focus/features/zodiac/presentation/numerology/presentation/pages/numerology_input_page.dart';
import 'package:flutter/material.dart';

mixin NumerologyInputPageMixin on State<NumerologyInputPage> {
  late final ValueNotifier<DateTime?> birthDate;
  late final TextEditingController fullNameController;
  late final ValueNotifier<String> fullName;

  @override
  void initState() {
    super.initState();
    birthDate = ValueNotifier<DateTime?>(null);
    fullNameController = TextEditingController();
    fullName = ValueNotifier<String>('');
    fullNameController.addListener(() {
      fullName.value = fullNameController.text.trim();
    });
  }

  @override
  void dispose() {
    birthDate.dispose();
    fullNameController.dispose();
    fullName.dispose();
    super.dispose();
  }

  Future<void> pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate.value ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) birthDate.value = picked;
  }
}
