import 'dart:async';

import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_bloc.dart';
import 'package:daily_tarot_focus/features/tarot/bloc/tarot/tarot_state.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/zodiac_page_mixin.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/zodiac_page_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class ZodiacLearnPage extends StatefulWidget {
  const ZodiacLearnPage({super.key});

  @override
  State<ZodiacLearnPage> createState() => _ZodiacLearnPageState();
}

class _ZodiacLearnPageState extends State<ZodiacLearnPage> with ZodiacLearnPageMixin {
  @override
  Widget build(BuildContext context) {
    return ZodiacLearnPageScope(
      state: this,
      child: const DefaultTabController(length: 3, child: _ZodiacScaffold()),
    );
  }
}

class _ZodiacScaffold extends StatelessWidget {
  const _ZodiacScaffold();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TarotAppBar(title: LocaleKeys.zodiac_page_title.tr(), titleStyle: m18w700(context)),
            TabBar(
              indicatorColor: colors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: colors.textPrimary,
              unselectedLabelColor: colors.textSecondary.withValues(alpha: 0.5),
              labelStyle: m13w600(context),
              unselectedLabelStyle: m13w600(context),
              tabs: [
                Tab(text: '☀ ${LocaleKeys.zodiac_page_tab_sun.tr()}'),
                Tab(text: '🌙 ${LocaleKeys.zodiac_page_tab_moon.tr()}'),
                Tab(text: '⬆ ${LocaleKeys.zodiac_page_tab_rising.tr()}'),
              ],
            ),
            BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (previous, current) => current.isAuthenticated,
              builder: (context, state) {
                final user = state.userOrCrash as TarotUser;

                return Expanded(
                  child: TabBarView(
                    children: [
                      _SunTab(user: user),
                      _MoonTab(user: user),
                      _RisingTab(user: user),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SunTab extends StatelessWidget {
  const _SunTab({required this.user});
  final TarotUser user;

  @override
  Widget build(BuildContext context) {
    final sign = user.zodiac;
    if (sign == null) return const SizedBox.shrink();
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.xlarge.h, Sp.screen.w, Sp.xxxlarge.h),
      child: _ZodiacSignInfo(sign: sign),
    );
  }
}

class _MoonTab extends StatelessWidget {
  const _MoonTab({required this.user});
  final TarotUser user;

  @override
  Widget build(BuildContext context) {
    final sign = user.moonSign;
    if (sign != null) {
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.xlarge.h, Sp.screen.w, Sp.xxxlarge.h),
        child: _ZodiacSignInfo(sign: sign),
      );
    }
    return _CalculatePrompt(
      isRising: false,
      title: LocaleKeys.zodiac_page_discover_moon.tr(),
      description: LocaleKeys.zodiac_page_desc_moon.tr(),
    );
  }
}

class _RisingTab extends StatelessWidget {
  const _RisingTab({required this.user});
  final TarotUser user;

  @override
  Widget build(BuildContext context) {
    final sign = user.risingSign;
    if (sign != null) {
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(Sp.screen.w, Sp.xlarge.h, Sp.screen.w, Sp.xxxlarge.h),
        child: _ZodiacSignInfo(sign: sign),
      );
    }
    return _CalculatePrompt(
      isRising: true,
      title: LocaleKeys.zodiac_page_discover_rising.tr(),
      description: LocaleKeys.zodiac_page_desc_rising.tr(),
    );
  }
}

