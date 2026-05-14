import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/widgets/city_picker_sheet.dart';
import 'package:daily_tarot_focus/features/auth/bloc/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

mixin PersonalInfoMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController nameController;
  late final ValueNotifier<DateTime?> selectedBirthDate;
  late final ValueNotifier<TimeOfDay?> selectedBirthTime;
  late final ValueNotifier<String?> selectedCityName;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    selectedBirthDate = ValueNotifier<DateTime?>(null);
    selectedBirthTime = ValueNotifier<TimeOfDay?>(null);
    selectedCityName = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    nameController.dispose();
    selectedBirthDate.dispose();
    selectedBirthTime.dispose();
    selectedCityName.dispose();
    super.dispose();
  }

  bool get isFormValid =>
      nameController.text.trim().isNotEmpty &&
      selectedBirthDate.value != null &&
      selectedBirthTime.value != null &&
      selectedCityName.value != null;

  void onNameChanged(String value) {
    context.read<RegisterCubit>().setName(value);
  }

  Future<void> pickDate() async {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthDate.value ?? DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (ctx, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: colorScheme.primary,
              onPrimary: colorScheme.onPrimary,
              surface: colorScheme.surface,
              onSurface: colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      selectedBirthDate.value = picked;
      context.read<RegisterCubit>().setBirthDate(picked);
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null && mounted) {
      selectedBirthTime.value = picked;
      context.read<RegisterCubit>().setBirthTime(picked);
    }
  }

  Future<void> pickCity() async {
    final colors = context.colors;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Sp.xlarge)),
      ),
      builder: (_) => CityPickerSheet(onCitySelected: _onCitySelected),
    );
  }

  void _onCitySelected(String name, double lat, double lon, String? zoneName) {
    selectedCityName.value = name;
    context.read<RegisterCubit>().setCity(name, lat, lon, zoneName);
  }

  Future<void> submitRegistration() async {
    final authState = context.read<AuthCubit>().state;
    await context.read<RegisterCubit>().submitRegistration(
      authState.sessionOrCrash,
    );
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} / '
        '${date.month.toString().padLeft(2, '0')} / '
        '${date.year}';
  }
}
