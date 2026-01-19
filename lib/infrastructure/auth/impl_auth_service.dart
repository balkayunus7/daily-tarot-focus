import 'dart:convert';

import 'package:daily_tarot_focus/domain/auth/tarot_session.dart';
import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_provider.dart' as domain;
import 'package:mobile_boilerplate/domain/auth/i_auth_service.dart';
import 'package:mobile_boilerplate/domain/auth/session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/infrastructure/auth/device_id_mixin.dart';
import 'package:mobile_boilerplate/infrastructure/http/http_failure_handler.dart';
import 'package:supabase/supabase.dart' hide Session;

class ImplAuthService extends IAuthService with HttpFailureHandlerMixin, DeviceIdMixin {
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
      final sessionJson = _sharedPreferences.getString(_sessionKey);
      if (sessionJson == null) return left(const NotFoundFailure());

      final session = TarotSession.fromMap(
        jsonDecode(sessionJson) as Map<String, dynamic>,
      );
      return right(session);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Session>> updateSession(Session session) async {
    try {
      final tarotSession = session as TarotSession;
      final saved = await _sharedPreferences.setString(
        _sessionKey,
        jsonEncode(tarotSession.toMap()),
      );
      if (!saved) return left(const UnknownFailure());
      return right(session);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Unit>> clearSession() async {
    try {
      await _sharedPreferences.remove(_sessionKey);
      return clearDeviceId();
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Session>> signInAnonymously() async {
    try {
      final deviceIdResult = await getDeviceId();
      final deviceId = deviceIdResult.fold((l) => null, (r) => r);

      final response = await _supabaseClient.auth.signInAnonymously(
        data: {'platform_device_id': deviceId},
      );

      final user = response.user;
      if (user == null) return left(const UnknownFailure());

      final session = TarotSession(
        userId: user.id,
        idToken: response.session?.accessToken ?? '',
        isNewUser: false,
        provider: domain.AuthProvider.anonymous,
      );

      final saved = await _sharedPreferences.setString(
        _sessionKey,
        jsonEncode(session.toMap()),
      );

      if (!saved) {
        return left(const UnknownFailure());
      }

      return right(session);
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        return left(const CancelledFailure());
      }
      return left(const UnknownFailure());
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Unit>> signOutAnonymously() async {
    try {
      await _sharedPreferences.remove(_sessionKey);
      return right(unit);
    } on Exception {
      return left(const UnknownFailure());
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
