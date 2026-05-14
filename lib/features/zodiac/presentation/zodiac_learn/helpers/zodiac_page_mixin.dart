import 'package:daily_tarot_focus/core/util/build_context_toast_ext.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_properties.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/astrology_helper.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/pages/zodiac_learn_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:timezone/timezone.dart' as tz;

mixin ZodiacLearnPageMixin on State<ZodiacLearnPage> {
  late ValueNotifier<bool> isCalculating;

  @override
  void initState() {
    super.initState();
    isCalculating = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    isCalculating.dispose();
    super.dispose();
  }

  Future<void> calculateMoon({required DateTime birthDate, required TimeOfDay birthTime}) async {
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
      if (mounted) context.showToastMessage(LocaleKeys.zodiac_page_success_moon.tr());
    } on Exception catch (_) {
      if (mounted) context.showErrorToastMessage(LocaleKeys.zodiac_page_error.tr());
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
      if (mounted) context.showToastMessage(LocaleKeys.zodiac_page_success_rising.tr());
    } on Exception catch (_) {
      if (mounted) context.showErrorToastMessage(LocaleKeys.zodiac_page_error.tr());
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
    return localDateTime.subtract(Duration(minutes: (longitude / 15 * 60).round()));
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
    final succeeded = authCubit.state.failOrUpdatedOption.fold(() => false, (e) => e.isRight());
    if (!succeeded) throw Exception('Update failed');
  }
}
