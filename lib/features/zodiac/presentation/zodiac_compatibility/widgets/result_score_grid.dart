part of '../pages/zodiac_compatibility_result_page.dart';

class ScoreGrid extends StatelessWidget {
  const ScoreGrid({required this.result, super.key});
  final CompatibilityResult result;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cats = result.categories;

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
              Expanded(child: _ScoreCell(category: cats[0])),
              Container(width: 1, height: 60.h, color: colors.border),
              Expanded(child: _ScoreCell(category: cats[1])),
              Container(width: 1, height: 60.h, color: colors.border),
              Expanded(child: _ScoreCell(category: cats[2])),
            ],
          ),
          Container(height: 1, color: colors.border),
          Row(
            children: [
              Expanded(child: _ScoreCell(category: cats[3])),
              Container(width: 1, height: 60.h, color: colors.border),
              Expanded(child: _ScoreCell(category: cats[4])),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreCell extends StatelessWidget {
  const _ScoreCell({required this.category});
  final CompatibilityCategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Sp.small.padAllR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.labelKey.tr(),
            style: m11w500(context).copyWith(color: context.colors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
