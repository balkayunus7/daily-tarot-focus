import 'dart:async';

import 'package:country_flags/country_flags.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/core/util/text_style_helper.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_button.dart';
import 'package:daily_tarot_focus/core/widgets/fancy_container.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/birth_timezone_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class CityPickerSheet extends StatefulWidget {
  const CityPickerSheet({required this.onCitySelected, super.key});
  final void Function(String name, double lat, double lon, String? zoneName) onCitySelected;

  @override
  State<CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<CityPickerSheet> {
  List<csc.Country> _countries = [];
  List<csc.State> _states = [];
  List<csc.City> _cities = [];

  csc.Country? _country;
  csc.State? _state;
  csc.City? _city;

  final _searchCtrl = TextEditingController();
  bool _loading = true;
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() {}));
    unawaited(_loadCountries());
    unawaited(BirthTimezoneResolver.preload());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    final list = await csc.getAllCountries();
    if (mounted) {
      setState(() {
        _countries = list;
        _loading = false;
      });
    }
  }

  Future<void> _pickCountry(csc.Country c) async {
    setState(() {
      _country = c;
      _state = null;
      _city = null;
      _states = [];
      _cities = [];
      _loading = true;
      _step = 1;
      _searchCtrl.clear();
    });
    final list = await csc.getStatesOfCountry(c.isoCode);
    if (mounted) {
      setState(() {
        _states = list;
        _loading = false;
      });
    }
  }

  Future<void> _pickState(csc.State s) async {
    setState(() {
      _state = s;
      _city = null;
      _cities = [];
      _loading = true;
      _step = 2;
      _searchCtrl.clear();
    });
    final all = await csc.getStateCities(_country!.isoCode, s.isoCode);
    final withCoords =
        all.where((c) {
          final lat = double.tryParse(c.latitude ?? '');
          final lon = double.tryParse(c.longitude ?? '');
          return lat != null && lon != null;
        }).toList();
    if (mounted) {
      setState(() {
        _cities = withCoords;
        _loading = false;
      });
    }
  }

  void _pickCity(csc.City c) => setState(() => _city = c);

  void _confirm() {
    final city = _city!;
    final lat = double.parse(city.latitude!);
    final lon = double.parse(city.longitude!);
    final zoneName = BirthTimezoneResolver.zoneName(
      countryIsoCode: _country!.isoCode,
      longitude: lon,
    );
    widget.onCitySelected(city.name, lat, lon, zoneName);
    Navigator.of(context).pop();
  }

  void _back() {
    setState(() {
      _searchCtrl.clear();
      if (_step == 2) {
        _step = 1;
        _city = null;
        _cities = [];
      } else if (_step == 1) {
        _step = 0;
        _state = null;
        _states = [];
      }
    });
  }

  String get _title {
    if (_step == 0) return LocaleKeys.zodiac_page_select_country.tr();
    if (_step == 1) {
      return _country?.name ?? LocaleKeys.zodiac_page_select_state.tr();
    }
    return _state?.name ?? LocaleKeys.zodiac_page_select_city.tr();
  }

  String _nameOf(dynamic item) {
    if (item is csc.Country) return item.name;
    if (item is csc.State) return item.name;
    return (item as csc.City).name;
  }

  List<dynamic> get _filtered {
    final q = _searchCtrl.text.toLowerCase().trim();
    if (_step == 0) {
      return q.isEmpty
          ? _countries
          : _countries.where((c) => c.name.toLowerCase().contains(q)).toList();
    }
    if (_step == 1) {
      return q.isEmpty ? _states : _states.where((s) => s.name.toLowerCase().contains(q)).toList();
    }
    return q.isEmpty ? _cities : _cities.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final list = _filtered;
    final bottomSafePadding = MediaQuery.of(context).padding.bottom;
    final listBottomPadding =
        (_step == 2 && _city != null ? Sp.large.h : Sp.xxxlarge.h) + bottomSafePadding;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.78,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: Sp.large.h),
            child: Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.borderSecondary,
                  borderRadius: 2.radiusR,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sp.screen.w,
              vertical: Sp.medium.h,
            ),
            child: Row(
              children: [
                if (_step > 0)
                  GestureDetector(
                    onTap: _back,
                    child: Padding(
                      padding: EdgeInsets.only(right: Sp.small.w),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18.sp,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                Expanded(child: Text(_title, style: m18w600(context))),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sp.screen.w),
            child: FancyContainer(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: Sp.medium.w,
                vertical: Sp.small.h,
              ),
              color: colors.textSecondary.withValues(alpha: 0.06),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 18.sp,
                    color: colors.textSecondary.withValues(alpha: 0.5),
                  ),
                  Sp.small.widthBox,
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      style: m13w400(context),
                      decoration: InputDecoration(
                        hintText: LocaleKeys.zodiac_page_search_hint.tr(),
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
              ),
            ),
          ),
          Sp.small.heightBox,
          Expanded(
            child:
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : list.isEmpty && _step == 1
                    ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Sp.screen.w),
                        child: Text(
                          LocaleKeys.zodiac_page_no_states.tr(),
                          style: m13w400(
                            context,
                          ).copyWith(color: colors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    : list.isEmpty
                    ? Center(
                      child: Text(
                        LocaleKeys.zodiac_page_no_results.tr(),
                        style: m13w400(
                          context,
                        ).copyWith(color: colors.textSecondary),
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        Sp.screen.w,
                        0,
                        Sp.screen.w,
                        listBottomPadding,
                      ),
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final item = list[i];
                        final name = _nameOf(item);
                        final isSelected = _step == 2 && _city == item;
                        final isoCode = _step == 0 ? (item as csc.Country).isoCode : null;
                        return GestureDetector(
                          onTap: () {
                            if (_step == 0) {
                              unawaited(_pickCountry(item as csc.Country));
                            } else if (_step == 1) {
                              unawaited(_pickState(item as csc.State));
                            } else {
                              _pickCity(item as csc.City);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: Sp.xsmall.h),
                            child: FancyContainer(
                              width: double.infinity,
                              padding: Sp.medium.padAllR,
                              color:
                                  isSelected
                                      ? colors.primary.withValues(alpha: 0.12)
                                      : colors.textSecondary.withValues(
                                        alpha: 0.04,
                                      ),
                              child: Row(
                                children: [
                                  if (isoCode != null) ...[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: CountryFlag.fromCountryCode(
                                        isoCode,
                                        theme: const ImageTheme(
                                          height: 18,
                                          width: 26,
                                        ),
                                      ),
                                    ),
                                    Sp.small.widthBox,
                                  ],
                                  Expanded(
                                    child: Text(name, style: m14w400(context)),
                                  ),
                                  if (_step < 2)
                                    Icon(
                                      Icons.chevron_right,
                                      size: 18.sp,
                                      color: colors.textSecondary.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      size: 18.sp,
                                      color: colors.primary,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          if (_step == 2 && _city != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                Sp.screen.w,
                Sp.medium.h,
                Sp.screen.w,
                Sp.xxxlarge.h,
              ),
              child: FancyButton(
                text: LocaleKeys.zodiac_page_confirm.tr(),
                width: double.infinity,
                height: 48.h,
                textStyle: m14w700(
                  context,
                ).copyWith(color: colors.textOnPrimary),
                onTap: _confirm,
              ),
            ),
        ],
      ),
    );
  }
}
