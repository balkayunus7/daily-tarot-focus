import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/zodiac_compatibility_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotCompatibilityResultPage extends StatelessWidget {
  const TarotCompatibilityResultPage({required this.input, required this.result, super.key});
  final CompatibilityInputModel input;
  final CompatibilityResult result;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TarotAppBar(
              title: LocaleKeys.compat_page_title.tr(),
              titleStyle: m18w700(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  Sp.screen.w,
                  Sp.large.h,
                  Sp.screen.w,
                  Sp.xxxlarge.h + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderSection(result: result),
                    Sp.xlarge.heightBox,
                    _ScoreGrid(result: result),
                    Sp.xlarge.heightBox,
                    _SummarySection(result: result),
                    Sp.large.heightBox,
                    ...result.categories.map(
                      (category) => Padding(
                        padding: EdgeInsets.only(bottom: Sp.small.h),
                        child: _CategoryTile(category: category),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.result});
  final CompatibilityResult result;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SignAvatar(sign: result.mySign),
            Padding(
              padding: Sp.large.padHR,
              child: Icon(Icons.favorite_rounded, color: colors.error, size: 28.sp),
            ),
            _SignAvatar(sign: result.partnerSign),
          ],
        ),
        Sp.large.heightBox,
        Text(
          result.titleKey.tr(),
          style: m18w700(context).copyWith(color: colors.success),
          textAlign: TextAlign.center,
        ),
        Sp.medium.heightBox,
        Container(height: 1, color: colors.border),
        Sp.medium.heightBox,
        _OverallBar(score: result.overallScore),
      ],
    );
  }
}

class _SignAvatar extends StatelessWidget {
  const _SignAvatar({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.gradientStart, colors.gradientEnd],
        ),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        sign.svgPath,
        width: 34.w,
        height: 34.w,
        colorFilter: ColorFilter.mode(colors.textOnPrimary, BlendMode.srcIn),
      ),
    );
  }
}

class _OverallBar extends StatelessWidget {
  const _OverallBar({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$score%',
              style: m14w700(context).copyWith(color: colors.textPrimary),
            ),
          ],
        ),
        Sp.xsmall.heightBox,
        ClipRRect(
          borderRadius: 8.radiusR,
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 10.h,
            backgroundColor: colors.primary.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(colors.secondary),
          ),
        ),
      ],
    );
  }
}

class _ScoreGrid extends StatelessWidget {
  const _ScoreGrid({required this.result});
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
            style: m10w500(context).copyWith(color: context.colors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Sp.xsmall.heightBox,
          Text(
            '${category.score}%',
            style: m14w700(context),
          ),
          Sp.xsmall.heightBox,
          ClipRRect(
            borderRadius: 4.radiusR,
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

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.result});
  final CompatibilityResult result;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('✨ ', style: m16w700(context)),
            Text(
              '${LocaleKeys.compat_page_summary_label.tr()} • ${result.overallScore}%',
              style: m16w700(context).copyWith(color: colors.textPrimary),
            ),
          ],
        ),
        Sp.medium.heightBox,
        Text(
          result.summary,
          style: m13w400(context).copyWith(
            color: colors.textSecondary,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatefulWidget {
  const _CategoryTile({required this.category});
  final CompatibilityCategoryModel category;

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      await _ctrl.forward();
    } else {
      await _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cat = widget.category;
    return FancyContainer(
      width: double.infinity,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Column(
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: Sp.large.radiusR,
            child: Padding(
              padding: Sp.medium.padAllR,
              child: Row(
                children: [
                  Text('${cat.emoji} ', style: TextStyle(fontSize: 16.sp)),
                  Expanded(
                    child: Text(
                      '${cat.labelKey.tr()} • ${cat.score}%',
                      style: m14w600(context),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
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
          ),
          SizeTransition(
            sizeFactor: _anim,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                Sp.medium.w,
                0,
                Sp.medium.w,
                Sp.medium.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1, color: colors.border),
                  Sp.small.heightBox,
                  ClipRRect(
                    borderRadius: 4.radiusR,
                    child: LinearProgressIndicator(
                      value: cat.score / 100,
                      minHeight: 6.h,
                      backgroundColor: cat.barColor.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(cat.barColor),
                    ),
                  ),
                  Sp.medium.heightBox,
                  Text(
                    cat.description,
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
