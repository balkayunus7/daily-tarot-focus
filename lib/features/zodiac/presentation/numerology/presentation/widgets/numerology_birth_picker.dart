part of '../pages/numerology_input_page.dart';

class NumerologyBirthPicker extends StatelessWidget {
  const NumerologyBirthPicker({super.key});

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = NumerologyInputPageScope.of(context).state;

    return ValueListenableBuilder(
      valueListenable: scope.birthDate,
      builder: (context, value, _) {
        return GestureDetector(
          onTap: scope.pickBirthDate,
          child: FancyContainer(
            width: double.infinity,
            padding: Sp.medium.padAllR,
            color: colors.textSecondary.withValues(alpha: 0.06),
            border: Border.all(color: colors.border),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: colors.primary, size: 22.sp),
                Sp.medium.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.numerology_page_birth_date_label.tr(),
                        style: m11w500(context).copyWith(color: colors.textSecondary),
                      ),
                      Sp.tiny.heightBox,
                      Text(
                        value != null
                            ? _formatDate(value)
                            : LocaleKeys.numerology_page_pick_date_hint.tr(),
                        style: value != null
                            ? m16w700(context)
                            : m14w500(context).copyWith(
                                color: colors.textSecondary.withValues(alpha: 0.6),
                              ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colors.textSecondary.withValues(alpha: 0.5),
                  size: 22.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
