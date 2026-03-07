import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_provider.dart' as domain;
import 'package:mobile_boilerplate/domain/auth/i_auth_service.dart';
import 'package:mobile_boilerplate/domain/auth/tarot_session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/domain/common/rate_limiter.dart';
import 'package:mobile_boilerplate/infrastructure/auth/device_id_mixin.dart';
import 'package:mobile_boilerplate/infrastructure/http/http_failure_handler.dart';
import 'package:mobile_boilerplate/infrastructure_dependencies.dart' hide User;
import 'package:supabase/supabase.dart' as supabase show Session;
import 'package:supabase/supabase.dart' hide Session;

class ImplAuthService extends IAuthService with HttpFailureHandlerMixin, DeviceIdMixin {
  ImplAuthService(
    this._supabaseClient,
    this._secureStorage,
    this._httpFailureHandler,
    this._rateLimiter,
  );

  static const _sessionKey = 'session';
  StreamSubscription<AuthState>? _authSubscription;

  @override
  Future<void> listenAuthChanges({SessionRefreshCallback? onSessionRefreshed}) async {
    await _authSubscription?.cancel();
    _authSubscription = _supabaseClient.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        unawaited(_saveSession(session));
        onSessionRefreshed?.call(_toTarotSession(session));
      }
    });
  }

  @override
  Future<FailureOr<TarotSession>> getCurrentSession() async {
    try {
      final currentSupabaseSession = supabaseClient.auth.currentSession;
      if (currentSupabaseSession != null) {
        return right(_toTarotSession(currentSupabaseSession));
      }

      final sessionJson = await secureStorage.read(key: _sessionKey);

      if (sessionJson != null) {
        try {
          final response = await supabaseClient.auth.recoverSession(sessionJson);

          final freshToken = response.session?.accessToken;
          if (freshToken != null && freshToken.isNotEmpty) {
            final recoveredSession = response.session!;
            await _saveSession(recoveredSession);
            return right(_toTarotSession(recoveredSession));
          }
        } on AuthException {
          await secureStorage.delete(key: _sessionKey);
        }
      }

      return left(const NotFoundFailure());
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Unit>> clearSession() async {
    try {
      await secureStorage.delete(key: _sessionKey);
      unawaited(_authSubscription?.cancel());

      return clearDeviceId();
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<TarotSession>> signInAnonymously() async {
    if (!rateLimiter.canProceed) {
      return left(const CancelledFailure());
    }
    rateLimiter.recordAttempt();

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

      rateLimiter.reset();
      return right(_toTarotSession(session, user));
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
      await secureStorage.delete(key: _sessionKey);
      return right(unit);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<TarotSession>> signInWithApple() async {
    throw UnimplementedError();
  }

  @override
  Future<FailureOr<TarotSession>> signInWithGoogle() async {
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

  TarotSession _toTarotSession(supabase.Session? session, [User? user]) {
    final resolvedUser = user ?? session!.user;

    return TarotSession(
      userId: resolvedUser.id,
      idToken: session?.accessToken ?? '',
      provider: domain.AuthProvider.anonymous,
    );
  }

  Future<void> _saveSession(supabase.Session session) {
    final jsonStr = jsonEncode(session.toJson());
    return _secureStorage.write(key: _sessionKey, value: jsonStr);
  }

  @override
  FlutterSecureStorage get secureStorage => _secureStorage;
  @override
  HttpFailureHandler get httpFailureHandler => _httpFailureHandler;
  SupabaseClient get supabaseClient => _supabaseClient;
  RateLimiter get rateLimiter => _rateLimiter;

  final HttpFailureHandler _httpFailureHandler;
  final FlutterSecureStorage _secureStorage;
  final SupabaseClient _supabaseClient;
  final RateLimiter _rateLimiter;
}
