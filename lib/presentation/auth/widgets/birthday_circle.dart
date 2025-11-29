part of '../pages/register_step_birthdate_page.dart';

class BirthDayCircle extends StatelessWidget {
  const BirthDayCircle({
    required this.selectedDate,
    required this.selectDate,
    super.key,
  });
  final DateTime? selectedDate;
  final VoidCallback selectDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = selectedDate != null;

    return ScalingContainer(
      onTap: selectDate,
      child: Container(
        padding: Spacing.circlePadding,
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: 3,
          ),
        ),
        child: Center(
          child: _BirthdayCircleInfo(selectedDate: selectedDate),
        ),
      ),
    );
  }
}

class _BirthdayCircleInfo extends StatelessWidget {
  const _BirthdayCircleInfo({required this.selectedDate});
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Builder(
      builder: (context) {
        if (selectedDate == null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                color: colors.textSecondary,
                size: 64,
              ),
              Spacing.mediumH,
              Text(
                'Select Date',
                style: m20w600(context),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${selectedDate!.day}',
                style: m64w700(context),
              ),
              Text(
                selectedDate!.monthName(context),
                style: m20w600(context),
              ),
              Text(
                '${selectedDate!.year}',
                style: m16w500(context),
              ),
            ],
          );
        }
      },
    );
  }
}
