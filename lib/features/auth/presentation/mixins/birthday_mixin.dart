part of '../pages/register_step_birthdate_page.dart';

mixin BirthdayMixin on State<RegisterStepBirthdatePage> {
  DateTime? _selectedDate;

  bool get isSelected => _selectedDate != null;

  Future<void> _selectDate(BuildContext context) async {
    final colors = context.colors;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: colors.primary,
              onPrimary: Colors.white,
              surface: colors.surface,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      if (!context.mounted) return;
      context.read<RegisterCubit>().selectBirthDate(picked);
    }
  }

  void showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to complete registration'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
