import 'dart:math' as math;

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/build_context_toast_ext.dart';
import 'package:daily_tarot_focus/core/util/locale_extensions.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_daily_pick_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_daily_pick_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class TarotDailyPickResultArgs {
  const TarotDailyPickResultArgs({
    required this.tarot,
    required this.isReversed,
  });

  final TarotCardModel tarot;
  final bool isReversed;
}

class TarotDailyPickResultPage extends StatefulWidget {
  const TarotDailyPickResultPage({required this.args, super.key});
  final TarotDailyPickResultArgs args;

  @override
  State<TarotDailyPickResultPage> createState() =>
      _TarotDailyPickResultPageState();
}

class _TarotDailyPickResultPageState extends State<TarotDailyPickResultPage> {
  void _saveDailyPick() {
    final state = context.read<TarotBloc>().state;
    if (state.isRecordDailyCard) return;
    final dailyPick = state.generateDailyPickResponseOrNull;
    if (dailyPick == null) return;

    final session = context.read<AuthCubit>().state.sessionOrCrash;

    context.read<TarotBloc>().addRecordDailyCardRequested(
      request: RecordDailyCardRequest(
        session: session,
        cardId: widget.args.tarot.id,
        isReversed: widget.args.isReversed,
        dailyPick: dailyPick,
        locale: context.currentLocaleLanguage.value,
        date: DateTime.now(),
      ),
    );
  }

