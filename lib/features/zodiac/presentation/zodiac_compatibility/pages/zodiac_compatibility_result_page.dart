import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/zodiac_compatibility_model.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_compatibility/helpers/zodiac_compatibility_page_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/result_category_tile.dart';
part '../widgets/result_match_header.dart';
part '../widgets/result_score_grid.dart';

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
                    MatchHeader(result: result),
                    Sp.xlarge.heightBox,
                    ScoreGrid(result: result),
                    Sp.xlarge.heightBox,
                    _SummarySection(result: result),
                    Sp.xlarge.heightBox,
                    ...result.categories.map(
                      (category) => Padding(
                        padding: EdgeInsets.only(bottom: Sp.small.h),
                        child: CategoryTile(category: category),
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

class _OverallBar extends StatelessWidget {
  const _OverallBar({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$score%', style: m14w700(context).copyWith(color: colors.textPrimary)),
        Sp.xsmall.heightBox,
        ClipRRect(
          borderRadius: Sp.xsmall.radiusR,
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: Sp.xsmall.h,
            backgroundColor: colors.primary.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(colors.secondary),
          ),
        ),
      ],
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
          style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.65),
        ),
      ],
    );
  }
}
