import 'dart:convert';

import 'package:daily_tarot_focus/domain/auth/lyrics_session.dart';
import 'package:flutter/services.dart';
import 'package:mobile_core/common_dependencies.dart';
import 'package:mobile_core/core_app.dart';
import 'package:mobile_core/domain/auth/auth_provider.dart' as domain;
import 'package:mobile_core/domain/auth/i_auth_service.dart';
import 'package:mobile_core/domain/auth/session.dart';
import 'package:mobile_core/domain/common/failure.dart';
import 'package:mobile_core/domain/common/http_utilities.dart';
import 'package:mobile_core/extensions.dart';
import 'package:mobile_core/infrastructure/auth/device_id_mixin.dart';
import 'package:mobile_core/infrastructure/http/http_failure_handler.dart';
import 'package:mobile_core/infrastructure/http/metric_http_client.dart';

class ImplAuthService extends IAuthService
    with HttpFailureHandlerMixin, DeviceIdMixin {
  ImplAuthService(
    this._client,
    this._sharedPreferences,
    this._httpFailureHandler,
  );
  final MetricHttpClient _client;
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
      final deviceId = await getDeviceId();

      final hostUri = Uri.parse(appConfig.apiHost);
      final uri = hostUri.resolveUri(Uri(path: '/lyrics/anonymous_login'));

      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'platform_device_id': deviceId.getRightOrNull()}),
      );

      final result = decodeResponseBody(response.bodyBytes);
      final statusCode = response.statusCode;

      final generalFailure = handleResult(statusCode, result);
      if (generalFailure != null) return left(generalFailure);

      final session = LyricsSession.fromMap({
        ...result,
        'provider': domain.AuthProvider.anonymous.key,
      });

      final saved = await _sharedPreferences.setString(
        _sessionKey,
        jsonEncode(session.toMap()),
      );

      if (saved == false) return left(const UnknownFailure());
      return right(session);
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        return left(const CancelledFailure());
      }

      return left(UnknownFailure());
    } catch (e) {
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
}
