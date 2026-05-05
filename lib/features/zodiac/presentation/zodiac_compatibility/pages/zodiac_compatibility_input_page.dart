import 'package:daily_tarot_focus/config/app_routes.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/tarot_app_bar.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_compatibility/models/zodiac_compatibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:mobile_boilerplate/presentation/widgets/scaling_container.dart';

class TarotCompatibilityInputPage extends StatefulWidget {
  const TarotCompatibilityInputPage({super.key});

  @override
  State<TarotCompatibilityInputPage> createState() => _TarotCompatibilityInputPageState();
}

class _TarotCompatibilityInputPageState extends State<TarotCompatibilityInputPage> {
  late ZodiacSign _mySign;
  late ZodiacSign _partnerSign;
  CompatGender _myGender = CompatGender.female;
  CompatGender _partnerGender = CompatGender.male;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    final user = authState.userOrCrash;
    _mySign = (user is TarotUser ? user.zodiac : null) ?? ZodiacSign.aries;
    _partnerSign = ZodiacSign.values[(_mySign.index + 6) % ZodiacSign.values.length];
  }

  Future<void> _calculate() async {
    final result = CompatibilityResult.calculate(_mySign, _partnerSign);
    final input = CompatibilityInput(
      mySign: _mySign,
      myGender: _myGender,
      partnerSign: _partnerSign,
      partnerGender: _partnerGender,
    );
    await context.push(
      AppRoutes.tarotCompatibilityResult,
      extra: (input, result),
    );
  }

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
                  Sp.xxxlarge.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PersonSection(
                      label: LocaleKeys.compat_page_you.tr(),
                      selectedSign: _mySign,
                      selectedGender: _myGender,
                      onSignChanged: (s) => setState(() => _mySign = s),
                      onGenderChanged: (g) => setState(() => _myGender = g),
                    ),
                    Sp.xlarge.heightBox,
                    _PersonSection(
                      label: LocaleKeys.compat_page_partner.tr(),
                      selectedSign: _partnerSign,
                      selectedGender: _partnerGender,
                      onSignChanged: (s) => setState(() => _partnerSign = s),
                      onGenderChanged: (g) => setState(() => _partnerGender = g),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                Sp.screen.w,
                Sp.medium.h,
                Sp.screen.w,
                Sp.xlarge.h + MediaQuery.of(context).padding.bottom,
              ),
              child: FancyButton(
                width: double.infinity,
                height: 52.h,
                text: LocaleKeys.compat_page_calculate.tr(),
                textStyle: m16w700(context).copyWith(color: colors.textOnPrimary),
                onTap: _calculate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Person section (label + picker + gender) ─────────────────────────────────

class _PersonSection extends StatelessWidget {
  const _PersonSection({
    required this.label,
    required this.selectedSign,
    required this.selectedGender,
    required this.onSignChanged,
    required this.onGenderChanged,
  });

  final String label;
  final ZodiacSign selectedSign;
  final CompatGender selectedGender;
  final ValueChanged<ZodiacSign> onSignChanged;
  final ValueChanged<CompatGender> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: Sp.large.radiusR,
        border: Border.all(color: colors.border),
      ),
      padding: Sp.large.padAllR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: m18w700(context)),
          Sp.large.heightBox,
          _ZodiacPicker(
            initialSign: selectedSign,
            onChanged: onSignChanged,
          ),
          Sp.large.heightBox,
          _GenderPicker(
            selected: selectedGender,
            onChanged: onGenderChanged,
          ),
        ],
      ),
    );
  }
}

// ── Infinite horizontal zodiac picker ────────────────────────────────────────

class _ZodiacPicker extends StatefulWidget {
  const _ZodiacPicker({
    required this.initialSign,
    required this.onChanged,
  });

  final ZodiacSign initialSign;
  final ValueChanged<ZodiacSign> onChanged;

  @override
  State<_ZodiacPicker> createState() => _ZodiacPickerState();
}

class _ZodiacPickerState extends State<_ZodiacPicker> {
  static const List<ZodiacSign> _signs = ZodiacSign.values;
  static const _loopFactor = 100;
  static const int _total = 12 * _loopFactor;
  static const int _midOffset = 12 * (_loopFactor ~/ 2);

  late final PageController _controller;
  late double _currentPage;

  int get _initialPage => _midOffset + widget.initialSign.index;

  @override
  void initState() {
    super.initState();
    _currentPage = _initialPage.toDouble();
    _controller = PageController(
      initialPage: _initialPage,
      viewportFraction: 1 / 3,
    )..addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() => _currentPage = _controller.page ?? _currentPage);
    final idx = _controller.page?.round() ?? _initialPage;
    widget.onChanged(_signs[idx % 12]);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88.h,
      child: PageView.builder(
        controller: _controller,
        itemCount: _total,
        itemBuilder: (context, index) {
          final sign = _signs[index % 12];
          final distance = (index - _currentPage).abs();
          final scale = (1.0 - distance * 0.22).clamp(0.72, 1.0);
          final opacity = (1.0 - distance * 0.45).clamp(0.45, 1.0);
          final isCenter = distance < 0.5;
          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: _ZodiacPickerItem(sign: sign, isSelected: isCenter),
            ),
          );
        },
      ),
    );
  }
}

class _ZodiacPickerItem extends StatelessWidget {
  const _ZodiacPickerItem({required this.sign, required this.isSelected});

  final ZodiacSign sign;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.gradientStart, colors.gradientEnd],
            ),
            border: isSelected ? Border.all(color: colors.primary, width: 2) : null,
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.35),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                    : null,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            sign.svgPath,
            width: 26.w,
            height: 26.w,
            colorFilter: ColorFilter.mode(
              colors.textOnPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
        Sp.xsmall.heightBox,
        Text(
          sign.localizedName,
          style: m11w500(context).copyWith(
            color: isSelected ? colors.textPrimary : colors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ── Gender picker ─────────────────────────────────────────────────────────────

class _GenderPicker extends StatelessWidget {
  const _GenderPicker({required this.selected, required this.onChanged});

  final CompatGender selected;
  final ValueChanged<CompatGender> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _GenderButton(
          symbol: '♀',
          gender: CompatGender.female,
          selected: selected,
          onTap: () => onChanged(CompatGender.female),
        ),
        Sp.small.widthBox,
        _GenderButton(
          symbol: '♂',
          gender: CompatGender.male,
          selected: selected,
          onTap: () => onChanged(CompatGender.male),
        ),
        Sp.small.widthBox,
        _GenderButton(
          symbol: '⚧',
          gender: CompatGender.nonBinary,
          selected: selected,
          onTap: () => onChanged(CompatGender.nonBinary),
        ),
      ],
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.symbol,
    required this.gender,
    required this.selected,
    required this.onTap,
  });

  final String symbol;
  final CompatGender gender;
  final CompatGender selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = gender == selected;
    return ScalingContainer(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isSelected
                  ? colors.primary.withValues(alpha: 0.18)
                  : colors.primary.withValues(alpha: 0.06),
          border: Border.all(
            color: isSelected ? colors.primary : colors.primary.withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: 20.sp,
            color: isSelected ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
