import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac/zodiac_bloc.dart';
import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac/zodiac_state.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_request_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_response_model.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_compatibility/helpers/zodiac_compatibility_page_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

part '../widgets/result_category_tile.dart';
part '../widgets/result_match_header.dart';
part '../widgets/result_score_grid.dart';
part '../widgets/result_shimmer.dart';

class TarotCompatibilityResultPage extends StatefulWidget {
  const TarotCompatibilityResultPage({required this.request, super.key});
  final GenerateCompatibilityRequestModel request;

  @override
  State<TarotCompatibilityResultPage> createState() => _TarotCompatibilityResultPageState();
}

class _TarotCompatibilityResultPageState extends State<TarotCompatibilityResultPage> {
  bool _hasResult = false;
  GenerateCompatibilityResponse? _response;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocConsumer<ZodiacBloc, ZodiacState>(
      listenWhen: (p, c) => !_hasResult && c.hasGeneratedCompatibilitySucceeded,
      listener: (context, state) {
        setState(() {
          _hasResult = true;
          _response = state.compatibilityResponseOrNull;
        });
      },
      buildWhen:
          (p, c) =>
              p.isGeneratingCompatibility != c.isGeneratingCompatibility ||
              p.hasGeneratedCompatibilitySucceeded != c.hasGeneratedCompatibilitySucceeded,
      builder: (context, state) {
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
                    child:
                        _hasResult && _response != null
                            ? _ResultContent(request: widget.request, response: _response!)
                            : _ShimmerContent(request: widget.request),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ResultContent extends StatelessWidget {
  const _ResultContent({required this.request, required this.response});
  final GenerateCompatibilityRequestModel request;
  final GenerateCompatibilityResponse response;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MatchHeader(request: request, response: response),
        Sp.xlarge.heightBox,
        ScoreGrid(response: response),
        Sp.xlarge.heightBox,
        _SummarySection(response: response),
        Sp.xlarge.heightBox,
        ...response.categories.map(
          (category) => Padding(
            padding: EdgeInsets.only(bottom: Sp.small.h),
            child: CategoryTile(category: category),
          ),
        ),
      ],
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
  const _SummarySection({required this.response});
  final GenerateCompatibilityResponse response;

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
              '${LocaleKeys.compat_page_summary_label.tr()} • ${response.overallScore}%',
              style: m16w700(context).copyWith(color: colors.textPrimary),
            ),
          ],
        ),
        Sp.medium.heightBox,
        Text(
          response.summary,
          style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.65),
        ),
      ],
    );
  }
}
