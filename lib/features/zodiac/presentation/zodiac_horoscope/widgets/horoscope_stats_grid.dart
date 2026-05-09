part of '../pages/zodiac_horoscope_page.dart';

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.categories});
  final List<HoroscopeStatCategory> categories;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final row1 = categories.take(3).toList();
    final row2 = categories.skip(3).toList();

    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Column(
        children: [
          Row(
            children: [
              for (int i = 0; i < row1.length; i++) ...[
                Expanded(child: _StatCell(category: row1[i])),
                if (i < row1.length - 1)
                  Container(width: 1, height: 60.h, color: colors.border),
              ],
            ],
          ),
          Container(height: 1, color: colors.border),
          Row(
            children: [
              for (int i = 0; i < row2.length; i++) ...[
                Expanded(child: _StatCell(category: row2[i])),
                if (i < row2.length - 1)
                  Container(width: 1, height: 60.h, color: colors.border),
              ],
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.category});
  final HoroscopeStatCategory category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Sp.small.padAllR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${category.emoji} ', style: m13w500(context)),
              Expanded(
                child: Text(
                  category.labelKey.tr(),
                  style: m11w500(context).copyWith(color: context.colors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Sp.xsmall.heightBox,
          Text('${category.score}%', style: m14w700(context)),
          Sp.xsmall.heightBox,
          ClipRRect(
            borderRadius: Sp.tiny.radiusR,
            child: LinearProgressIndicator(
              value: category.score / 100,
              minHeight: 5.h,
              backgroundColor: category.barColor.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(category.barColor),
            ),
          ),
        ],
      ),
    );
  }
}
