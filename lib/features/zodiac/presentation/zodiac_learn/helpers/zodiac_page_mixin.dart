import 'package:daily_tarot_focus/core/util/build_context_toast_ext.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/core/util/tarot_app_sizes.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_properties.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/astrology_helper.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/pages/zodiac_learn_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';
import 'package:timezone/timezone.dart' as tz;

mixin ZodiacLearnPageMixin on State<ZodiacLearnPage> {
  late ValueNotifier<bool> isCalculating;
  late ValueNotifier<Map<DiscoverZodiacType, ZodiacSign>> previewSigns;

  @override
  void initState() {
    super.initState();
    isCalculating = ValueNotifier<bool>(false);
    previewSigns = ValueNotifier<Map<DiscoverZodiacType, ZodiacSign>>({});
  }

  @override
  void dispose() {
    isCalculating.dispose();
    previewSigns.dispose();
    super.dispose();
  }

  Future<void> showPreviewBirthSheet(
    BuildContext context,
    DiscoverZodiacType type,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Sp.xlarge.r)),
      ),
      builder: (_) {
        return BirthInputSheet(
          type: type,
          onSubmit: (date, time, latitude, longitude, zoneName) async {
            Navigator.of(context).pop();
            await calculatePreviewSign(
              type: type,
              birthDate: date,
              birthTime: time,
              latitude: latitude,
              longitude: longitude,
              zoneName: zoneName,
            );
          },
        );
      },
    );
  }

  Future<void> calculatePreviewSign({
    required DiscoverZodiacType type,
    required DateTime birthDate,
    required TimeOfDay? birthTime,
    double? latitude,
    double? longitude,
    String? zoneName,
  }) async {
    if (isCalculating.value) return;
    isCalculating.value = true;
    try {
      final sign = switch (type) {
        DiscoverZodiacType.sun => ZodiacLearnHelper.sunSign(birthDate),
        DiscoverZodiacType.moon => ZodiacLearnHelper.moonSign(
          DateTime(
            birthDate.year,
            birthDate.month,
            birthDate.day,
            birthTime!.hour,
            birthTime.minute,
          ).toUtc(),
        ),
        DiscoverZodiacType.rising => ZodiacLearnHelper.risingSign(
          _resolveUtc(
            birthDate: birthDate,
            birthTime: birthTime!,
            longitude: longitude!,
            zoneName: zoneName,
          ),
          latitude!,
          longitude,
        ),
      };
      previewSigns.value = {
        ...previewSigns.value,
        type: sign,
      };
    } on Exception catch (_) {
      if (mounted) {
        context.showErrorToastMessage(LocaleKeys.zodiac_page_error.tr());
      }
    } finally {
      if (mounted) isCalculating.value = false;
    }
  }

  Future<void> calculateMoon({
    required DateTime birthDate,
    required TimeOfDay birthTime,
  }) async {
    if (isCalculating.value) return;
    isCalculating.value = true;
    try {
      final birthDateTime = DateTime(
        birthDate.year,
        birthDate.month,
        birthDate.day,
        birthTime.hour,
        birthTime.minute,
      );
      final sign = ZodiacLearnHelper.moonSign(birthDateTime.toUtc());
      await _saveSign(moonSign: sign);
      if (mounted) {
        context.showToastMessage(LocaleKeys.zodiac_page_success_moon.tr());
      }
    } on Exception catch (_) {
      if (mounted) {
        context.showErrorToastMessage(LocaleKeys.zodiac_page_error.tr());
      }
    } finally {
      if (mounted) isCalculating.value = false;
    }
  }

  Future<void> calculateRising({
    required DateTime birthDate,
    required TimeOfDay birthTime,
    required double latitude,
    required double longitude,
    String? zoneName,
  }) async {
    if (isCalculating.value) return;
    isCalculating.value = true;
    try {
      final utc = _resolveUtc(
        birthDate: birthDate,
        birthTime: birthTime,
        longitude: longitude,
        zoneName: zoneName,
      );
      final sign = ZodiacLearnHelper.risingSign(utc, latitude, longitude);
      await _saveSign(risingSign: sign);
      if (mounted) {
        context.showToastMessage(LocaleKeys.zodiac_page_success_rising.tr());
      }
    } on Exception catch (_) {
      if (mounted) {
        context.showErrorToastMessage(LocaleKeys.zodiac_page_error.tr());
      }
    } finally {
      if (mounted) isCalculating.value = false;
    }
  }

  /// Convert birth wall-clock to UTC. Prefers IANA tz (DST + historical rules
  /// via the `timezone` package); falls back to longitude-based LMT if no zone
  /// is provided or the lookup fails.
  DateTime _resolveUtc({
    required DateTime birthDate,
    required TimeOfDay birthTime,
    required double longitude,
    required String? zoneName,
  }) {
    if (zoneName != null) {
      try {
        final location = tz.getLocation(zoneName);
        return tz.TZDateTime(
          location,
          birthDate.year,
          birthDate.month,
          birthDate.day,
          birthTime.hour,
          birthTime.minute,
        ).toUtc();
      } on tz.LocationNotFoundException {
        // fall through to LMT
      }
    }
    final localDateTime = DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
      birthTime.hour,
      birthTime.minute,
    );
    return localDateTime.subtract(
      Duration(minutes: (longitude / 15 * 60).round()),
    );
  }

  Future<void> _saveSign({ZodiacSign? moonSign, ZodiacSign? risingSign}) async {
    final authCubit = context.read<AuthCubit>();
    final user = authCubit.state.userOrCrash as TarotUser;
    final properties = TarotUserProperties(
      zodiac: user.zodiac,
      relationshipStatus: user.relationshipStatus!,
      careerStatus: user.careerStatus!,
      name: user.name ?? '',
      birthDate: user.birthDate ?? DateTime.now(),
      location: user.location ?? '',
      moonSign: moonSign ?? user.moonSign,
      risingSign: risingSign ?? user.risingSign,
    );
    await authCubit.updateUser(properties: properties);
    final succeeded = authCubit.state.failOrUpdatedOption.fold(
      () => false,
      (e) => e.isRight(),
    );
    if (!succeeded) throw Exception('Update failed');
  }
}

