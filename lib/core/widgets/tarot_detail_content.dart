import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/helpers/detail_content_mixin.dart';
import 'package:daily_tarot_focus/core/widgets/helpers/detail_content_scope.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class TarotDetailContent extends StatefulWidget {
  const TarotDetailContent({required this.tarot, super.key});
  final TarotCardModel tarot;

  @override
  State<TarotDetailContent> createState() => _TarotDetailContentState();
}

class _TarotDetailContentState extends State<TarotDetailContent> with TarotDetailContentMixin {
  @override
  Widget build(BuildContext context) {
    final tarot = widget.tarot;

    return TarotDetailContentScope(
      state: this,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Sp.large.heightBox,
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
                                title: 'Astrology',
                                value: tarot.correspondences.astrology,
                                isLeft: true,
                              ),
                            if (tarot.correspondences.element.isNotEmpty)
                              _LineLabel(
                                title: 'Element',
                                value: tarot.correspondences.element,
                                isLeft: true,
                              ),
                            if (tarot.correspondences.yesOrNo.isNotEmpty)
                              _LineLabel(
                                title: 'Yes/No',
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
                              border: Border.all(color: context.colors.secondary),
                            ),
                            child: ClipRRect(
                              borderRadius: Sp.medium.radiusR,
                              child: CustomCacheNetworkImage(imageUrl: tarot.imageUrl),
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
                child: ValueListenableBuilder<bool>(
                  valueListenable: isUpright,
                  builder: (context, isUprightValue, _) {
                    final keywords =
                        isUprightValue ? tarot.uprightKeywords : tarot.reversedKeywords;
                    final meanings = isUprightValue ? tarot.upright : tarot.reversed;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _KeywordsWrap(keywords: keywords),
                        Sp.large.heightBox,
                        Center(
                          child: Text(
                            tarot.category.localizedName.toUpperCase(),
                            style: m10w600(context).copyWith(
                              color: context.colors.secondary,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Sp.small.heightBox,
                        Center(
                          child: Text(
                            tarot.name,
                            textAlign: TextAlign.center,
                            style: m38w400(context).copyWith(
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                        Sp.xlarge.heightBox,
                        const _MeaningToggle(),
                        Sp.xlarge.heightBox,
                        if (tarot.description.isNotEmpty) ...[
                          Text(
                            'The Essence',
                            style: m18w600(context).copyWith(
                              color: context.colors.textPrimary,
                            ),
                          ),
                          Sp.medium.heightBox,
                          Text(
                            tarot.description,
                            style: m13w400(context).copyWith(
                              color: context.colors.textSecondary,
                              height: 1.7,
                            ),
                          ),
                          Sp.xlarge.heightBox,
                        ],
                        if (meanings.general.isNotEmpty) ...[
                          _InfoCard(
                            icon: Icons.auto_awesome,
                            title: LocaleKeys.tarot_detail_general.tr(),
                            content: meanings.general,
                          ),
                          Sp.medium.heightBox,
                        ],
                        if (meanings.love.isNotEmpty) ...[
                          _InfoCard(
                            icon: Icons.favorite,
                            title: LocaleKeys.tarot_detail_love.tr(),
                            content: meanings.love,
                          ),
                          Sp.medium.heightBox,
                        ],
                        if (meanings.career.isNotEmpty) ...[
                          _InfoCard(
                            icon: Icons.work,
                            title: LocaleKeys.tarot_detail_career.tr(),
                            content: meanings.career,
                          ),
                          Sp.medium.heightBox,
                        ],
                        if (meanings.finances.isNotEmpty) ...[
                          _InfoCard(
                            icon: Icons.account_balance_wallet,
                            title: 'Finance',
                            content: meanings.finances,
                          ),
                          Sp.medium.heightBox,
                        ],
                        Sp.xlarge.heightBox,
                        Center(
                          child: Text(
                            "Part of the 'Celestial Stillness' Collection",
                            style: m12w500(context).copyWith(color: context.colors.textSecondary),
                          ),
                        ),
                        Sp.large.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_outlined,
                              size: 20,
                              color: context.colors.textDisabled,
                            ),
                            Sp.large.widthBox,
                            Icon(
                              Icons.style_outlined,
                              size: 20,
                              color: context.colors.textDisabled,
                            ),
                            Sp.large.widthBox,
                            Icon(
                              Icons.auto_awesome_outlined,
                              size: 20,
                              color: context.colors.textDisabled,
                            ),
                          ],
                        ),
                        Sp.xxlarge.heightBox,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeaningToggle extends StatelessWidget {
  const _MeaningToggle();

  @override
  Widget build(BuildContext context) {
    final scope = TarotDetailContentScope.of(context).state;
    return ValueListenableBuilder<bool>(
      valueListenable: scope.isUpright,
      builder: (context, isUprightValue, _) {
        return FancyContainer(
          borderRadius: Sp.xlarge,
          child: Padding(
            padding: Sp.tiny.padAllR,
            child: Row(
              children: [
                _MeaningSwitch(
                  isActive: isUprightValue,
                  title: 'Upright Meaning',
                  onTap: () => scope.setUpright(true),
                ),
                _MeaningSwitch(
                  isActive: !isUprightValue,
                  title: 'Reversed Meaning',
                  onTap: () => scope.setUpright(false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MeaningSwitch extends StatelessWidget {
  const _MeaningSwitch({
    required this.isActive,
    required this.title,
    required this.onTap,
  });
  final bool isActive;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScalingContainer(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: Sp.small.padYR,
          decoration: BoxDecoration(
            color: isActive ? context.colors.primary : context.colors.background,
            borderRadius: 20.radiusR,
          ),
          child: Center(
            child: Text(
              title,
              style: m12w600(context).copyWith(
                color: isActive ? context.colors.textOnPrimary : context.colors.primary,
              ),
            ),
          ),
        ),
      ),
    );
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
                style: m10w500(context).copyWith(color: context.colors.textOnPrimary),
              ),
            );
          }).toList(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.content});
  final IconData icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FancyContainer(
      color: colors.primary.withValues(alpha: 0.05),
      border: Border.all(color: colors.border),
      padding: Sp.large.padAllR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.gradientStart, colors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: Sp.small.radiusR,
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: colors.accent, size: 16),
              ),
              Sp.small.widthBox,
              Text(
                title,
                style: m15w600(context).copyWith(color: colors.textPrimary),
              ),
            ],
          ),
          Sp.xsmall.heightBox,
          _ExpandableText(
            text: content,
            style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _ExpandableText extends StatefulWidget {
  const _ExpandableText({required this.text, required this.style});
  final String text;
  final TextStyle style;

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  late final ValueNotifier<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = ValueNotifier(false);
  }

  @override
  void dispose() {
    _isExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _isExpanded.value = !_isExpanded.value;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _isExpanded,
        builder: (context, isExpanded, _) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: Text(
                    widget.text,
                    style: widget.style,
                    maxLines: isExpanded ? null : 2,
                    overflow: isExpanded ? null : TextOverflow.ellipsis,
                  ),
                ),
              ),
              Sp.small.widthBox,
              Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: context.colors.primary.withValues(alpha: 0.4),
                size: 20,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LineLabel extends StatelessWidget {
  const _LineLabel({required this.title, required this.value, required this.isLeft});
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
        crossAxisAlignment: isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
            style: m8w400(context).copyWith(color: context.colors.textSecondary),
            textAlign: isLeft ? TextAlign.right : TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    return Padding(
      padding: Sp.tiny.padYR,
      child: Row(children: isLeft ? [textColumn, gap, line] : [line, gap, textColumn]),
    );
  }
}
