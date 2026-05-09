part of '../pages/zodiac_horoscope_page.dart';

class _HoroscopeCategoryTile extends StatefulWidget {
  const _HoroscopeCategoryTile({required this.category});
  final HoroscopeStatCategory category;

  @override
  State<_HoroscopeCategoryTile> createState() => _HoroscopeCategoryTileState();
}

class _HoroscopeCategoryTileState extends State<_HoroscopeCategoryTile>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<bool> _isExpanded;
  late final AnimationController _animController;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = ValueNotifier(false);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _isExpanded.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    _isExpanded.value = !_isExpanded.value;
    if (_isExpanded.value) {
      await _animController.forward();
    } else {
      await _animController.reverse();
    }
  }

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
            valueListenable: _isExpanded,
            builder: (context, expanded, _) {
              return InkWell(
                onTap: _toggle,
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
                        turns: expanded ? 0.5 : 0,
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
            sizeFactor: _expandAnimation,
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
