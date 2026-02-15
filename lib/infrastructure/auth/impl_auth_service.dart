import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_provider.dart' as domain;
import 'package:mobile_boilerplate/domain/auth/i_auth_service.dart';
import 'package:mobile_boilerplate/domain/auth/session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/infrastructure/auth/device_id_mixin.dart';
import 'package:mobile_boilerplate/infrastructure/http/http_failure_handler.dart';
import 'package:supabase/supabase.dart' hide Session;
import 'package:supabase/supabase.dart' as supabase show Session;

class ImplAuthService extends IAuthService
    with HttpFailureHandlerMixin, DeviceIdMixin {
  ImplAuthService(
    this._supabaseClient,
    this._sharedPreferences,
    this._httpFailureHandler,
  );

  static const _sessionKey = 'session';
  StreamSubscription<AuthState>? _authSubscription;

  @override
  Future<void> listenAuthChanges() async {
    await _authSubscription?.cancel();
    _authSubscription = _supabaseClient.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        unawaited(_saveSession(session));
      }
    });
  }

  @override
  Future<FailureOr<Session>> getCurrentSession() async {
    try {
      final currentSupabaseSession = supabaseClient.auth.currentSession;
      if (currentSupabaseSession != null) {
        return right(_toSession(currentSupabaseSession));
      }

      final sessionJson = _sharedPreferences.getString(
        _sessionKey,
      );
      if (sessionJson != null) {
        try {
          final response = await supabaseClient.auth.recoverSession(
            sessionJson,
          );
          final freshToken = response.session?.accessToken;
          if (freshToken != null && freshToken.isNotEmpty) {
            final recoveredSession = response.session!;
            await _saveSession(recoveredSession);
            return right(_toSession(recoveredSession));
          }
        } on AuthException {
          await _sharedPreferences.remove(_sessionKey);
        }
      }

      return left(const NotFoundFailure());
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Session>> updateSession(Session session) async {
    try {
      return right(session);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Unit>> clearSession() async {
    try {
      await _sharedPreferences.remove(_sessionKey);
      unawaited(_authSubscription?.cancel());
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

      final response = await supabaseClient.auth.signInAnonymously(
        data: {'platform_device_id': deviceId},
      );

      final user = response.user;
      if (user == null) return left(const UnknownFailure());

      final session = response.session;
      if (session != null) {
        await _saveSession(session);
      }

      return right(_toSession(session, user));
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

  Session _toSession(supabase.Session? session, [User? user]) {
    final resolvedUser = user ?? session!.user;
    return Session(
      userId: resolvedUser.id,
      idToken: session?.accessToken ?? '',
      isNewUser: false,
      provider: domain.AuthProvider.anonymous,
    );
  }

  Future<bool> _saveSession(supabase.Session session) {
    final jsonStr = jsonEncode(session.toJson());
    return _sharedPreferences.setString(_sessionKey, jsonStr);
  }

  @override
  HttpFailureHandler get httpFailureHandler => _httpFailureHandler;
  SupabaseClient get supabaseClient => _supabaseClient;

  final HttpFailureHandler _httpFailureHandler;
  final SharedPreferences _sharedPreferences;
  final SupabaseClient _supabaseClient;
}
