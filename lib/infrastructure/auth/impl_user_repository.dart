import 'dart:convert';

import 'package:daily_tarot_focus/domain/auth/lyrics_user.dart';
import 'package:mobile_core/common_dependencies.dart';
import 'package:mobile_core/core_app.dart';
import 'package:mobile_core/domain/auth/i_user_repository.dart';
import 'package:mobile_core/domain/auth/session.dart';
import 'package:mobile_core/domain/auth/user.dart';
import 'package:mobile_core/domain/common/failure.dart';
import 'package:mobile_core/domain/common/http_utilities.dart';
import 'package:mobile_core/infrastructure/http/http_failure_handler.dart';
import 'package:mobile_core/infrastructure/http/metric_http_client.dart';

class ImplUserRepository extends IUserRepository with HttpFailureHandlerMixin {
  ImplUserRepository(this._client, this._httpFailureHandler);

  @override
  Future<FailureOr<User>> getUser({required Session session}) async {
    try {
      final hostUri = Uri.parse(appConfig.apiHost);
      final uri = hostUri.resolveUri(Uri(path: '/lyrics/user-info'));

      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'user-id': session.userId,
          'user-session': session.idToken,
        },
      );

      final result = decodeResponseBody(response.bodyBytes);
      final generalFailure = handleResult(response.statusCode, result);
      if (generalFailure != null) return left(generalFailure);
      return right(LyricsUser.fromMap(result));
    } catch (e) {
      return left(handleErrorsAndExceptions(e));
    }
  }

  @override
  Future<FailureOr<Unit>> deleteUser({required Session session}) async {
    try {
      return right(unit);
    } catch (e) {
      return left(handleErrorsAndExceptions(e));
    }
  }

  @override
  Future<FailureOr<Unit>> setFcmToken({
    required Session session,
    required String fcmToken,
  }) async {
    try {
      final hostUri = Uri.parse(appConfig.apiHost);
      final uri = hostUri.resolveUri(Uri(path: '/lyrics/update_firebase_token'));

      final response = await _client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'user-id': session.userId,
          'user-session': session.idToken,
        },
        body: jsonEncode({'firebase_token': fcmToken}),
      );

      final result = decodeResponseBody(response.bodyBytes);
      final generalFailure = handleResult(response.statusCode, result);
      if (generalFailure != null) return left(generalFailure);

      return right(unit);
    } catch (e) {
      return left(handleErrorsAndExceptions(e));
    }
  }

  final MetricHttpClient _client;
  final HttpFailureHandler _httpFailureHandler;

  @override
  HttpFailureHandler get httpFailureHandler => _httpFailureHandler;

  @override
  Future<FailureOr<Unit>> updateLocation({
    required Session session,
    required String city,
  }) {
    throw UnimplementedError();
  }
}