  void _generateDailyPick() {
    context.read<TarotBloc>().addGenerateDailyPickRequested(
      request: GenerateDailyPickRequest(
        session: context.read<AuthCubit>().state.sessionOrCrash,
        card: widget.args.tarot,
        isReversed: widget.args.isReversed,
        date: DateTime.now(),
        locale: context.currentLocaleLanguage.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocConsumer<TarotBloc, TarotState>(
      listenWhen: (previous, current) {
        return previous.hasRecordDailyCardSucceeded !=
                current.hasRecordDailyCardSucceeded ||
            previous.hasRecordDailyCardFailed !=
                current.hasRecordDailyCardFailed;
      },
      listener: (context, state) {
        if (state.hasRecordDailyCardFailed) {
          context.showErrorToastMessage(
            LocaleKeys.tarot_daily_save_failed.tr(),
          );
        }
        if (state.hasRecordDailyCardSucceeded) {
          final router = GoRouter.of(context);
          context.showToastMessage(LocaleKeys.tarot_daily_save_success.tr());
          router.go(AppRoutes.tarotDailyCalendar);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: colors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                TarotAppBar(
                  title: LocaleKeys.daily_pick_page_title.tr(),
                  titleStyle: m18w700(context),
                  backIcon: Icons.close,
                  trailingIcon:
                      state.isRecordDailyCard
                          ? FontAwesomeIcons.spinner
                          : Icons.save,
                  onBackIconTap: () => context.go(AppRoutes.tarotExplore),
                  onIconTap: _saveDailyPick,
                ),
                Expanded(
                  child: BlocBuilder<TarotBloc, TarotState>(
                    buildWhen:
                        (previous, current) =>
                            previous.isGeneratingDailyPick !=
                                current.isGeneratingDailyPick ||
                            previous.fetchFailureOrGenerateDailyPick !=
                                current.fetchFailureOrGenerateDailyPick,
                    builder: (context, state) {
                      final response = state.generateDailyPickResponseOrNull;

                      return SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          Sp.large.h,
                          0,
                          Sp.xxxlarge.h + MediaQuery.of(context).padding.bottom,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DailyPickDetailTop(
                              tarot: widget.args.tarot,
                              isReversed: widget.args.isReversed,
                            ),
                            Sp.xlarge.heightBox,
                            if (response != null) ...[
                              Padding(
                                padding: Sp.xlarge.padXR,
                                child: Column(
                                  children: [
                                    _DailyAdviceCard(
                                      text: response.dailyAdvice,
                                    ),
                                    Sp.medium.heightBox,
                                    ...response.categories.map(
                                      (category) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: Sp.medium.h,
                                        ),
                                        child: _DailyPickCategoryTile(
                                          category: category,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else if (state.hasGeneratedDailyPickFailed) ...[
                              Padding(
                                padding: Sp.xlarge.padXR,
                                child: _DailyPickErrorCard(
                                  onRetry: _generateDailyPick,
                                ),
                              ),
                            ] else ...[
                              Padding(
                                padding: Sp.xlarge.padXR,
                                child: const _DailyPickShimmer(),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
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

class _DailyPickDetailTop extends StatelessWidget {
  const _DailyPickDetailTop({required this.tarot, required this.isReversed});
  final TarotCardModel tarot;
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final date = _formattedDate(context);
    final keywords =
        isReversed ? tarot.reversedKeywords : tarot.uprightKeywords;

    return Column(
      children: [
        Padding(
          padding: Sp.medium.padXR,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (tarot.correspondences.astrology.isNotEmpty)
                        _LineLabel(
                          title: LocaleKeys.tarot_detail_astrology.tr(),
                          value: tarot.correspondences.astrology,
                          isLeft: true,
                        ),
                      if (tarot.correspondences.element.isNotEmpty)
                        _LineLabel(
                          title: LocaleKeys.tarot_detail_element.tr(),
                          value: tarot.correspondences.element,
                          isLeft: true,
                        ),
                      if (tarot.correspondences.yesOrNo.isNotEmpty)
                        _LineLabel(
                          title: LocaleKeys.tarot_detail_yes_no.tr(),
                          value: tarot.correspondences.yesOrNo,
                          isLeft: true,
                        ),
                    ],
                  ),
                ),
                Sp.xsmall.widthBox,
                Expanded(
                  flex: 3,
                  child: Hero(
                    tag: TarotMockData.dailyTarotCardHeroTag,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: Sp.medium.radiusR,
                        border: Border.all(color: colors.secondary),
                      ),
                      child: ClipRRect(
                        borderRadius: Sp.medium.radiusR,
                        child: Transform.rotate(
                          angle: isReversed ? math.pi : 0,
                          child: CustomCacheNetworkImage(
                            imageUrl: tarot.imageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Sp.xsmall.widthBox,
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        tarot.symbols.take(4).map((symbol) {
                          return _LineLabel(
                            title: symbol.title,
                            value: symbol.meaning,
                            isLeft: false,
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Sp.xlarge.heightBox,
        Padding(
          padding: Sp.xlarge.padXR,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _KeywordsWrap(keywords: keywords),
              Sp.large.heightBox,
              Center(
                child: Text(
                  tarot.category.localizedName.toUpperCase(),
                  style: m10w600(context).copyWith(
                    color: colors.secondary,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Sp.small.heightBox,
              Text(
                tarot.name,
                textAlign: TextAlign.center,
                style: m38w400(context).copyWith(color: colors.textPrimary),
              ),
              Sp.small.heightBox,
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: Sp.xsmall.w,
                  runSpacing: Sp.xsmall.h,
                  children: [
                    _HeaderPill(
                      text: date,
                      icon: Icons.calendar_today_rounded,
                      color: colors.primary,
                    ),
                    _HeaderPill(
                      text:
                          (isReversed
                                  ? LocaleKeys.daily_pick_page_reversed
                                  : LocaleKeys.daily_pick_page_upright)
                              .tr(),
                      icon:
                          isReversed
                              ? Icons.south_rounded
                              : Icons.north_rounded,
                      color: isReversed ? colors.error : colors.success,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formattedDate(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('d MMMM, EEEE', locale).format(DateTime.now());
  }
}

class _KeywordsWrap extends StatelessWidget {
  const _KeywordsWrap({required this.keywords});
  final List<String> keywords;

  @override
  Widget build(BuildContext context) {
    if (keywords.isEmpty) return const SizedBox.shrink();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 3,
      children:
          keywords.map((keyword) {
            return FancyContainer(
              padding: Sp.small.padSymR(h: Sp.small, v: Sp.tiny),
              color: context.colors.primary.withValues(alpha: 0.6),
              child: Text(
                keyword,
                style: m10w500(
                  context,
                ).copyWith(color: context.colors.textOnPrimary),
              ),
            );
          }).toList(),
    );
  }
}

class _LineLabel extends StatelessWidget {
  const _LineLabel({
    required this.title,
    required this.value,
    required this.isLeft,
  });
  final String title;
  final String value;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    final line = Container(
      width: 15,
      height: 1,
      color: context.colors.primary.withValues(alpha: 0.5),
    );
    final gap = Sp.tiny.widthBox;
    final textColumn = Expanded(
      child: Column(
        crossAxisAlignment:
            isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(title.toUpperCase(), style: m9w700(context)),
          ),
          2.heightBox,
          Text(
            value,
            style: m8w400(
              context,
            ).copyWith(color: context.colors.textSecondary),
            textAlign: isLeft ? TextAlign.right : TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    return Padding(
      padding: Sp.tiny.padYR,
      child: Row(
        children: isLeft ? [textColumn, gap, line] : [line, gap, textColumn],
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({
    required this.text,
    required this.icon,
    required this.color,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sp.small.w,
        vertical: Sp.xsmall.h,
      ),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          Sp.tiny.widthBox,
          Text(
            text,
            style: m11w500(context).copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _DailyPickCategoryTile extends StatelessWidget {
  const _DailyPickCategoryTile({required this.category});
  final DailyPickCategoryInsight category;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(category.emoji, style: m16w700(context)),
          ),
          Sp.small.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.labelKey.tr(), style: m14w700(context)),
                Sp.xsmall.heightBox,
                Text(
                  category.description,
                  style: m13w400(
                    context,
                  ).copyWith(color: colors.textSecondary, height: 1.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyAdviceCard extends StatelessWidget {
  const _DailyAdviceCard({required this.text});
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text('✨', style: m16w700(context)),
          ),
          Sp.small.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.daily_pick_page_daily_advice.tr(),
                  style: m14w700(context),
                ),
                Sp.xsmall.heightBox,
                Text(
                  text,
                  style: m13w500(
                    context,
                  ).copyWith(color: colors.textSecondary, height: 1.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyPickErrorCard extends StatelessWidget {
  const _DailyPickErrorCard({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: context.colors.textSecondary.withValues(alpha: 0.05),
      border: Border.all(color: context.colors.border),
      child: Column(
        children: [
          Text(
            LocaleKeys.tarot_question_loading_error.tr(),
            style: m16w700(context),
          ),
          Sp.medium.heightBox,
          FancyButton(onTap: onRetry, text: LocaleKeys.common_confirm.tr()),
        ],
      ),
    );
  }
}

class _DailyPickShimmer extends StatelessWidget {
  const _DailyPickShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: Sp.small.h),
          child: FancyContainer(
            width: double.infinity,
            height: index == 0 ? 96.h : 78.h,
            borderRadius: Sp.large,
            color: colors.textSecondary.withValues(alpha: 0.06),
            border: Border.all(color: colors.border),
          ),
        ),
      ),
    );
  }
}
