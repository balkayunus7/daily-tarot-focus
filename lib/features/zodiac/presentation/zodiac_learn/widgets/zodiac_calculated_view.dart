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
                    colorFilter: ColorFilter.mode(
                      colors.primary,
                      BlendMode.srcIn,
                    ),
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
        Sp.large.heightBox,
        FancyContainer(
          width: double.infinity,
          padding: Sp.medium.padAllR,
          borderRadius: Sp.large,
          color: colors.primary.withValues(alpha: 0.06),
          child: Text(
            sign.signDescription,
            style: m13w500(
              context,
            ).copyWith(color: colors.textSecondary, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ),
        Sp.xxlarge.heightBox,
        _SignatureSection(sign: sign),
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
  const _KeywordColumn({
    required this.title,
    required this.keywords,
    required this.accentColor,
  });
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
                      style: m12w400(
                        context,
                      ).copyWith(color: colors.textPrimary),
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
        final card = state.getById(sign.rulingPlanetCard);
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
        final card = state.getById(sign.majorArcanaName);
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
                    Column(
                      children: [
                        Text(
                          sign.localizedName,
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
                            sign.majorArcanaMessage,
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

class _SignatureSection extends StatelessWidget {
  const _SignatureSection({required this.sign});
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
              LocaleKeys.zodiac_page_sign_summary.tr(),
              style: m16w700(context),
            ),
          ],
        ),
        Sp.medium.heightBox,
        FancyContainer(
          width: double.infinity,
          padding: Sp.medium.padAllR,
          borderRadius: Sp.large,
          color: colors.textSecondary.withValues(alpha: 0.06),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _InsightTile(
                      title: LocaleKeys.zodiac_page_element_label.tr(),
                      value: sign.elementLocalized,
                      icon: Icons.auto_awesome,
                    ),
                  ),
                  Sp.small.widthBox,
                  Expanded(
                    child: _InsightTile(
                      title: LocaleKeys.zodiac_page_rhythm_label.tr(),
                      value: sign.modalityLocalized,
                      icon: Icons.sync_alt,
                    ),
                  ),
                ],
              ),
              Sp.small.heightBox,
              Row(
                children: [
                  Expanded(
                    child: _InsightTile(
                      title: LocaleKeys.zodiac_page_planet_label.tr(),
                      value: sign.rulingPlanet,
                      icon: Icons.public,
                    ),
                  ),
                  Sp.small.widthBox,
                  Expanded(
                    child: _InsightTile(
                      title: LocaleKeys.zodiac_page_house_label.tr(),
                      value: sign.rulingHouse,
                      icon: Icons.foundation,
                    ),
                  ),
                ],
              ),
              Sp.large.heightBox,
              _GuidanceCard(
                title: LocaleKeys.zodiac_page_energy_area.tr(),
                text: sign.energyFocus,
                icon: Icons.bolt_outlined,
              ),
              Sp.medium.heightBox,
              _GuidanceCard(
                title: LocaleKeys.zodiac_page_growth_key_label.tr(),
                text: sign.growthKey,
                icon: Icons.key_outlined,
              ),
              Sp.medium.heightBox,
              _GuidanceCard(
                title: LocaleKeys.zodiac_page_daily_intention_label.tr(),
                text: sign.dailyIntention,
                icon: Icons.wb_twilight_outlined,
              ),
              Sp.medium.heightBox,
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: Sp.xsmall.w,
                  runSpacing: Sp.xsmall.h,
                  children: [
                    ...sign.minorArcanaCards.map(
                      (card) => _DecanChip(label: card),
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
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FancyContainer(
      height: 86.h,
      padding: Sp.small.padAllR,
      color: colors.background.withValues(alpha: 0.55),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.primary, size: 18.sp),
          const Spacer(),
          Text(
            title.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: m9w700(context).copyWith(
              color: colors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          Sp.tiny.heightBox,
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: m12w600(context).copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  const _GuidanceCard({
    required this.title,
    required this.text,
    required this.icon,
  });

  final String title;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FancyContainer(
          width: 34.w,
          height: 34.h,
          borderRadius: 100,
          color: colors.primary.withValues(alpha: 0.12),
          child: Icon(icon, color: colors.primary, size: 18.sp),
        ),
        Sp.small.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: m13w700(context)),
              Sp.tiny.heightBox,
              Text(
                text,
                style: m12w400(context).copyWith(
                  color: colors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DecanChip extends StatelessWidget {
  const _DecanChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FancyContainer(
      padding: Sp.small.padHVR(Sp.xsmall),
      borderRadius: Sp.xlarge,
      color: colors.primary.withValues(alpha: 0.1),
      child: Text(
        label,
        style: m11w500(context).copyWith(color: colors.primary),
      ),
    );
  }
}
