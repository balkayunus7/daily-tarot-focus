part of '../pages/zodiac_learn_page.dart';

class ZodiacCalculatedView extends StatelessWidget {
  const ZodiacCalculatedView({required this.sign, super.key});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              FancyContainer(
                width: 96.w,
                height: 96.h,
                borderRadius: 100,
                color: colors.primary.withValues(alpha: 0.1),
                child: Center(
                  child: SvgPicture.asset(
                    sign.svgPath,
                    width: 52.w,
                    height: 52.h,
                    colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
                  ),
                ),
              ),
              Sp.medium.heightBox,
              Text(
                sign.localizedName,
                style: m24w700(context).copyWith(color: colors.textPrimary),
              ),
            ],
          ),
        ),
        Sp.medium.heightBox,
        Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Badge(
                  label: LocaleKeys.zodiac_page_element_label.tr(),
                  value: sign.elementLocalized,
                ),
                SizedBox(width: Sp.small.w),
                _Badge(
                  label: LocaleKeys.zodiac_page_modality_label.tr(),
                  value: sign.modalityLocalized,
                ),
                SizedBox(width: Sp.small.w),
                _Badge(
                  label: LocaleKeys.zodiac_page_ruling_house.tr(),
                  value: sign.rulingHouse,
                ),
              ],
            ),
          ),
        ),
        Sp.large.heightBox,
        FancyContainer(
          width: double.infinity,
          padding: Sp.medium.padAllR,
          borderRadius: Sp.large,
          color: colors.primary.withValues(alpha: 0.06),
          child: Text(
            sign.signDescription,
            style: m13w500(context).copyWith(color: colors.textSecondary, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ),
        Sp.xxlarge.heightBox,
        _KeywordsSection(sign: sign),
        Sp.xxlarge.heightBox,
        _RulingPlanetSection(sign: sign),
        Sp.xxlarge.heightBox,
        _MajorArcanaSection(sign: sign),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.primary;
    final colors = context.colors;

    return FancyContainer(
      padding: Sp.small.padHVR(Sp.xsmall),
      borderRadius: Sp.xlarge,
      color: color.withValues(alpha: 0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: m9w700(context).copyWith(color: colors.secondary.withValues(alpha: 0.7)),
          ),
          Sp.tiny.heightBox,
          Text(value, style: m11w500(context).copyWith(color: color)),
        ],
      ),
    );
  }
}

class _KeywordsSection extends StatelessWidget {
  const _KeywordsSection({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: Sp.tiny,
              height: Sp.large,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: Sp.tiny.radiusR,
              ),
            ),
            Sp.xsmall.widthBox,
            Text(
              '${LocaleKeys.zodiac_page_strengths.tr()} & ${LocaleKeys.zodiac_page_shadows.tr()}',
              style: m16w700(context),
            ),
          ],
        ),
        Sp.medium.heightBox,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _KeywordColumn(
                title: LocaleKeys.zodiac_page_strengths.tr(),
                keywords: sign.strengths,
                accentColor: const Color(0xFF4CAF50),
              ),
            ),
            Sp.small.widthBox,
            Expanded(
              child: _KeywordColumn(
                title: LocaleKeys.zodiac_page_shadows.tr(),
                keywords: sign.shadows,
                accentColor: const Color(0xFFFF9800),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KeywordColumn extends StatelessWidget {
  const _KeywordColumn({required this.title, required this.keywords, required this.accentColor});
  final String title;
  final List<String> keywords;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FancyContainer(
      width: double.infinity,
      padding: Sp.medium.padAllR,
      borderRadius: Sp.large,
      color: accentColor.withValues(alpha: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: m10w700(context).copyWith(
              color: accentColor,
              letterSpacing: 0.8,
            ),
          ),
          Sp.small.heightBox,
          ...keywords.map(
            (kw) => Padding(
              padding: EdgeInsets.only(bottom: Sp.tiny.h),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Sp.xsmall.widthBox,
                  Expanded(
                    child: Text(
                      kw,
                      style: m12w400(context).copyWith(color: colors.textPrimary),
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

class _RulingPlanetSection extends StatelessWidget {
  const _RulingPlanetSection({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<TarotBloc, TarotState>(
      builder: (context, state) {
        final card = state.getByTitle(sign.rulingPlanetCard);
        if (card == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: Sp.tiny,
                  height: Sp.large,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: Sp.tiny.radiusR,
                  ),
                ),
                Sp.xsmall.widthBox,
                Text(
                  LocaleKeys.zodiac_page_ruling_planet.tr(),
                  style: m16w700(context),
                ),
              ],
            ),
            Sp.medium.heightBox,
            GestureDetector(
              onTap: () async {
                await context.pushNamed(
                  AppRoutes.tarotDeckDetail,
                  pathParameters: {'tarotId': card.id},
                );
              },
              child: FancyContainer(
                width: double.infinity,
                padding: Sp.medium.padAllR,
                borderRadius: Sp.large,
                color: colors.textSecondary.withValues(alpha: 0.06),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          sign.rulingPlanet,
                          style: m14w700(context).copyWith(
                            color: colors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Sp.xsmall.heightBox,
                        ClipRRect(
                          borderRadius: Sp.xsmall.radiusR,
                          child: CustomCacheNetworkImage(
                            imageUrl: card.imageUrl,
                            width: 64.w,
                            height: 106.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    Sp.medium.widthBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(card.name, style: m14w700(context)),
                          Sp.xsmall.heightBox,
                          Text(
                            card.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: m12w400(context).copyWith(
                              color: colors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: colors.textSecondary.withValues(alpha: 0.4),
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MajorArcanaSection extends StatelessWidget {
  const _MajorArcanaSection({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<TarotBloc, TarotState>(
      builder: (context, state) {
        final card = state.getByTitle(sign.majorArcanaName);
        if (card == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: Sp.tiny,
                  height: Sp.large,
                  decoration: BoxDecoration(color: colors.primary, borderRadius: Sp.tiny.radiusR),
                ),
                Sp.xsmall.widthBox,
                Text(
                  LocaleKeys.zodiac_page_arcana_card.tr(),
                  style: m16w700(context),
                ),
              ],
            ),
            Sp.medium.heightBox,
            GestureDetector(
              onTap: () async {
                await context.pushNamed(
                  AppRoutes.tarotDeckDetail,
                  pathParameters: {'tarotId': card.id},
                );
              },
              child: FancyContainer(
                width: double.infinity,
                padding: Sp.medium.padAllR,
                borderRadius: Sp.large,
                color: colors.textSecondary.withValues(alpha: 0.06),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: Sp.small.radiusR,
                      child: CustomCacheNetworkImage(
                        imageUrl: card.imageUrl,
                        width: 64.w,
                        height: 106.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Sp.medium.widthBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(card.name, style: m14w700(context)),
                          Sp.xsmall.heightBox,
                          Text(
                            card.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: m12w400(context).copyWith(
                              color: colors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: colors.textSecondary.withValues(alpha: 0.4),
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
