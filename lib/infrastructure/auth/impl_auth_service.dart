import 'dart:convert';

import 'package:daily_tarot_focus/domain/auth/lyrics_session.dart';
import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_provider.dart' as domain;
import 'package:mobile_boilerplate/domain/auth/i_auth_service.dart';
import 'package:mobile_boilerplate/domain/auth/session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/infrastructure/auth/device_id_mixin.dart';
import 'package:mobile_boilerplate/infrastructure/http/http_failure_handler.dart';
import 'package:supabase/supabase.dart' hide Session;

class ImplAuthService extends IAuthService
    with HttpFailureHandlerMixin, DeviceIdMixin {
  ImplAuthService(
    this._supabaseClient,
    this._sharedPreferences,
    this._httpFailureHandler,
  );
  final SupabaseClient _supabaseClient;
  static const _sessionKey = 'session';

  @override
  Future<FailureOr<Session>> getCurrentSession() async {
    try {
      final session = _sharedPreferences.getString(_sessionKey);
      if (session == null) return left(const NotFoundFailure());
      return right(LyricsSession.fromMap(jsonDecode(session)));
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Session>> updateSession(Session session) async {
    try {
      session as LyricsSession;
      var map = session.toMap();
      final saved = await _sharedPreferences.setString(
        _sessionKey,
        jsonEncode(map),
      );
      if (saved == false) return left(const UnknownFailure());
      return right(session);
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Unit>> clearSession() async {
    try {
      await _sharedPreferences.remove(_sessionKey);
      return clearDeviceId();
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Session>> signInAnonymously() async {
    try {
      // Önce mevcut session'ı kontrol et
      final existingSession = await getCurrentSession();
      if (existingSession.isRight()) {
        print('✅ Mevcut session bulundu, geri döndürülüyor');
        return existingSession;
      }

      print('❌ Mevcut session bulunamadı, yeni login yapılıyor');

      // Mevcut session yoksa yeni login yap
      final deviceIdResult = await getDeviceId();
      final deviceId = deviceIdResult.fold((l) => null, (r) => r);

      print('📱 Device ID: $deviceId');

      final response = await _supabaseClient.auth.signInAnonymously(
        data: {'platform_device_id': deviceId},
      );

      final user = response.user;
      if (user == null) {
        print('❌ User null döndü');
        return left(const UnknownFailure());
      }

      print('✅ Anon login başarılı: ${user.id}');

      final session = LyricsSession(
        userId: user.id,
        idToken: response.session?.accessToken ?? '',
        isNewUser: true,
        provider: domain.AuthProvider.anonymous,
      );

      final saved = await _sharedPreferences.setString(
        _sessionKey,
        jsonEncode(session.toMap()),
      );

      if (saved == false) {
        print('❌ SharedPreferences kaydetme başarısız');
        return left(const UnknownFailure());
      }

      print('✅ Session kaydedildi');
      return right(session);
    } on PlatformException catch (e) {
      print('❌ PlatformException: ${e.code} - ${e.message}');
      if (e.code == 'sign_in_canceled') {
        return left(const CancelledFailure());
      }
      return left(UnknownFailure());
    } catch (e) {
      print('❌ Exception: $e');
      return left(UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Unit>> signOutAnonymously() async {
    try {
      await _sharedPreferences.remove(_sessionKey);
      return right(unit);
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Session>> signInWithApple() async {
    throw UnimplementedError();
  }

  @override
  Future<FailureOr<Session>> signInWithGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<FailureOr<Unit>> signOutApple() async {
    throw UnimplementedError();
  }

  @override
  Future<FailureOr<Unit>> signOutGoogle() async {
    throw UnimplementedError();
  }

  @override
  HttpFailureHandler get httpFailureHandler => _httpFailureHandler;

  final HttpFailureHandler _httpFailureHandler;
  final SharedPreferences _sharedPreferences;
  SupabaseClient get supabaseClient => _supabaseClient;
}
