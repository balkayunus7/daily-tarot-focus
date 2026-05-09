part of '../pages/zodiac_learn_page.dart';

class BirthInputSheet extends StatefulWidget {
  const BirthInputSheet({required this.type, required this.onSubmit, super.key});
  final DiscoverZodiacType type;
  final Future<void> Function(DateTime date, TimeOfDay time, String? city) onSubmit;

  @override
  State<BirthInputSheet> createState() => _BirthInputSheetState();
}

class _BirthInputSheetState extends State<BirthInputSheet> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    if (_selectedDate == null || _selectedTime == null) return false;
    if (widget.type.isRising && _cityController.text.trim().isEmpty) return false;
    return true;
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Padding(
      padding: EdgeInsets.only(
        left: Sp.screen.w,
        right: Sp.screen.w,
        top: Sp.large.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + Sp.xxxlarge.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.borderSecondary,
                borderRadius: 2.radiusR,
              ),
            ),
          ),
          Sp.large.heightBox,
          Text(LocaleKeys.zodiac_page_birth_info_title.tr(), style: m18w600(context)),
          Sp.large.heightBox,
          _PickerRow(
            label: LocaleKeys.zodiac_page_birth_date.tr(),
            value: _selectedDate != null ? _formatDate(_selectedDate!) : null,
            icon: Icons.calendar_today_outlined,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(1990),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
          ),
          Sp.medium.heightBox,
          _PickerRow(
            label: LocaleKeys.zodiac_page_birth_time.tr(),
            value: _selectedTime?.format(context),
            icon: Icons.access_time_outlined,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 12, minute: 0),
              );
              if (picked != null) setState(() => _selectedTime = picked);
            },
          ),
          if (widget.type.isRising) ...[
            Sp.medium.heightBox,
            Text(
              LocaleKeys.zodiac_page_birth_city.tr(),
              style: m12w600(context).copyWith(color: colors.textSecondary),
            ),
            Sp.xsmall.heightBox,
            FancyContainer(
              width: double.infinity,
              padding: Sp.medium.padAllR,
              color: colors.textSecondary.withValues(alpha: 0.06),
              child: TextField(
                controller: _cityController,
                onChanged: (_) => setState(() {}),
                style: m14w400(context),
                decoration: InputDecoration(
                  hintText: LocaleKeys.zodiac_page_birth_city_hint.tr(),
                  hintStyle: m13w400(context).copyWith(
                    color: colors.textSecondary.withValues(alpha: 0.4),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
          Sp.xlarge.heightBox,
          FancyButton(
            text: LocaleKeys.zodiac_page_calculate.tr(),
            width: double.infinity,
            height: 48.h,
            isDisabled: !_canSubmit,
            textStyle: m14w700(context).copyWith(color: colors.textOnPrimary),
            onTap:
                _canSubmit
                    ? () async {
                      await widget.onSubmit(
                        _selectedDate!,
                        _selectedTime!,
                        widget.type.isRising ? _cityController.text.trim() : null,
                      );
                    }
                    : () {},
          ),
        ],
      ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: FancyContainer(
        width: double.infinity,
        padding: Sp.medium.padAllR,
        color: colors.textSecondary.withValues(alpha: 0.06),
        child: Row(
          children: [
            Icon(icon, color: colors.primary, size: 20.sp),
            Sp.medium.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: m10w500(context).copyWith(color: colors.textSecondary),
                  ),
                  if (value != null) ...[
                    Sp.tiny.heightBox,
                    Text(value!, style: m14w700(context)),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colors.textSecondary.withValues(alpha: 0.5),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
