part of '../pages/numerology_result_page.dart';

void _showNumerologyInfoSheet(BuildContext context) {
  unawaited(
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _NumerologyInfoSheet(),
    ),
  );
}

class _NumerologyInfoSheet extends StatelessWidget {
  const _NumerologyInfoSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: Sp.small.h),
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: 100.radiusR,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Sp.medium.h),
                child: Text(
                  LocaleKeys.numerology_page_info_sheet_title.tr(),
                  style: m18w700(context),
                ),
              ),
              Container(height: 1, color: colors.border),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(
                    Sp.screen.w,
                    Sp.large.h,
                    Sp.screen.w,
                    Sp.xxxlarge.h + MediaQuery.of(context).padding.bottom,
                  ),
                  children: [
                    _InfoEntry(
                      number: null,
                      icon: Icons.auto_awesome,
                      name: LocaleKeys.numerology_page_info_lp_name.tr(),
                      what: LocaleKeys.numerology_page_info_lp_what.tr(),
                      how: LocaleKeys.numerology_page_info_lp_how.tr(),
                      groupLabel: LocaleKeys.numerology_page_section_life_path.tr(),
                    ),
                    _InfoEntry(
                      number: null,
                      icon: Icons.cake_outlined,
                      name: LocaleKeys.numerology_page_info_bd_name.tr(),
                      what: LocaleKeys.numerology_page_info_bd_what.tr(),
                      how: LocaleKeys.numerology_page_info_bd_how.tr(),
                      groupLabel: LocaleKeys.numerology_page_section_birthday.tr(),
                    ),
                    _GroupDivider(label: LocaleKeys.numerology_page_section_group_name.tr()),
                    _InfoEntry(
                      number: null,
                      icon: Icons.star_outline,
                      name: LocaleKeys.numerology_page_info_dst_name.tr(),
                      what: LocaleKeys.numerology_page_info_dst_what.tr(),
                      how: LocaleKeys.numerology_page_info_dst_how.tr(),
                      groupLabel: LocaleKeys.numerology_page_section_destiny.tr(),
                    ),
                    _InfoEntry(
                      number: null,
                      icon: Icons.favorite_outline,
                      name: LocaleKeys.numerology_page_info_su_name.tr(),
                      what: LocaleKeys.numerology_page_info_su_what.tr(),
                      how: LocaleKeys.numerology_page_info_su_how.tr(),
                      groupLabel: LocaleKeys.numerology_page_section_soul_urge.tr(),
                    ),
                    _InfoEntry(
                      number: null,
                      icon: Icons.person_outline,
                      name: LocaleKeys.numerology_page_info_per_name.tr(),
                      what: LocaleKeys.numerology_page_info_per_what.tr(),
                      how: LocaleKeys.numerology_page_info_per_how.tr(),
                      groupLabel: LocaleKeys.numerology_page_section_personality.tr(),
                    ),
                    _GroupDivider(label: LocaleKeys.numerology_page_section_group_combined.tr()),
                    _InfoEntry(
                      number: null,
                      icon: Icons.timeline_outlined,
                      name: LocaleKeys.numerology_page_info_mat_name.tr(),
                      what: LocaleKeys.numerology_page_info_mat_what.tr(),
                      how: LocaleKeys.numerology_page_info_mat_how.tr(),
                      groupLabel: LocaleKeys.numerology_page_section_maturity.tr(),
                    ),
                    Sp.xlarge.heightBox,
                    _PythagoreanTable(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GroupDivider extends StatelessWidget {
  const _GroupDivider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sp.large.h),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: colors.border)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sp.medium.w),
            child: Text(
              label,
              style: m10w500(context).copyWith(color: colors.primary, letterSpacing: 1.4),
            ),
          ),
          Expanded(child: Container(height: 1, color: colors.border)),
        ],
      ),
    );
  }
}

class _InfoEntry extends StatelessWidget {
  const _InfoEntry({
    required this.number,
    required this.icon,
    required this.name,
    required this.what,
    required this.how,
    required this.groupLabel,
  });

  final int? number;
  final IconData icon;
  final String name;
  final String what;
  final String how;
  final String groupLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: Sp.medium.h),
      child: FancyContainer(
        width: double.infinity,
        padding: Sp.large.padAllR,
        borderRadius: Sp.large,
        color: colors.textSecondary.withValues(alpha: 0.04),
        border: Border.all(color: colors.border),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colors.gradientStart, colors.gradientEnd],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 18.sp, color: colors.textOnPrimary),
                ),
                Sp.medium.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupLabel,
                        style: m10w500(context).copyWith(
                          color: colors.textSecondary,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Sp.tiny.heightBox,
                      Text(name, style: m15w700(context)),
                    ],
                  ),
                ),
              ],
            ),
            Sp.medium.heightBox,
            Container(height: 1, color: colors.border),
            Sp.medium.heightBox,
            _Label(label: LocaleKeys.numerology_page_info_what_label.tr()),
            Sp.xsmall.heightBox,
            Text(
              what,
              style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.6),
            ),
            Sp.medium.heightBox,
            _Label(label: LocaleKeys.numerology_page_info_how_label.tr()),
            Sp.xsmall.heightBox,
            Text(
              how,
              style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      label.toUpperCase(),
      style: m10w500(context).copyWith(
        color: colors.primary,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _PythagoreanTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const rows = [
      ['1', 'A J S'],
      ['2', 'B K T'],
      ['3', 'C L U  Ç Ü'],
      ['4', 'D M V'],
      ['5', 'E N W'],
      ['6', 'F O X  Ö'],
      ['7', 'G P Y  Ğ'],
      ['8', 'H Q Z'],
      ['9', 'I R  İ'],
    ];

    return FancyContainer(
      width: double.infinity,
      padding: Sp.large.padAllR,
      borderRadius: Sp.large,
      color: colors.accent.withValues(alpha: 0.06),
      border: Border.all(color: colors.accent.withValues(alpha: 0.25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.grid_on_outlined, size: 16.sp, color: colors.primary),
              Sp.xsmall.widthBox,
              Text(
                'PISAGOR TABLE',
                style: m10w500(context).copyWith(
                  color: colors.primary,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Sp.medium.heightBox,
          ...rows.map(
            (row) => Padding(
              padding: EdgeInsets.only(bottom: Sp.xsmall.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colors.gradientStart, colors.gradientEnd],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      row[0],
                      style: m11w500(context).copyWith(
                        color: colors.textOnPrimary,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                  Sp.medium.widthBox,
                  Expanded(
                    child: Text(
                      row[1],
                      style: m13w400(context).copyWith(
                        color: colors.textSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
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
