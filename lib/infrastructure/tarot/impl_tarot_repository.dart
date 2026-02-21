import 'dart:developer';

import 'package:daily_tarot_focus/domain/tarot/daily_tarot_record.dart';
import 'package:daily_tarot_focus/domain/tarot/i_tarot_repository.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/domain/common/http_utilities.dart';
import 'package:mobile_boilerplate/infrastructure/http/http_failure_handler.dart';
import 'package:supabase/supabase.dart' hide Session;

class ImplTarotRepository extends ITarotRepository with HttpFailureHandlerMixin {
  ImplTarotRepository(this._supabaseClient, this._httpFailureHandler);

  @override
  Future<FailureOr<Unit>> saveDailyCard({
    required Session session,
    required String cardId,
  }) async {
    try {
      final currentSession = _supabaseClient.auth.currentSession;
      final liveToken = currentSession?.accessToken;
      if (liveToken == null) return left(const UnknownFailure());

      final expiresAt = currentSession!.expiresAt;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      log('saveDailyCard → token expires_at: $expiresAt, now: $now, kalan: ${expiresAt! - now}s');

      final response = await _supabaseClient.functions.invoke(
        'save-daily-card',
        headers: {'authorization': 'Bearer $liveToken'},
        body: {'card_id': cardId},
      );

      final data = decodeSupabaseResponse(response.data);
      final generalFailure = handleResult(response.status, data);
      if (generalFailure != null) return left(generalFailure);

      return right(unit);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<List<DailyTarotRecord>>> getDailyCards({
    required Session session,
  }) async {
    try {
      final currentSession = _supabaseClient.auth.currentSession;
      final liveToken = currentSession?.accessToken;
      if (liveToken == null) return left(const UnknownFailure());

      final expiresAt = currentSession!.expiresAt;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      log('getDailyCards → token expires_at: $expiresAt, now: $now, kalan: ${expiresAt! - now}s');

      final response = await _supabaseClient.functions.invoke(
        'get-daily-cards',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $liveToken'},
      );

      log('getDailyCards → status: ${response.status}, data type: ${response.data.runtimeType}');
      final data = response.data;

      final records =
          (data as List)
              .map((item) => DailyTarotRecord.fromMap(item as Map<String, dynamic>))
              .toList();

      return right(records);
    } on Exception catch (e, st) {
      log('getDailyCards → EXCEPTION: $e');
      log('getDailyCards → STACKTRACE: $st');
      return left(const UnknownFailure());
    }
  }

  final SupabaseClient _supabaseClient;
  final HttpFailureHandler _httpFailureHandler;

  @override
  HttpFailureHandler get httpFailureHandler => _httpFailureHandler;
}