class _ZodiacSignInfo extends StatelessWidget {
  const _ZodiacSignInfo({required this.sign});
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
                height: 96.w,
                borderRadius: 100,
                color: colors.primary.withValues(alpha: 0.1),
                child: Center(
                  child: SvgPicture.asset(
                    sign.svgPath,
                    width: 52.w,
                    height: 52.w,
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
              onTap:
                  () => context.pushNamed(
                    AppRoutes.tarotDeckDetail,
                    pathParameters: {'tarotId': card.id},
                  ),
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
                        height: 106.w,
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
                            height: 106.w,
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

class _CalculatePrompt extends StatelessWidget {
  const _CalculatePrompt({
    required this.isRising,
    required this.title,
    required this.description,
  });

  final bool isRising;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scope = ZodiacLearnPageScope.of(context).state;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sp.screen.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FancyContainer(
              width: 80.w,
              height: 80.w,
              borderRadius: 100,
              color: colors.primary.withValues(alpha: 0.1),
              child: Icon(
                isRising ? Icons.arrow_upward : Icons.nightlight_round,
                color: colors.primary,
                size: 36.sp,
              ),
            ),
            Sp.large.heightBox,
            Text(title, style: m18w600(context), textAlign: TextAlign.center),
            Sp.small.heightBox,
            Text(
              description,
              style: m13w400(context).copyWith(color: colors.textSecondary, height: 1.6),
              textAlign: TextAlign.center,
            ),
            Sp.xlarge.heightBox,
            ValueListenableBuilder<bool>(
              valueListenable: scope.isCalculating,
              builder: (context, calculating, _) {
                if (calculating) {
                  return FancyContainer(
                    padding: Sp.medium.padAllR,
                    borderRadius: Sp.large,
                    color: colors.primary.withValues(alpha: 0.1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: SpinKitFadingCircle(color: colors.primary, size: 16.w),
                        ),
                        Sp.small.widthBox,
                        Text(
                          LocaleKeys.zodiac_page_calculating.tr(),
                          style: m12w600(context).copyWith(color: colors.primary),
                        ),
                      ],
                    ),
                  );
                }
                return FancyButton(
                  text: LocaleKeys.zodiac_page_calculate.tr(),
                  width: 180.w,
                  height: 44.h,
                  textStyle: m14w700(context).copyWith(
                    color: colors.textOnPrimary,
                  ),
                  onTap: () => unawaited(_showBirthSheet(context, isRising, scope)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBirthSheet(BuildContext context, bool isRising, ZodiacLearnPageMixin scope) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Sp.xlarge.r),
        ),
      ),
      builder:
          (_) => _BirthInputSheet(
            isRising: isRising,
            onSubmit: (date, time, city) async {
              Navigator.of(context).pop();
              if (isRising) {
                await scope.calculateRising(
                  birthDate: date,
                  birthTime: time,
                  city: city ?? '',
                );
              } else {
                await scope.calculateMoon(birthDate: date, birthTime: time);
              }
            },
          ),
    );
  }
}

class _BirthInputSheet extends StatefulWidget {
  const _BirthInputSheet({required this.isRising, required this.onSubmit});
  final bool isRising;
  final Future<void> Function(DateTime date, TimeOfDay time, String? city) onSubmit;

  @override
  State<_BirthInputSheet> createState() => _BirthInputSheetState();
}

class _BirthInputSheetState extends State<_BirthInputSheet> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    if (_selectedDate == null || _selectedTime == null) return false;
    if (widget.isRising && _cityController.text.trim().isEmpty) return false;
    return true;
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.only(
        left: Sp.screen.w,
        right: Sp.screen.w,
        top: Sp.large.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + Sp.xxxlarge.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.borderSecondary,
                borderRadius: 2.radiusR,
              ),
            ),
          ),
          Sp.large.heightBox,
          Text(
            LocaleKeys.zodiac_page_birth_info_title.tr(),
            style: m18w600(context),
          ),
          Sp.large.heightBox,
          _PickerRow(
            label: LocaleKeys.zodiac_page_birth_date.tr(),
            value: _selectedDate != null ? _formatDate(_selectedDate!) : null,
            icon: Icons.calendar_today_outlined,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(1990),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
          ),
          Sp.medium.heightBox,
          _PickerRow(
            label: LocaleKeys.zodiac_page_birth_time.tr(),
            value: _selectedTime?.format(context),
            icon: Icons.access_time_outlined,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 12, minute: 0),
              );
              if (picked != null) setState(() => _selectedTime = picked);
            },
          ),
          if (widget.isRising) ...[
            Sp.medium.heightBox,
            Text(
              LocaleKeys.zodiac_page_birth_city.tr(),
              style: m12w600(context).copyWith(color: colors.textSecondary),
            ),
            Sp.xsmall.heightBox,
            FancyContainer(
              width: double.infinity,
              padding: Sp.medium.padAllR,
              color: colors.textSecondary.withValues(alpha: 0.06),
              child: TextField(
                controller: _cityController,
                onChanged: (_) => setState(() {}),
                style: m14w400(context),
                decoration: InputDecoration(
                  hintText: LocaleKeys.zodiac_page_birth_city_hint.tr(),
                  hintStyle: m13w400(context).copyWith(
                    color: colors.textSecondary.withValues(alpha: 0.4),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
          Sp.xlarge.heightBox,
          FancyButton(
            text: LocaleKeys.zodiac_page_calculate.tr(),
            width: double.infinity,
            height: 48.h,
            isDisabled: !_canSubmit,
            textStyle: m14w700(context).copyWith(color: colors.textOnPrimary),
            onTap:
                _canSubmit
                    ? () => widget.onSubmit(
                      _selectedDate!,
                      _selectedTime!,
                      widget.isRising ? _cityController.text.trim() : null,
                    )
                    : () {},
          ),
        ],
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: FancyContainer(
        width: double.infinity,
        padding: Sp.medium.padAllR,
        color: colors.textSecondary.withValues(alpha: 0.06),
        child: Row(
          children: [
            Icon(icon, color: colors.primary, size: 20.sp),
            Sp.medium.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: m10w500(context).copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  if (value != null) ...[
                    Sp.tiny.heightBox,
                    Text(value!, style: m14w700(context)),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colors.textSecondary.withValues(alpha: 0.5),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
