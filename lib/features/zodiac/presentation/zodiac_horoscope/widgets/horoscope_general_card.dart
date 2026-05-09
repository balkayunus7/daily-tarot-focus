part of '../pages/zodiac_horoscope_page.dart';

class _GeneralCard extends StatelessWidget {
  const _GeneralCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('✨ ', style: m16w700(context)),
              Text(
                LocaleKeys.horoscope_page_general_label.tr(),
                style: m16w700(context).copyWith(color: colors.textPrimary),
              ),
            ],
          ),
          Sp.small.heightBox,
          Text(
            text,
            style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.65),
          ),
        ],
      ),
    );
  }
}
