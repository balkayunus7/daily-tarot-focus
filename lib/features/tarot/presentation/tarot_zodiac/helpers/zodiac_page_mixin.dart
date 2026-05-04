import 'package:daily_tarot_focus/core/util/build_context_toast_ext.dart';
import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_properties.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_zodiac/helpers/astrology_service.dart';
import 'package:daily_tarot_focus/features/tarot/presentation/tarot_zodiac/pages/tarot_zodiac_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mobile_boilerplate/application/auth/auth_cubit.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

mixin ZodiacPageMixin on State<TarotZodiacDetailPage> {
  final isCalculating = ValueNotifier<bool>(false);

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
      final sign = AstrologyService.moonSign(birthDateTime.toUtc());
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
    required String city,
  }) async {
    if (isCalculating.value) return;
    isCalculating.value = true;
    try {
      final locations = await locationFromAddress(city);
      if (locations.isEmpty) {
        if (mounted) {
          context.showErrorToastMessage(LocaleKeys.zodiac_page_city_not_found.tr());
          isCalculating.value = false;
        }
        return;
      }
      final lat = locations.first.latitude;
      final lon = locations.first.longitude;
      final localDateTime = DateTime(
        birthDate.year,
        birthDate.month,
        birthDate.day,
        birthTime.hour,
        birthTime.minute,
      );
      final utcApprox = localDateTime.subtract(Duration(minutes: (lon / 15 * 60).round()));
      final sign = AstrologyService.risingSign(utcApprox, lat, lon);
      await _saveSign(risingSign: sign);
      if (mounted) context.showToastMessage(LocaleKeys.zodiac_page_success_rising.tr());
    } on Exception catch (_) {
      if (mounted) context.showErrorToastMessage(LocaleKeys.zodiac_page_error.tr());
    } finally {
      if (mounted) isCalculating.value = false;
    }
  }

  Future<void> _saveSign({ZodiacSign? moonSign, ZodiacSign? risingSign}) async {
    final authCubit = context.read<AuthCubit>();
    final user = authCubit.state.userOrCrash as TarotUser;
    final properties = TarotUserProperties(
      zodiac: user.zodiac!,
      relationshipStatus: user.relationshipStatus!,
      careerStatus: user.careerStatus!,
      moonSign: moonSign ?? user.moonSign,
      risingSign: risingSign ?? user.risingSign,
    );
    await authCubit.updateUser(properties: properties);
    final succeeded = authCubit.state.failOrUpdatedOption.fold(() => false, (e) => e.isRight());
    if (!succeeded) throw Exception('Update failed');
  }
}
