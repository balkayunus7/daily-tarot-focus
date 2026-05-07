part of '../pages/zodiac_compatibility_result_page.dart';

class CategoryTile extends StatefulWidget {
  const CategoryTile({required this.category, super.key});
  final CompatibilityCategoryModel category;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile>
    with SingleTickerProviderStateMixin, ZodiacCompatibilityPageMixin {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final category = widget.category;

    return FancyContainer(
      width: double.infinity,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: isExpanded,
            builder: (context, expanded, child) {
              return InkWell(
                onTap: toggle,
                borderRadius: Sp.large.radiusR,
                child: Padding(
                  padding: Sp.medium.padAllR,
                  child: Row(
                    children: [
                      Text('${category.emoji} ', style: m16w700(context)),
                      Sp.tiny.widthBox,
                      Expanded(
                        child: Text(
                          '${category.labelKey.tr()} • ${category.score}%',
                          style: m14w600(context),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded.value ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: colors.textSecondary,
                          size: 22.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizeTransition(
            sizeFactor: expandAnimation,
            child: Padding(
              padding: EdgeInsets.fromLTRB(Sp.medium.w, 0, Sp.medium.w, Sp.medium.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1, color: colors.border),
                  Sp.small.heightBox,
                  ClipRRect(
                    borderRadius: Sp.tiny.radiusR,
                    child: LinearProgressIndicator(
                      value: category.score / 100,
                      minHeight: 6.h,
                      backgroundColor: category.barColor.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(category.barColor),
                    ),
                  ),
                  Sp.medium.heightBox,
                  Text(
                    category.description,
                    style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
