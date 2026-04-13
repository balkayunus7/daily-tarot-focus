import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/shadow_extensions.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/tarot_mock_data.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class SharedTarotDetailPageContent extends StatefulWidget {
  const SharedTarotDetailPageContent({
    required this.tarot,
    this.showMeaningForDay = false,
    super.key,
  });
  final TarotCardModel tarot;
  final bool showMeaningForDay;

  @override
  State<SharedTarotDetailPageContent> createState() => _SharedTarotDetailPageContentState();
}

class _SharedTarotDetailPageContentState extends State<SharedTarotDetailPageContent> {
  late final ValueNotifier<bool> _isUpright;

  @override
  void initState() {
    super.initState();
    _isUpright = ValueNotifier(true);
  }

  @override
  void dispose() {
    _isUpright.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tarot = widget.tarot;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpacingConsts.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card image
          Center(
            child: Hero(
              tag: TarotMockData.dailyTarotCardHeroTag,
              child: Container(
                width: 160,
                height: 240,
                padding: Spacing.tinyPadding,
                decoration: BoxDecoration(
                  color: context.colors.textPrimary,
                  borderRadius: Spacing.defaultBorderRadius,
                  border: Border.all(color: context.colors.primary, width: 3),
                  boxShadow: context.colors.primary.softShadow,
                ),
                child: ClipRRect(
                  borderRadius: Spacing.xsmallBorderRadius,
                  child: Image.asset(tarot.imagePath, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Spacing.largeH,

          // Upright / Reversed toggle
          _MeaningToggle(isUpright: _isUpright),
          Spacing.mediumH,

          // Toggle-dependent content
          ValueListenableBuilder<bool>(
            valueListenable: _isUpright,
            builder: (context, isUpright, _) {
              final meanings = isUpright ? tarot.upright : tarot.reversed;
              final keywords = isUpright ? tarot.uprightKeywords : tarot.reversedKeywords;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _KeywordsWrap(keywords: keywords),
                  Spacing.largeH,

                  // Description
                  if (tarot.description.isNotEmpty) ...[
                    Text(
                      tarot.description,
                      style: m13w500(context).copyWith(
                        color: context.colors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    Spacing.largeH,
                  ],

                  // Correspondences
                  if (tarot.correspondences.astrology.isNotEmpty ||
                      tarot.correspondences.element.isNotEmpty ||
                      tarot.correspondences.yesOrNo.isNotEmpty) ...[
                    _CorrespondencesRow(correspondences: tarot.correspondences),
                    Spacing.largeH,
                  ],

                  // Symbols
                  if (tarot.symbols.isNotEmpty) ...[
                    _SymbolsList(symbols: tarot.symbols),
                    Spacing.largeH,
                  ],

                  // Meanings
                  _MeaningExpansionTile(
                    icon: '⭐',
                    title: LocaleKeys.tarot_detail_general.tr(),
                    content: meanings.general,
                  ),
                  _MeaningExpansionTile(
                    icon: '❤️',
                    title: LocaleKeys.tarot_detail_love.tr(),
                    content: meanings.love,
                  ),
                  _MeaningExpansionTile(
                    icon: '💼',
                    title: LocaleKeys.tarot_detail_career.tr(),
                    content: meanings.career,
                  ),
                  _MeaningExpansionTile(
                    icon: '💰',
                    title: 'Finansal',
                    content: meanings.finances,
                  ),
                  _MeaningExpansionTile(
                    icon: '💭',
                    title: 'Duygular',
                    content: meanings.feelings,
                  ),
                  _MeaningExpansionTile(
                    icon: '🎯',
                    title: 'Aksiyonlar',
                    content: meanings.actions,
                  ),
                ],
              );
            },
          ),
          Spacing.xxlargeH,
        ],
      ),
    );
  }
}

class _MeaningToggle extends StatelessWidget {
  const _MeaningToggle({required this.isUpright});
  final ValueNotifier<bool> isUpright;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ValueListenableBuilder<bool>(
      valueListenable: isUpright,
      builder: (context, isUprightValue, _) {
        return FancyContainer(
          borderRadius: Spacing.xlargeBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => isUpright.value = true,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isUprightValue ? colors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Düz Anlam',
                          style: m14w700(context).copyWith(
                            color:
                                isUprightValue
                                    ? colors.textOnPrimary
                                    : colors.textDisabled,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => isUpright.value = false,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !isUprightValue ? colors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Ters Anlam',
                          style: m14w700(context).copyWith(
                            color:
                                !isUprightValue
                                    ? colors.textOnPrimary
                                    : colors.textDisabled,
                          ),
                        ),
                      ),
                    ),
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

class _KeywordsWrap extends StatelessWidget {
  const _KeywordsWrap({required this.keywords});
  final List<String> keywords;

  @override
  Widget build(BuildContext context) {
    if (keywords.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          keywords
              .map(
                (keyword) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    keyword,
                    style: m12w600(context).copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

class _CorrespondencesRow extends StatelessWidget {
  const _CorrespondencesRow({required this.correspondences});
  final CorrespondencesModel correspondences;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (correspondences.astrology.isNotEmpty)
          Expanded(
            child: _CorrespondenceChip(
              icon: '♈',
              label: correspondences.astrology,
              context: context,
            ),
          ),
        if (correspondences.element.isNotEmpty) ...[
          Spacing.smallW,
          Expanded(
            child: _CorrespondenceChip(
              icon: '🔮',
              label: correspondences.element,
              context: context,
            ),
          ),
        ],
        if (correspondences.yesOrNo.isNotEmpty) ...[
          Spacing.smallW,
          Expanded(
            child: _CorrespondenceChip(
              icon: correspondences.yesOrNo.toLowerCase() == 'yes' ? '✅' : '❌',
              label: correspondences.yesOrNo.toUpperCase(),
              context: context,
            ),
          ),
        ],
      ],
    );
  }
}

class _CorrespondenceChip extends StatelessWidget {
  const _CorrespondenceChip({
    required this.icon,
    required this.label,
    required this.context,
  });
  final String icon;
  final String label;
  final BuildContext context;

  @override
  Widget build(BuildContext outerContext) {
    return FancyContainer(
      borderRadius: Spacing.defaultBorderRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            Spacing.tinyH,
            Text(
              label,
              style: m10w600(outerContext).copyWith(
                color: outerContext.colors.textSecondary,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SymbolsList extends StatelessWidget {
  const _SymbolsList({required this.symbols});
  final List<SymbolModel> symbols;

  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      borderRadius: Spacing.defaultBorderRadius,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔑 Semboller',
              style: m14w700(context).copyWith(color: context.colors.textPrimary),
            ),
            Spacing.smallH,
            ...symbols.map(
              (symbol) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•',
                      style: m13w500(context).copyWith(color: context.colors.primary),
                    ),
                    Spacing.smallW,
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${symbol.title}: ',
                              style: m13w500(context).copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: symbol.meaning,
                              style: m12w400(context).copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
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

class _MeaningExpansionTile extends StatelessWidget {
  const _MeaningExpansionTile({
    required this.icon,
    required this.title,
    required this.content,
  });
  final String icon;
  final String title;
  final String content;

  String get _preview {
    final sentences = content.split(RegExp(r'(?<=\.)\s+'));
    if (sentences.length <= 2) return content;
    return '${sentences.take(2).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) return const SizedBox.shrink();

    final previewStyle = m12w400(context).copyWith(
      color: context.colors.textDisabled,
      height: 1.4,
    );

    final fullStyle = m13w500(context).copyWith(
      color: context.colors.textSecondary,
      height: 1.5,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: FancyContainer(
        borderRadius: Spacing.defaultBorderRadius,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: Text(icon, style: const TextStyle(fontSize: 20)),
            title: Text(
              title,
              style: m14w700(context).copyWith(color: context.colors.textPrimary),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _preview,
                style: previewStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            iconColor: context.colors.textDisabled,
            collapsedIconColor: context.colors.textDisabled,
            children: [
              Text(content, style: fullStyle),
            ],
          ),
        ),
      ),
    );
  }
}
