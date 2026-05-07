part of '../pages/zodiac_compatibility_result_page.dart';

class _ShimmerContent extends StatelessWidget {
  const _ShimmerContent({required this.request});
  final GenerateCompatibilityRequestModel request;

  static const List<(String, String)> _cats = [
    ('⚡', LocaleKeys.compat_page_category_sexuality),
    ('🤝', LocaleKeys.compat_page_category_trust),
    ('💬', LocaleKeys.compat_page_category_communication),
    ('💜', LocaleKeys.compat_page_category_emotions),
    ('🌿', LocaleKeys.compat_page_category_values),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final baseColor = colors.textSecondary.withValues(alpha: 0.18);
    final highlightColor = colors.textSecondary.withValues(alpha: 0.55);

    Widget sBox({required double width, required double height, double radius = 8}) =>
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SignAvatar(sign: request.mySign),
            Padding(
              padding: Sp.large.padHR,
              child: Icon(Icons.favorite_rounded, color: colors.error, size: 28.sp),
            ),
            _SignAvatar(sign: request.partnerSign),
          ],
        ),
        Sp.large.heightBox,
        Center(child: sBox(width: 200.w, height: 22.h, radius: 6)),
        Sp.medium.heightBox,
        Container(height: 1, color: colors.border),
        Sp.medium.heightBox,
        sBox(width: 48.w, height: 16.h, radius: 4),
        Sp.xsmall.heightBox,
        sBox(width: double.infinity, height: 8.h, radius: 4),
        Sp.xlarge.heightBox,
        FancyContainer(
          width: double.infinity,
          padding: Sp.medium.padAllR,
          borderRadius: Sp.large,
          color: colors.textSecondary.withValues(alpha: 0.05),
          border: Border.all(color: colors.border),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _scoreCell(context, _cats[0], sBox)),
                  Container(width: 1, height: 60.h, color: colors.border),
                  Expanded(child: _scoreCell(context, _cats[1], sBox)),
                  Container(width: 1, height: 60.h, color: colors.border),
                  Expanded(child: _scoreCell(context, _cats[2], sBox)),
                ],
              ),
              Container(height: 1, color: colors.border),
              Row(
                children: [
                  Expanded(child: _scoreCell(context, _cats[3], sBox)),
                  Container(width: 1, height: 60.h, color: colors.border),
                  Expanded(child: _scoreCell(context, _cats[4], sBox)),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        ),
        Sp.xlarge.heightBox,
        Row(
          children: [
            Text('✨ ', style: m16w700(context)),
            Text(
              LocaleKeys.compat_page_summary_label.tr(),
              style: m16w700(context).copyWith(color: colors.textPrimary),
            ),
          ],
        ),
        Sp.medium.heightBox,
        sBox(width: double.infinity, height: 13.h, radius: 4),
        Sp.xsmall.heightBox,
        sBox(width: double.infinity, height: 13.h, radius: 4),
        Sp.xsmall.heightBox,
        sBox(width: 200.w, height: 13.h, radius: 4),
        Sp.xlarge.heightBox,
        ..._cats.map(
          (cat) => Padding(
            padding: EdgeInsets.only(bottom: Sp.small.h),
            child: _categoryTile(context, cat),
          ),
        ),
      ],
    );
  }

  Widget _scoreCell(
    BuildContext context,
    (String, String) cat,
    Widget Function({required double width, required double height, double radius}) sBox,
  ) {
    return Padding(
      padding: Sp.small.padAllR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cat.$2.tr(),
            style: m11w500(context).copyWith(color: context.colors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Sp.xsmall.heightBox,
          sBox(width: 36.w, height: 16.h, radius: 4),
          Sp.xsmall.heightBox,
          sBox(width: double.infinity, height: 5.h, radius: 3),
        ],
      ),
    );
  }

  Widget _categoryTile(BuildContext context, (String, String) cat) {
    final colors = context.colors;
    return FancyContainer(
      width: double.infinity,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Padding(
        padding: Sp.medium.padAllR,
        child: Row(
          children: [
            Text('${cat.$1} ', style: m16w700(context)),
            Sp.tiny.widthBox,
            Expanded(child: Text(cat.$2.tr(), style: m14w600(context))),
            Icon(Icons.keyboard_arrow_down_rounded, color: colors.textSecondary, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