extension ZodiacResultCopy on ZodiacSign {
  String get majorArcanaMessage {
    switch (this) {
      case ZodiacSign.aries:
        return LocaleKeys.zodiac_page_major_arcana_message_aries.tr();
      case ZodiacSign.taurus:
        return LocaleKeys.zodiac_page_major_arcana_message_taurus.tr();
      case ZodiacSign.gemini:
        return LocaleKeys.zodiac_page_major_arcana_message_gemini.tr();
      case ZodiacSign.cancer:
        return LocaleKeys.zodiac_page_major_arcana_message_cancer.tr();
      case ZodiacSign.leo:
        return LocaleKeys.zodiac_page_major_arcana_message_leo.tr();
      case ZodiacSign.virgo:
        return LocaleKeys.zodiac_page_major_arcana_message_virgo.tr();
      case ZodiacSign.libra:
        return LocaleKeys.zodiac_page_major_arcana_message_libra.tr();
      case ZodiacSign.scorpio:
        return LocaleKeys.zodiac_page_major_arcana_message_scorpio.tr();
      case ZodiacSign.sagittarius:
        return LocaleKeys.zodiac_page_major_arcana_message_sagittarius.tr();
      case ZodiacSign.capricorn:
        return LocaleKeys.zodiac_page_major_arcana_message_capricorn.tr();
      case ZodiacSign.aquarius:
        return LocaleKeys.zodiac_page_major_arcana_message_aquarius.tr();
      case ZodiacSign.pisces:
        return LocaleKeys.zodiac_page_major_arcana_message_pisces.tr();
    }
  }

  String get energyFocus {
    switch (element) {
      case ZodiacElement.fire:
        return LocaleKeys.zodiac_page_energy_focus_fire.tr();
      case ZodiacElement.earth:
        return LocaleKeys.zodiac_page_energy_focus_earth.tr();
      case ZodiacElement.air:
        return LocaleKeys.zodiac_page_energy_focus_air.tr();
      case ZodiacElement.water:
        return LocaleKeys.zodiac_page_energy_focus_water.tr();
    }
  }

  String get growthKey {
    switch (modality) {
      case ZodiacModality.cardinal:
        return LocaleKeys.zodiac_page_growth_key_cardinal.tr();
      case ZodiacModality.fixed:
        return LocaleKeys.zodiac_page_growth_key_fixed.tr();
      case ZodiacModality.mutable:
        return LocaleKeys.zodiac_page_growth_key_mutable.tr();
    }
  }

  String get dailyIntention {
    switch (this) {
      case ZodiacSign.aries:
        return LocaleKeys.zodiac_page_daily_intention_aries.tr();
      case ZodiacSign.taurus:
        return LocaleKeys.zodiac_page_daily_intention_taurus.tr();
      case ZodiacSign.gemini:
        return LocaleKeys.zodiac_page_daily_intention_gemini.tr();
      case ZodiacSign.cancer:
        return LocaleKeys.zodiac_page_daily_intention_cancer.tr();
      case ZodiacSign.leo:
        return LocaleKeys.zodiac_page_daily_intention_leo.tr();
      case ZodiacSign.virgo:
        return LocaleKeys.zodiac_page_daily_intention_virgo.tr();
      case ZodiacSign.libra:
        return LocaleKeys.zodiac_page_daily_intention_libra.tr();
      case ZodiacSign.scorpio:
        return LocaleKeys.zodiac_page_daily_intention_scorpio.tr();
      case ZodiacSign.sagittarius:
        return LocaleKeys.zodiac_page_daily_intention_sagittarius.tr();
      case ZodiacSign.capricorn:
        return LocaleKeys.zodiac_page_daily_intention_capricorn.tr();
      case ZodiacSign.aquarius:
        return LocaleKeys.zodiac_page_daily_intention_aquarius.tr();
      case ZodiacSign.pisces:
        return LocaleKeys.zodiac_page_daily_intention_pisces.tr();
    }
  }
}
