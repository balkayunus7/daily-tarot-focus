import 'package:daily_tarot_focus/core/util/font_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_button.dart';
import 'package:daily_tarot_focus/features/auth/application/register_cubit.dart';
import 'package:daily_tarot_focus/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class RegisterStep3BirthdatePage extends StatefulWidget {
  const RegisterStep3BirthdatePage({super.key});
  static const route = '/register-step-3-birthdate';

  @override
  State<RegisterStep3BirthdatePage> createState() =>
      _RegisterStep3BirthdatePageState();
}

class _RegisterStep3BirthdatePageState
    extends State<RegisterStep3BirthdatePage> {
  DateTime? _selectedDate;

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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.registerStatus.isSuccess) {
            context.goNamed(HomePage.route);
          } else if (state.registerStatus.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to complete registration'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Step 3 of 3',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'When were you born?',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your birth date helps us calculate your cosmic path',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 1,
                  backgroundColor: colors.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                ),
                const SizedBox(height: 60),
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: colors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  _selectedDate != null
                                      ? colors.primary
                                      : colors.border,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child:
                                _selectedDate == null
                                    ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: colors.textSecondary,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Select Date',
                                          style: TextStyle(
                                            color: colors.textSecondary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${_selectedDate!.day}',
                                          style: TextStyle(
                                            color: colors.primary,
                                            fontSize: 64,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          _getMonthName(_selectedDate!.month),
                                          style: TextStyle(
                                            color: colors.textPrimary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${_selectedDate!.year}',
                                          style: TextStyle(
                                            color: colors.textSecondary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (_selectedDate != null)
                        Text(
                          _getAgeText(_selectedDate!),
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return TarotButton(
                      buttonText: 'Complete Registration',
                      onTap: () async {
                        final authState = context.read<AuthCubit>().state;
                        await context.read<RegisterCubit>().submitRegistration(
                          authState.sessionOrCrash,
                        );
                      },
                      buttonTextStyle: n16w700(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _getAgeText(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return 'You are $age years old';
  }
}
