part of '../pages/zodiac_horoscope_page.dart';

class _ReminderCard extends StatelessWidget {
  const _ReminderCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.horoscope_page_reminder_title.tr(),
                  style: m14w600(context),
                ),
                Sp.medium.heightBox,
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sp.medium.w,
                      vertical: Sp.small.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.textPrimary,
                      borderRadius: Sp.large.radiusR,
                    ),
                    child: Text(
                      LocaleKeys.horoscope_page_reminder_button.tr(),
                      style: m13w600(context).copyWith(color: colors.textOnPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Sp.medium.widthBox,
          Text('🔔', style: TextStyle(fontSize: 48.sp)),
        ],
      ),
    );
  }
}
